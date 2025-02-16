//
//  PreviewData.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/15.
//

import Foundation
// 新建 PreviewData.swift
struct PreviewData {
    static func testPlaylists() -> Playlist {
        Playlist(
            id: 1,
            name: "测试歌单",
            songs: testSongs(),
            coverPath: "/Users/zhiye/Downloads/EGOIST-All-Alone-With-You.jpg"
        )
    }
    
    static func testSongs() -> [Song] {
        (1...10).map {
            Song(
                id: Int64($0),
                title: "测试歌曲 \($0)",
                duration: 240,
                filePath: "/path/to/song\($0).mp3",
                coverPath: Bundle.main.path(forResource: "preview_cover_\($0%4)", ofType: "jpg"),
                albumId: nil,
                artistId: nil,
                genreId: nil,
                releaseDate: Date()
            )
        }
    }
    
    // 新增测试数据代码
    static func testSong(_ index: Int) -> Song {
        Song(
            id: Int64(index),
            title: "歌曲 \(index)",
            duration: 180 + Int.random(in: 0...300),
            filePath: "/Users/zhiye/Downloads/6005970A0Q9.mp3",
            coverPath: Bundle.main.path(forResource: "preview_cover_\(index%4)", ofType: "jpg"),
            albumId: nil,
            artistId: nil,
            genreId: nil,
            releaseDate: Date(),
            artistName: "艺术家 \(index)",
            albumTitle: "专辑 \(index)",
            genreName: "流派 \(index)"
        )
    }
    
    static func testPlaylist(_ id: Int64) -> Playlist {
        Playlist(
            id: id,
            name: "测试歌单 \(id)",
            songs: (1...6).map { testSong($0) },
            coverPath: Bundle.main.path(forResource: "preview_cover_\(Int(id)%4)", ofType: "jpg")
        )
    }
}
