//
//  AlbumnSongRow.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/13.
//

import SwiftUI

struct AlbumnSongRow: View {
    // 环境变量设置
    @EnvironmentObject var playlistVM: PlaylistViewModel
    @EnvironmentObject var albumVM: AlbumViewModel
    @EnvironmentObject var audioPlayer: AudioPlayerManager
    let song: Song // 使用 Song 模型
    
    var body: some View {
        Button(action: {
            audioPlayer.setupQueue(tracks: albumVM.currentAlbumSongs, startIndex: albumVM.currentAlbumSongs.firstIndex(of: song) ?? 0)
            audioPlayer.playPause()
        }) {
            HStack(spacing: 15) {
                Text(String(getIndex(song: song)))
                    .font(.customfont(.regular, fontSize: 17))
                    .foregroundColor(Color.primaryText60)
                
                VStack(alignment: .leading) {
                    Text(song.title)
                        .font(.customfont(.regular, fontSize: 17))
                        .foregroundColor(Color.primaryText)
                }
                
                Spacer()
                
                Text(formatDuration(song.duration))
                    .font(.customfont(.regular, fontSize: 17))
                    .foregroundColor(Color(hex: "#8aae92"))
            }
            .padding(.horizontal, 20)
            .frame(height: 45)
            // 更多操作按钮...
            .contextMenu {
                // 添加到歌单菜单
                Menu("添加到歌单") {
                    ForEach(playlistVM.playlists) { playlist in
                        Button(playlist.name) {
                            playlistVM.addCurrentSongToPlaylist(songId: song.id)
                        }
                    }
                }
            }
        }
    }
    
    // 格式化歌曲时长
    private func formatDuration(_ duration: Int) -> String {
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    // 获取当前曲目在专辑当中的位置
    private func getIndex(song: Song) -> Int {
        return albumVM.currentAlbumSongs.firstIndex(of: song) ?? 0
    }
    
}


#Preview {
    let albumVM = AlbumViewModel()
    let playlistVM = PlaylistViewModel()
    let audioPlayer = AudioPlayerManager.shared
    
    // 设置真实测试数据
    let song = Song(
        id: 34,
        title: "CountingStars",
        duration: 345,
        filePath: "/Users/zhiye/Downloads/6005970A0Q9.mp3",
        coverPath: "/Users/zhiye/Downloads/EGOIST-All-Alone-With-You.jpg",
        albumId: 9,
        artistId: nil,
        genreId: nil,
        releaseDate: nil,
        artistName: "OneRepublic",
        albumTitle: "Native",
        genreName: "Pop"
    )
    albumVM.currentAlbumSongs = [song]
    albumVM.currentAlbumId = 9
    playlistVM.playlists = [
        Playlist(id: 1, name: "我的最爱", songs: [], coverPath: nil),
        Playlist(id: 2, name: "最近添加", songs: [], coverPath: nil)
    ]
    return AlbumnSongRow(song: song)
        .environmentObject(audioPlayer)
        .environmentObject(albumVM)
        .environmentObject(playlistVM)
        .background(Color.bg)
        .padding(.bottom, 200)
}
