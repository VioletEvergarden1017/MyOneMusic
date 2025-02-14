//
//  SongViewModel.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/14.
//

import Foundation
import Combine

class SongViewModel: ObservableObject {
    @Published var songs: [Song] = []      // 存储歌曲列表
    @Published var errorMessage: String?   // 错误消息
    @Published var isLoading: Bool = false // 加载状态指示

    // 初始化时直接获取歌曲数据
    init() {
        fetchSongs()
    }

    // 加载所有歌曲
    func fetchSongs() {
        self.isLoading = true
        self.errorMessage = nil
        
        // 在后台线程执行数据库查询操作
        DispatchQueue.global(qos: .userInitiated).async {
            if let fetchedSongs = DatabaseManager.shared.fetchAllSongs() {
                DispatchQueue.main.async {
                    self.songs = fetchedSongs
                    self.isLoading = false
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load songs from the database."
                    self.isLoading = false
                }
            }
        }
    }

    // 添加一首歌曲
    func addSong(song: Song) {
        let title = song.title.isEmpty == true ? "Unknown" : song.title              // 默认值为 "Unknown"
        let artistId = song.artistId
        let albumId = song.albumId 
        let genreId = song.genreId
        let duration = song.duration
        let filePath = song.filePath.isEmpty ? "Unknown Path" : song.filePath   // 默认值为 "Unknown Path"
        let coverImage = song.coverImage.isEmpty == true ? Data() : song.coverImage       // 默认值为空的 Data
        
        // 异步执行插入操作
        DispatchQueue.global(qos: .userInitiated).async {
            // 调用数据库管理器进行插入
            DatabaseManager.shared.insertSong(title: title, artistId: artistId, albumId: albumId, genreId: genreId, duration: duration, file_path: filePath, coverImage: coverImage)
            
            // 测试数据插入传入是否成功
//            print("Title: \(title)")
//            print("File Path: \(filePath)")
            let fileURL = URL(fileURLWithPath: filePath)
            // 检查传递的路径是否有效
            if FileManager.default.fileExists(atPath: fileURL.path) {
                print("File exists at path: \(filePath)")
            } else {
                print("File does not exist at path: \(filePath)")
            }
            // 插入后刷新歌曲列表
            DispatchQueue.main.async {
                self.fetchSongs()
            }
        }
    }

    // 更新歌曲标题
    func updateSongTitle(songId: Int64, newTitle: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            DatabaseManager.shared.updateSongTitle(songId: songId, newTitle: newTitle)
            
            // 更新后刷新歌曲列表
            self.fetchSongs()
        }
    }

    // 删除一首歌曲
    func deleteSong(songId: Int64) {
        DispatchQueue.global(qos: .userInitiated).async {
            DatabaseManager.shared.deleteSong(songId: songId)
            
            // 删除后刷新歌曲列表
            self.fetchSongs()
        }
    }
    
}
