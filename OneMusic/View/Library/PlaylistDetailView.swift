//
//  PlaylistDetailView.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/12.
//

import SwiftUI

struct PlaylistDetailView: View {
    // 状态变量
    @EnvironmentObject var playlistVM: PlaylistViewModel
    @EnvironmentObject var audioPlayer: AudioPlayerManager
    @Environment(\.presentationMode) var presentationMode // 声明页面环境参数: 展示状态
    var isPlay: Bool = false
    let playlist: Playlist
    
    var body: some View {
        
        VStack {
            
            ScrollView {
                // MARK: - 歌单信息部分
                VStack(alignment: .center,spacing: 10) {
                    if let uiImage = UIImage(contentsOfFile: playlist.coverPath ?? "") {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 256, height: 256)
                            .cornerRadius(16)
                    }
                    // 文字内容
                    VStack(spacing: 1) {
                        // 歌单明
                        Text(playlist.name)
                            .font(.customfont(.bold, fontSize: 23))
                            .foregroundColor(Color.primaryText)
                            .lineLimit(1)
                        // 更新时间
                        Text("Updated \(formattedUpdateTime())")
                            .font(.customfont(.bold, fontSize: 14))
                            .foregroundColor(Color.primaryText35)
                            .lineLimit(1)
                        // 歌单统计信息
                        Text("\(playlist.songs.count) songs, \(totalDurationString())")
                            .font(.customfont(.regular, fontSize: 14))
                            .foregroundColor(.primaryText28)
                            .frame(width: 240)
                            .lineLimit(1)
                    }
                }
                .frame(width: .screenWidth - 40)
                
                //MARK: - 播放按钮
                HStack(alignment: .center, spacing: 20) {
                    
                    Button {
                        // 顺序播放操作
                    } label: {
                        HStack(alignment: .center) {
                            Image("alb_play")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            Text("Play")
                                .font(.customfont(.bold, fontSize: 17))
                                .foregroundColor(.primaryText80)
                        }
                        .frame(width: 156, height: 60)
                        .background(Color.bg_light)
                        .cornerRadius(8)
                    }

                    Button {
                        // 随机播放操作
                    } label: {
                        HStack(alignment: .center) {
                            Image("alb_shuffle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            Text("Shuffle")
                                .font(.customfont(.bold, fontSize: 17))
                                .foregroundColor(.primaryText80)
                        }
                        .frame(width: 156, height: 60)
                        .background(Color.bg_light)
                        .cornerRadius(8)
                    }

                }
                
                // 歌单曲目部分
                VStack {
                    ForEach(playlistVM.currentPlaylistSongs) { song in
                        PlaylistSongRow(song: song)
                            .environmentObject(audioPlayer)
                            .environmentObject(playlistVM)
                            .onAppear {
                                print("歌曲单元格出现")
                            }
                            .onDisappear {
                                print("歌曲单元格消失")
                            }
                    }
                }

            }
            .padding(.top, .topInsets + 48)
        }
        .padding(.bottom, .bottomInsets + 44)
        .frame(width: .screenWidth, height: .screenHeight)
        .background(Color.bg)
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)  // 隐藏系统自带的返回以实现自定义返回按钮
        .navigationBarItems(leading: backBtn) // 实现自定义返回
        .toolbar {
            // 导航烂右侧功能
            ToolbarItem(placement: .primaryAction) {
                downloadBtn
            }
            ToolbarItem(placement: .destructiveAction) {
                moreBtn
            }
        }
        
    }
    
    // MARK: - 返回按钮
    private var backBtn: some View {
        Button(action: {
            // 实现自定义返回逻辑
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack(alignment: .center) {
                Image("back")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                // 对齐方式不好看所以先注释掉 “back” 文字
                Text("Album")
                    .font(.customfont(.regular, fontSize: 17))
                    .foregroundColor(Color(hex: "C3FFCC"))
            }
            //.padding(.horizontal)
        }
    }
    
    // MARK: - 下载歌曲按钮
    private var downloadBtn: some View {
        Button {
            // 选择歌单当中的歌曲进行下载
            
        } label: {
            Image("p_download")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
        }

    }
    
    // MARK: - 对歌单进行操作按钮
    private var moreBtn: some View {
        Button {
            // 对歌单进行操作
            
        } label: {
            Image("p_more")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
        }

    }
    
    // MARK: - 歌单计算属性
    // 新增计算属性
    private func formattedUpdateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: Date())
    }

    private func totalDurationString() -> String {
        let totalSeconds = playlist.songs.reduce(0) { $0 + $1.duration }
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        return "\(hours)h \(minutes) min"
    }
}


#Preview {
    let playlistVM = PlaylistViewModel()
    let audioPlayer = AudioPlayerManager.shared
    // 创建真实测试数据
    let song1 = Song(
       id: 1,
       title: "All Alone With You",
       duration: 35,
       filePath: "/Users/zhiye/Downloads/6005970A0Q9.mp3",
       coverPath: "/Users/zhiye/Downloads/EGOIST-All-Alone-With-You.jpg",
       albumId: nil,
       artistId: nil,
       genreId: nil,
       releaseDate: nil,
       artistName: "EGOIST",
       albumTitle: "Extra Terrestrial Biological Entities",
       genreName: "Anime"
   )
    let song2 = Song(
       id: 2,
       title: "Bible",
       duration: 240,
       filePath: "/Users/zhiye/Downloads/ENDER LILIES Quietus of the Knights Original Soundtrack/Bulbel.mp3",
       coverPath: "/Users/zhiye/Downloads/enderlilies.jpg",
       albumId: nil,
       artistId: nil,
       genreId: nil,
       releaseDate: nil,
       artistName: "Mili",
       albumTitle: "Sample Album",
       genreName: "Anime"
   )

    // 创建测试数据
    let testSongs = [song1, song2]
    let testPlaylist = Playlist(id: 1, name: "我的最爱", songs: testSongs, coverPath: "/Users/zhiye/Downloads/preview_cover_6.jpg")
    let emptyPlaylist = Playlist(id: 2, name: "空歌单", songs: [], coverPath: nil)
    // 绑定数据
    playlistVM.playlists = [testPlaylist, emptyPlaylist]
    playlistVM.currentPlaylistSongs = testSongs
    playlistVM.currentPlaylistId = testPlaylist.id
    
    return PlaylistDetailView(playlist: testPlaylist)
        .environmentObject(playlistVM)
        .environmentObject(audioPlayer)
}
