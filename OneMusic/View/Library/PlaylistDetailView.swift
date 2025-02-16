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
    @Environment(\.presentationMode) var presentationMode // 声明页面环境参数: 展示状态
    var isPlay: Bool = false
    let playlist: Playlist
    
    var body: some View {
        
        VStack {
            
            ScrollView {
                // MARK: - 歌单信息部分
                VStack(alignment: .center,spacing: 10) {
                    Image("alb_1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 256, height: 256)
                        .cornerRadius(16)
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
                LazyVStack {
                    ForEach(playlistVM.currentPlaylistSongs) { song in
                        
                        AlbumnSongRow(song: song)
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
    let vm = PlaylistViewModel()
    
    // 创建测试数据
    let testSongs = PreviewData.testSongs()
    let testPlaylist = Playlist(id: 1, name: "我的最爱", songs: testSongs, coverPath: nil)
    let emptyPlaylist = Playlist(id: 2, name: "空歌单", songs: [], coverPath: nil)
    // 绑定数据
    vm.playlists = [testPlaylist, emptyPlaylist]
    vm.currentPlaylistSongs = testSongs
    vm.currentPlaylistId = testPlaylist.id
    
    return PlaylistDetailView(playlist: emptyPlaylist)
        .environmentObject(vm)
}
