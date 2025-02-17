//
//  PlaylistViewModel.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/15.
//

// PlaylistViewModel.swift
import Foundation

class PlaylistViewModel: ObservableObject {
    @Published var playlists: [Playlist] = []
    @Published var currentPlaylistSongs: [Song] = []
    @Published var currentPlaylistId: Int64? // 当前歌单ID
    
    // MARK: - 标志位，用于控制是否从数据库当中读取数据，还是单纯在preview当中显示
    var shouldLoadPlaylistFromDatabase: Bool = true
    
    // 添加一个初始化方法，用于在 Preview 中手动设置数据
    init(playlists: [Playlist] = [], currentPlaylistSongs: [Song] = [], currentPlaylistId: Int64? = nil) {
        self.playlists = playlists
        self.currentPlaylistSongs = currentPlaylistSongs
        self.currentPlaylistId = currentPlaylistId
    }
    
    // 加载所有歌单
    func loadPlaylists(shouldLoadPlaylistFromDatabase: Bool = true) {
        self.shouldLoadPlaylistFromDatabase = shouldLoadPlaylistFromDatabase
        if shouldLoadPlaylistFromDatabase {
            do {
                playlists = try DatabaseManager.shared.fetchPlaylists()
                // 加载每个歌单的歌曲数量
                for i in 0..<playlists.count {
                    // 因为要更新歌单detailed view 所以需要同时加载歌单里的歌词
                    playlists[i].songs = try DatabaseManager.shared.fetchSongsForPlaylist(playlistId: playlists[i].id)
                }
            } catch {
                print("Error loading playlists: \(error)")
            }
        } else { print("预览模式跳过初始化") }
    }
    
    // 创建新歌单
    func createPlaylist(name: String, coverPath: String? = nil) {
        do {
            let newId = try DatabaseManager.shared.createPlaylist(
                name: name,
                coverPath: coverPath ?? "/Users/zhiye/Downloads/032981110B28104181EAF2562E102574.png" // 使用默认封面
            )
            loadPlaylists() // 刷新列表
        } catch {
            print("Error creating playlist: \(error)")
        }
    }
    
    // 删除歌单
    func deletePlaylist(playlistId: Int64) {
        do {
            try DatabaseManager.shared.deletePlaylist(playlistId: playlistId)
            loadPlaylists()
        } catch {
            print("Error deleting playlist: \(error)")
        }
    }
    
    // 加载歌单详情
    func loadPlaylistSongs(playlistId: Int64) {
        currentPlaylistId = playlistId
        do {
            currentPlaylistSongs = try DatabaseManager.shared.fetchSongsForPlaylist(playlistId: playlistId)
        } catch {
            print("Error loading playlist songs: \(error)")
        }
    }
    
    // 添加歌曲到歌单
    func addSongToPlaylist(songId: Int64, playlistId: Int64) {
        guard let playlistID = currentPlaylistId else { return }
        do {
            try DatabaseManager.shared.addSongToPlaylist(songId: songId, playlistId: playlistId)
            loadPlaylistSongs(playlistId: playlistId) // 刷新当前歌单
        } catch {
            print("Error adding song to playlist: \(error)")
        }
    }
    
    // 从歌单当中删除歌曲(增加了获取当前歌单数据)
    func removeSongFromPlaylist(songId: Int64) {
        guard let playlistId = currentPlaylistId else { return }
        do {
            try DatabaseManager.shared.removeSongFromPlaylist(songId: songId, playlistId: playlistId)
            loadPlaylistSongs(playlistId: playlistId) // 刷新当前歌单
        } catch {
            print("Error removing song from playlist: \(error)")
        }
    }
}

extension PlaylistViewModel {
    
    func addCurrentSongToPlaylist(songId: Int64) {
        // 调试日志
        print("添加歌曲 \(songId) 到歌单 \(currentPlaylistId ?? -1)")
        
        guard let playlistId = currentPlaylistId else { return }
        do {
            try DatabaseManager.shared.addSongToPlaylist(songId: songId, playlistId: playlistId)
            
            let allSongs = currentPlaylistSongs
            // 更新 currentPlaylistSongs
            if let song = allSongs.first(where: { $0.id == songId }) {
                currentPlaylistSongs.append(song)
            }
            
            // 更新 playlists 中的数据
            if let index = playlists.firstIndex(where: { $0.id == playlistId }) {
                playlists[index].songs = currentPlaylistSongs
            }
        } catch {
            print("Error adding song: \(error)")
        }
    }

    func removeSongFromCurrentPlaylist(songId: Int64) {
        // 调试日志
        print("从歌单 \(currentPlaylistId ?? -1) 移除歌曲 \(songId)")
        guard let playlistId = currentPlaylistId else { return }
        do {
            try DatabaseManager.shared.removeSongFromPlaylist(songId: songId, playlistId: playlistId)
            
            // 更新 currentPlaylistSongs
            currentPlaylistSongs.removeAll { $0.id == songId }
            
            // 更新 playlists 中的数据
            if let index = playlists.firstIndex(where: { $0.id == playlistId }) {
                playlists[index].songs = currentPlaylistSongs
            }
        } catch {
            print("Error removing song: \(error)")
        }
    }
}

// MARK: - 统一播放协议拓展
extension PlaylistViewModel: PlayableSource {
    var queue: [Song] {
        currentPlaylistSongs // 当前歌单的歌曲列表
    }
}

