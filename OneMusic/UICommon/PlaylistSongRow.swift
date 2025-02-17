//
//  PlaylistSongRow.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/17.
//

import SwiftUI

struct PlaylistSongRow: View {
    @EnvironmentObject var playlistVM: PlaylistViewModel
    @EnvironmentObject var audioPlayer: AudioPlayerManager
    let song: Song // 使用 Song 模型
    
    var body: some View {
        Button(action: {
            print("你按下了PlaylistSongRow:调制文字，设置播放队列并播放当前你按下的歌曲")
            DispatchQueue.main.async {
                audioPlayer.setupQueue(tracks: playlistVM.currentPlaylistSongs, startIndex: playlistVM.currentPlaylistSongs.firstIndex(of: song) ?? 0)
                audioPlayer.playPause()
            }
        }) { // 按钮UI样式
            HStack(spacing: 15) {
                Text(String(getIndex(song: song)))
                    .font(.customfont(.regular, fontSize: 17))
                    .foregroundColor(Color.primaryText60)
                
                VStack(alignment: .leading) {
                    Text(song.title)
                        .font(.customfont(.regular, fontSize: 17))
                        .foregroundColor(Color.primaryText)
                        .lineLimit(1)
                }
                
                Spacer()
                Text(song.artistName ?? "unkonwn")
                    .font(.customfont(.bold, fontSize: 13))
                    .foregroundColor(Color.primaryText35)
                    .lineLimit(1)
                
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
                Divider()
                // 从当前歌单移除（如果有当前歌单）
                if let currentPlaylistId = playlistVM.currentPlaylistId {
                    Button("从本歌单移除") {
                        playlistVM.removeSongFromCurrentPlaylist(songId: song.id)
                    }
                }
            }
        }
        .onDisappear {
            print("调试信息：这个单元格消失了")
        }
    }
    // 格式化歌曲时长
    private func formatDuration(_ duration: Int) -> String {
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func getIndex(song: Song) -> Int {
        return playlistVM.currentPlaylistSongs.firstIndex(of: song) ?? 0
    }
}

private struct MenuTextBtn: View {
    @State var text: String = ""
    @State var img: String = ""
    
    var body: some View {
        
        Button {
            // 按下按钮的操作
        } label: {
            HStack {
                Text(text)
                    .font(.customfont(.regular, fontSize: 17))
                Spacer()
                Image(img)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .scaledToFit()
            }
            .background(Color.bg)
        }

    }
}

#Preview {
    let playlistVM = PlaylistViewModel()
    let audioPlayer = AudioPlayerManager.shared
    let song = Song(
        id: 34,
        title: "CountingStars",
        duration: 345,
        filePath: "/Users/zhiye/Downloads/6005970A0Q9.mp3",
        coverPath: "/Users/zhiye/Downloads/EGOIST-All-Alone-With-You.jpg",
        albumId: nil,
        artistId: nil,
        genreId: nil,
        releaseDate: nil,
        artistName: "OneRepublic",
        albumTitle: "Native",
        genreName: "Pop"
    )
    playlistVM.playlists = [
        Playlist(id: 1, name: "我的最爱", songs: [], coverPath: nil),
        Playlist(id: 2, name: "最近添加", songs: [], coverPath: nil)
    ]
    playlistVM.currentPlaylistId = 1
    playlistVM.currentPlaylistSongs = [song]
    
    return PlaylistSongRow(song: song)
        .environmentObject(playlistVM)
        .environmentObject(audioPlayer)
        .background(Color.bg)
}

