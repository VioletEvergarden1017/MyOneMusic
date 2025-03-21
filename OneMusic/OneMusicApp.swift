//
//  OneMusicApp.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/10.
//

import Foundation
import Combine
import SwiftUI
import UIKit
import UniformTypeIdentifiers
import AVFoundation

@main
struct OneMusicApp: App {
    @StateObject private var songVM = SongViewModel()
    @StateObject private var audioPlayer = AudioPlayerManager.shared
    @State private var initializationError: String?

    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainTabView()
                    .environmentObject(songVM)
                    .environmentObject(PlaylistViewModel())
                    .environmentObject(AlbumViewModel())
                    .environmentObject(audioPlayer)
            }
            .navigationViewStyle(.stack)
            .onAppear(perform: initializeDatabase)
        }
    }

    // MARK: - 初始化数据库（不依赖文件夹结构）
    private func initializeDatabase() {
        guard !UserDefaults.standard.bool(forKey: "hasImportedMusicLibrary") else {
            print("✅ 已存在数据，跳过初始化")
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                // 获取所有MP3文件
                let mp3Files = try findAllMP3Files()
                guard !mp3Files.isEmpty else {
                    throw NSError(domain: "初始化错误", code: 1, userInfo: [NSLocalizedDescriptionKey: "未找到任何MP3文件"])
                }
                
                // 插入数据库
                try mp3Files.forEach { url in
                    let song = try createSong(from: url)
                    try DatabaseManager.shared.insertSong(song: song)
                }
                
                UserDefaults.standard.set(true, forKey: "hasImportedMusicLibrary")
                print("🎉 成功导入 \(mp3Files.count) 首歌曲")
            } catch {
                DispatchQueue.main.async {
                    initializationError = error.localizedDescription
                    print("❌ 初始化失败: \(error)")
                }
            }
        }
    }
    
    // MARK: - 递归查找所有MP3文件
    private func findAllMP3Files() throws -> [URL] {
        guard let bundleURL = Bundle.main.resourceURL else {
            throw NSError(domain: "路径错误", code: 2, userInfo: [NSLocalizedDescriptionKey: "无法获取Bundle路径"])
        }
        
        let enumerator = FileManager.default.enumerator(
            at: bundleURL,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        )
        
        var mp3Files = [URL]()
        while let url = enumerator?.nextObject() as? URL {
            guard url.pathExtension.lowercased() == "mp3" else { continue }
            mp3Files.append(url)
        }
        return mp3Files
    }
    
    // MARK: - 创建Song对象
    private func createSong(from fileURL: URL) throws -> Song {
        // 获取所在目录名称作为专辑名
        let albumName = fileURL.deletingLastPathComponent().lastPathComponent
        // 查找同级目录中的封面
        let coverPath = findCoverInDirectory(fileURL.deletingLastPathComponent())
        
        return Song(
            id: 0,
            title: fileURL.deletingPathExtension().lastPathComponent, // 文件名作为标题
            duration: getDuration(fileURL: fileURL),
            filePath: fileURL.path,
            coverPath: coverPath,
            albumId: nil,
            artistId: nil,
            genreId: nil,
            releaseDate: nil,
            artistName: "未知艺术家",
            albumTitle: albumName,
            genreName: nil
        )
    }
    
    // MARK: - 查找封面
    private func findCoverInDirectory(_ directory: URL) -> String? {
        let coverNames = ["cover.jpg", "cover.png", "cover.jpeg"]
        return coverNames.first { name in
            let path = directory.appendingPathComponent(name).path
            return FileManager.default.fileExists(atPath: path)
        }.map { directory.appendingPathComponent($0).path }
    }
    
    // MARK: - 获取音频时长
    private func getDuration(fileURL: URL) -> Int {
        let asset = AVAsset(url: fileURL)
        return Int(CMTimeGetSeconds(asset.duration))
    }
}
