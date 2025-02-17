//
//  SongsView.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/12.
//

import SwiftUI

struct SongsCell: View {
    // MARK: - 环境变量
    let sObj: Song // 修改为不可变属性
    // 添加 PlaylistViewModel 以支持添加到歌单功能
    @EnvironmentObject var playlistVM: PlaylistViewModel
    @EnvironmentObject var audioPlayer: AudioPlayerManager
    @EnvironmentObject var songVM: SongViewModel
    
    var body: some View {
        Button(action: {
            // 设置播放队列并播放当前歌曲
            print("你按下了SongCell:调制文字，设置播放队列并播放当前你按下的歌曲")
            DispatchQueue.main.async {
                audioPlayer.setupQueue(tracks: songVM.songs, startIndex: songVM.songs.firstIndex(of: sObj) ?? 0)
                audioPlayer.playPause()
            }
        }) {
            HStack {
                // 对封面加载惊喜优化
                Group {
                    if let uiImage = UIImage(contentsOfFile: sObj.coverPath ?? "") {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image("default_cover")
                            .resizable()
                            .scaledToFit()
                    }
                }
                .frame(width: 64, height: 64)
                .cornerRadius(8)
                
                // MARK: - 歌曲信息
                VStack(alignment: .leading) {
                    Text(sObj.title)
                        .font(.customfont(.regular, fontSize: 17))
                        .foregroundColor(Color.primaryText)
                        .lineLimit(1)
                    Text(sObj.artistName ?? "Unkonwn Artist")
                        .font(.customfont(.regular, fontSize: 13))
                        .foregroundColor(Color.primaryText35)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Image("more")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .padding(.trailing, 10)
            }
            .background(Color.bg_light)
            .padding(.horizontal, 20)

            .frame(maxWidth: .infinity, maxHeight: 72)
            // 长按菜单
            .contextMenu {
                // 添加到歌单菜单
                Menu("添加到歌单") {
                    ForEach(playlistVM.playlists) { playlist in
                        Button(playlist.name) {
                            playlistVM.addCurrentSongToPlaylist(songId: sObj.id)
                        }
                    }
                }
                
                // 其他操作
                Button("Delete From Library") {
                    // 调用删除逻辑
                }
            }
        }
        .cornerRadius(8)
        // 生命周期监控
        .onAppear {
            print("环境对象状态：",
                  "playlistVM: \(playlistVM)",
                  "audioPlayer: \(audioPlayer)")
            print("歌曲单元格出现：\(sObj.title)")
        }
        .onDisappear { print("歌曲单元格消失：\(sObj.title)") }
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

#Preview("歌曲单元格") {
    let song = Song(
        id: 1,
        title: "Counting Stars",
        duration: 234,
        filePath: "/Users/zhiye/Downloads/6005970A0Q9.mp3",
        coverPath: Bundle.main.path(forResource: "preview_cover_1", ofType: "jpg"),
        albumId: nil,
        artistId: nil,
        genreId: nil,
        releaseDate: nil,
        artistName: "OneRepublic",
        albumTitle: "Native",
        genreName: "Pop"
    )
    let songVM = SongViewModel(shouldLoadFromDatabase: false)
    songVM.songs = [song]
    let a_vm = AudioPlayerManager.shared
    let vm = PlaylistViewModel()
    vm.playlists = [
        Playlist(id: 1, name: "我的最爱", songs: [], coverPath: nil),
        Playlist(id: 2, name: "最近添加", songs: [], coverPath: nil)
    ]
    vm.currentPlaylistSongs = [song]
    return SongsCell(sObj: song)
        .environmentObject(vm)
        .environmentObject(a_vm)
        .environmentObject(songVM)
        //.background(Color.bg)
}
