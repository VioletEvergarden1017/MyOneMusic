//
//  AlbumViewModel.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/17.
//

import Foundation

class AlbumViewModel: ObservableObject {
    // MARK: - 专辑发布属性
    @Published var albums: [Album] = []      // 所有专辑
    @Published var currentAlbumSongs: [Song] // 当前专辑的歌曲
    @Published var currentAlbumId: Int64?    // 当前专辑ID
    
    
    // 从数据库初始化的主初始化方法
    
    
    // MARK: - 从数据库当中加载数据
    func loadAlbums() {
        do {
            albums = try DatabaseManager.shared.fetchAlbums()
        } catch {
            print("Error loading a albums: \(error)")
        }
    }
    
    func loadSongsForAlbum(albumId: Int64) {
        currentAlbumId = albumId
        do {
            currentAlbumSongs = try DatabaseManager.shared.fetchSongsForAlbum(albumId: albumId)
        } catch {
            print("Error loading songs for album: \(error)")
        }
    }
    
    // MARK: - 为 Preview 提供手动初始化方法
    init(albums: [Album] = [], currentAlbumSongs: [Song] = [], currentAlbumId: Int64? = nil) {
        self.albums = albums
        self.currentAlbumSongs = currentAlbumSongs
        self.currentAlbumId = currentAlbumId
    }
}
