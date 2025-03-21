//
//  SongViewModel.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/14.
//


import Foundation
import Combine
import SwiftUI
import UIKit
import UniformTypeIdentifiers
import AVFoundation

class SongViewModel: ObservableObject {
    // MARK: - 发布属性
    @Published var songs: [Song] = [] // 当前显示的歌曲列表
    @Published var isLoading: Bool = false // 是否正在加载数据
    @Published var errorMessage: String? = nil // 错误信息
    @Published var currentPage: Int = 1 // 当前分页
    @Published var totalSongs: Int = 0 // 总歌曲数
    @Published var isShowingFilePicker: Bool = false // 控制文件选择器的显示
    @Published var newSongTitle: String = "" // 新歌曲标题
    @Published var newSongArtist: String = "" // 新歌曲艺术家
    @Published var newSongAlbum: String = "" // 新歌曲专辑
    @Published var newSongCoverImage: UIImage? = nil // 新歌曲封面
    
    // 为实机预览增加自动刷新标志位为了
    @Published var shouldAutoRefresh: Bool = false
    let pageSize: Int = 20 // 每页显示的歌曲数量
    private var cancellables = Set<AnyCancellable>() // Combine 订阅管理
    
    // MARK: - 标志位，用于控制是否从数据库当中读取数据，还是单纯在preview当中显示
    var shouldLoadFromDatabase: Bool = true
    // MARK: - 初始化
    init(shouldLoadFromDatabase: Bool = true) {
        self.shouldLoadFromDatabase = shouldLoadFromDatabase
        if shouldLoadFromDatabase {
            // 初始化时加载第一页数据
            print("使用数据库当中的数据")
            loadSongs()
        } else { print("预览模式跳过初始化") }
    }
    
    // MARK: - 加载歌曲
    func loadSongs(page: Int = 1) {
        //guard shouldAutoRefresh else { return }
        // 修改判断逻辑
        guard shouldLoadFromDatabase else {
            print("预览模式跳过数据库加载")
            isLoading = false
            return
        }
        guard !isLoading else { return } // 避免重复加载
        
        isLoading = true
        errorMessage = nil
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            do {
                // 从数据库加载歌曲
                let newSongs = try DatabaseManager.shared.fetchSongs(page: page, pageSize: self.pageSize)
                let totalSongs = try DatabaseManager.shared.fetchTotalSongCount()
                
                DispatchQueue.main.async {
                    if page == 1 {
                        self.songs = newSongs // 如果是第一页，直接替换
                    } else {
                        self.songs.append(contentsOf: newSongs) // 否则追加数据
                    }
                    self.totalSongs = totalSongs
                    self.currentPage = page
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "加载歌曲失败: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
        
        DispatchQueue.main.async {
            // 新增自动刷新触发
            if self.shouldAutoRefresh {
                self.objectWillChange.send()
                self.shouldAutoRefresh = false
            }
        }
        
    }
    
    // MARK: - 加载下一页
    func loadNextPage() {
        guard !isLoading, currentPage * pageSize < totalSongs else { return }
        loadSongs(page: currentPage + 1)
    }
    
    // MARK: - 刷新数据
    func refresh() {
        loadSongs(page: 1) // 重新加载第一页
    }
    
    // MARK: - 搜索歌曲
    func searchSongs(query: String) {
        guard !query.isEmpty else {
            loadSongs(page: 1) // 如果查询为空，恢复显示所有歌曲
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            do {
                let searchResults = try DatabaseManager.shared.searchSongs(query: query)
                DispatchQueue.main.async {
                    self.songs = searchResults
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "搜索失败: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
    
    // MARK: - 删除歌曲
    func deleteSong(at indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let song = songs[index]
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            do {
                try DatabaseManager.shared.deleteSong(songId: song.id)
                DispatchQueue.main.async {
                    self.songs.remove(at: index) // 从列表中移除
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "删除失败: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // MARK: - 更新歌曲信息
    func updateSong(_ song: Song) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            do {
                try DatabaseManager.shared.updateSong(song)
                DispatchQueue.main.async {
                    if let index = self.songs.firstIndex(where: { $0.id == song.id }) {
                        self.songs[index] = song // 更新列表中的歌曲信息
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "更新失败: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // MARK: - 获取歌曲封面
    func getCoverImage(for song: Song) -> UIImage? {
        if let cachedImage: UIImage = CacheManager.shared.getMemoryCache(forKey: "song_cover_\(song.id)") {
            return cachedImage
        }
        
        if let coverPath = song.coverPath,
           let image = UIImage(contentsOfFile: coverPath) {
            CacheManager.shared.setMemoryCache(image, forKey: "song_cover_\(song.id)")
            return image
        }
        
        return nil
    }
    
    // MARK: - 上传本地音乐
    func uploadLocalSong(fileURL: URL) {
        // 检查文件格式
        guard fileURL.pathExtension.lowercased() == "mp3" else {
            errorMessage = "仅支持上传 .mp3 文件"
            return
        }
        
        // 解析 MP3 元数据
        let metadata = parseMP3Metadata(fileURL: fileURL)
        
        // 将文件复制到应用的文档目录
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentsDirectory.appendingPathComponent(fileURL.lastPathComponent)
        
        do {
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            try FileManager.default.copyItem(at: fileURL, to: destinationURL)
        } catch {
            errorMessage = "文件复制失败: \(error.localizedDescription)"
            return
        }
        
        // 保存封面图片到文档目录
        var coverPath: String? = nil
        if let coverImage = newSongCoverImage,
            let imageData = coverImage.jpegData(compressionQuality: 0.8) {
            let coverFileName = UUID().uuidString + ".jpg"
            let coverURL = documentsDirectory.appendingPathComponent(coverFileName)
            do {
                try imageData.write(to: coverURL)
                coverPath = coverURL.path
            } catch {
                errorMessage = "封面保存失败: \(error.localizedDescription)"
                return
            }
        }
        
        // 创建 Song 对象
        let newSong = Song(
            id: 0, // ID 由数据库自动生成
            title: newSongTitle.isEmpty ? fileURL.lastPathComponent : newSongTitle,
            duration: 0, // 需要解析 MP3 文件获取时长
            filePath: destinationURL.path,
            coverPath: coverPath,
            albumId: nil,
            artistId: nil,
            genreId: nil,
            releaseDate: nil,
            artistName: newSongArtist.isEmpty ? "未知艺术家" : newSongArtist,
            albumTitle: newSongAlbum.isEmpty ? "未知专辑" : newSongAlbum,
            genreName: nil
        )
        
        // 保存到数据库
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            do {
                try DatabaseManager.shared.insertSong(song: newSong)
                DispatchQueue.main.async {
                    self.loadSongs(page: 1) // 刷新列表
                    self.clearForm() // 清空表单
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "保存歌曲失败: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // MARK: - 清空表单
    func clearForm() {
        newSongTitle = ""
        newSongArtist = ""
        newSongAlbum = ""
        newSongCoverImage = nil
    }
    
    
}

// MARK: - 解析元数据拓展
//extension SongViewModel {
//
//    // 解析 MP3 文件的元数据
//    func parseMP3Metadata(fileURL: URL) -> (duration: Int, artist: String?, album: String?) {
//        let asset = AVAsset(url: fileURL)
//        var duration = 0
//        var artist: String? = nil
//        var album: String? = nil
//
//        // 获取时长
//        duration = Int(CMTimeGetSeconds(asset.duration))
//
//        // 获取元数据
//        let metadata = asset.metadata
//        for item in metadata {
//            switch item.commonKey?.rawValue {
//            case "artist":
//                artist = item.stringValue
//            case "albumName":
//                album = item.stringValue
//            default:
//                break
//            }
//        }
//
//        return (duration, artist, album)
//    }
//}


// MARK: - 插入测试数据
extension SongViewModel {
    
    // 手动插入一部分数据
    func insertTestData() {
        let song1 = Song(
            id: 1,
            title: "All Alone With You1111",
            duration: 395,
            filePath: "/Users/zhiye/Downloads/6005970A0Q9.mp3",
            coverPath: "/Users/zhiye/Downloads/EGOIST-All-Alone-With-You.jpg",
            albumId: nil,
            artistId: nil,
            genreId: nil,
            releaseDate: nil,
            artistName: "EGOIST111",
            albumTitle: "Extra Terrestrial Biological Entities",
            genreName: "Anime"
        )
        
        let song2 = Song(
            id: 2,
            title: "Sample Song",
            duration: 240,
            filePath: "/Users/zhiye/Downloads/6005970A0Q9.mp3",
            coverPath: "/Users/zhiye/Downloads/preview_cover_4.jpg",
            albumId: nil,
            artistId: nil,
            genreId: nil,
            releaseDate: nil,
            artistName: "Sample Artist",
            albumTitle: "Sample Album",
            genreName: "Pop"
        )
        
        do {
            try DatabaseManager.shared.insertSong(song: song1)
            try DatabaseManager.shared.insertSong(song: song2)
            print("测试数据已插入数据库")
        } catch {
            print("插入测试数据失败: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 添加专用的预览初始化方法
    static func preview(songs: [Song]) -> SongViewModel {
        let viewModel = SongViewModel()
        viewModel.songs = songs
        viewModel.shouldLoadFromDatabase = false
        return viewModel
    }
}

// MARK: - 统一播放协议
extension SongViewModel: PlayableSource {
    var queue: [Song] {
        self.songs
    }
}

// MARK: - 实现文件夹读入数据(实机演示拓展)
extension SongViewModel {

    // MARK: - 辅助方法
    private func findCoverInDirectory(url: URL, extensions: [String]) -> String? {
        let preferredNames = ["cover", "folder", "album"]
        for name in preferredNames {
            for ext in extensions {
                let coverURL = url.appendingPathComponent("\(name).\(ext)")
                if FileManager.default.fileExists(atPath: coverURL.path) {
                    return coverURL.path
                }
            }
        }
        return nil
    }
    
    
    
    // 增强版元数据解析
    private func parseMP3Metadata(fileURL: URL) -> (duration: Int, title: String?, artist: String?, album: String?, genre: String?, releaseDate: Date?,  coverPath: String?) {
        let asset = AVAsset(url: fileURL)
        var duration = Int(CMTimeGetSeconds(asset.duration))
        var title: String? = nil
        var artist: String? = nil
        var album: String? = nil
        var releaseDate: Date?
        var genre: String? = nil
        
        var coverPath: String? = nil
        
        // 解析文本元数据
        for item in asset.metadata {
            guard let key = item.commonKey?.rawValue else { continue }
            
            switch key {
            case "title":
                title = item.stringValue
            case "artist":
                artist = item.stringValue
            case "albumName":
                album = item.stringValue
            case "type":
                genre = item.stringValue
            case "creationDate":
                        // 尝试解析日期（格式如 "2023-01-01"）
                        if let dateString = item.stringValue {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"
                            releaseDate = formatter.date(from: dateString)
                        }
            default:
                break
            }
        }
        
        // 解析专辑封面
        if let artworkData = asset.metadata.first(where: { $0.commonKey?.rawValue == "artwork" })?.dataValue,
           let image = UIImage(data: artworkData) {
            let fileName = "\(UUID().uuidString).jpg"
            let coverURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                .appendingPathComponent(fileName)
            
            do {
                try image.jpegData(compressionQuality: 0.8)?.write(to: coverURL)
                coverPath = coverURL.path
            } catch {
                print("封面保存失败: \(error)")
            }
        }
        
        return (duration, title, artist, album, genre, releaseDate, coverPath)
    }
    
}



// 定义 UserDefaults 的 Key
extension UserDefaults {
    static let hasImportedMusicLibraryKey = "hasImportedMusicLibrary"
}

extension SongViewModel {
    func resetLibraryImportStatus() {
        UserDefaults.standard.set(false, forKey: UserDefaults.hasImportedMusicLibraryKey)
        print("导入状态已重置")
    }
}

// SongViewModel.swift 新增扩展方法
extension SongViewModel {
    func getDefaultCover(for album: String) -> String? {
        let libraryURL = Bundle.main.resourceURL!
            .appendingPathComponent("OneMusicLibrary")
            .appendingPathComponent(album)
        
        let coverExtensions = ["jpg", "jpeg", "png"]
        for ext in coverExtensions {
            let coverURL = libraryURL.appendingPathComponent("cover.\(ext)")
            if FileManager.default.fileExists(atPath: coverURL.path) {
                return coverURL.path
            }
        }
        return nil
    }
}

