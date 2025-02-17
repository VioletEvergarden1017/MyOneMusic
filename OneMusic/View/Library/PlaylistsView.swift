//
//  PlaylistsView.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/11.
//

import SwiftUI

struct PlaylistsView: View {
    @Environment(\.presentationMode) var presentationMode // 声明页面环境参数
    @EnvironmentObject var playlistVM: PlaylistViewModel // 使用ViewModel
    @EnvironmentObject var audioPlayer: AudioPlayerManager
    
    // 状态变量
    @State private var showCreateAlert = false // 新建歌单弹窗
    @State private var newPlaylistName = ""    // 新歌单名字
    @State private var newPlaylistcover = ""   // 新歌单封面路径
    @State var searchText: String = "" // 需要搜索的歌单名字
    // 歌单示例数据

    
    var body: some View {
        NavigationStack {
            VStack {
                MySearchBar(text: $searchText)
                    .padding(.top, 120)
                
                // 歌单
                ScrollView {
                    ForEach(playlistVM.playlists) { playlist in
                        NavigationLink {
                            PlaylistDetailView(playlist: playlist)
                                .environmentObject(playlistVM)
                                .environmentObject(audioPlayer)
                                .onAppear {
                                    print("调试信息，进入了歌单详细页")
                                    // 添加了这段代码，当进入详细页面的时候将当前歌单的歌曲赋值给currentPlaylistSongs
                                    playlistVM.currentPlaylistSongs = playlist.songs
                                }
                        } label: {
                            PlaylistRow(playlist: playlist)
                        }
                        
                    }
                }
            }
            .padding(.bottom, .bottomInsets + 44)
            .frame(width: .screenWidth, height: .screenHeight)
            .background(Color.bg)
            .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)  // 隐藏系统自带的返回以实现自定义返回按钮
        .navigationBarItems(leading: backBtn) // 实现自定义返回
        .toolbar { // 导航栏功能按键
            ToolbarItem(placement: .principal) {
                Text("Playlists")
                    .font(.customfont(.bold, fontSize: 17))
                    .foregroundColor(Color.primaryText80)
            }
            ToolbarItem(placement: .primaryAction) {
                soryBtn
            }
            ToolbarItem(placement: .destructiveAction) {
                newBtn
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
                Text("Library")
                    .font(.customfont(.regular, fontSize: 17))
                    .foregroundColor(Color(hex: "C3FFCC"))
            }
            //.padding(.horizontal)
        }
    }

    // MARK: - 新建歌单按钮
    private var newBtn: some View {
        Button {
            // 将专辑添加至资料库
            showCreateAlert.toggle()
        } label: {
            Image("navi_add")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
        }
        .alert("新建歌单", isPresented: $showCreateAlert) {
            TextField("Name", text: $newPlaylistName)
            TextField("Coverpath", text: $newPlaylistcover)
            Button("创建") {
                guard !newPlaylistName.isEmpty else { return }
                playlistVM.createPlaylist(name: newPlaylistName)
                newPlaylistName = ""
            }
            Button("Cancel", role: .cancel) {}
        }
    }
    
    // MARK: - 排序按钮
    private var soryBtn: some View {
        Menu {
            // 将专辑添加至资料库

            PlaylistSortMenu(text: "All Playlists", img: "rm_play")
            PlaylistSortMenu(text: "Favorite", img: "rm_star")
            Divider()
            PlaylistSortMenu(text: "Title")
            PlaylistSortMenu(text: "Recently Added")
            PlaylistSortMenu(text: "Recently Played")
            PlaylistSortMenu(text: "Recently Updated")
            PlaylistSortMenu(text: "Playlist Type")
        } label: {
            Image("sort")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
        }

    }
}

// MARK: - 排序按钮菜单
private struct PlaylistSortMenu: View {
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

/**
 日志：再次解决初始化的问题。在PlaylistViewModel当中添加了一个手动初始化的方法用于预览数据
 */
#Preview {
    let audioPlayer = AudioPlayerManager.shared
    
    // 创建测试数据
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
    let song3 = Song(
        id: 3,
        title: "Lily",
        duration: 240,
        filePath: "/Users/zhiye/Downloads/ENDER LILIES Quietus of the Knights Original Soundtrack/Lily.mp3",
        coverPath: "/Users/zhiye/Downloads/enderlilies.jpg",
        albumId: 87,
        artistId: nil,
        genreId: nil,
        releaseDate: nil,
        artistName: "Mili",
        albumTitle: "Ender Lilies SoundTrack",
        genreName: "Anime"
    )
    let song4 = Song(
        id: 4,
        title: "Harmonious",
        duration: 240,
        filePath: "/Users/zhiye/Downloads/ENDER LILIES Quietus of the Knights Original Soundtrack/Harmonious.mp3",
        coverPath: "/Users/zhiye/Downloads/enderlilies.jpg",
        albumId: 87,
        artistId: nil,
        genreId: nil,
        releaseDate: nil,
        artistName: "Mili",
        albumTitle: "Ender Lilies SoundTrack",
        genreName: "Anime"
    )
    let song5 = Song(
        id: 5,
        title: "North",
        duration: 240,
        filePath: "/Users/zhiye/Downloads/ENDER LILIES Quietus of the Knights Original Soundtrack/North-Mili,Binary Haze Interactive.128.mp3",
        coverPath: "/Users/zhiye/Downloads/enderlilies.jpg",
        albumId: 87,
        artistId: nil,
        genreId: nil,
        releaseDate: nil,
        artistName: "Mili",
        albumTitle: "Ender Lilies SoundTrack",
        genreName: "Anime"
    )
    let song6 = Song(
        id: 6,
        title: "Rosart",
        duration: 240,
        filePath: "/Users/zhiye/Downloads/ENDER LILIES Quietus of the Knights Original Soundtrack/Rosary - Intro-Binary Haze Interactive,Mili.128.mp3",
        coverPath: "/Users/zhiye/Downloads/enderlilies.jpg",
        albumId: 87,
        artistId: nil,
        genreId: nil,
        releaseDate: nil,
        artistName: "Mili",
        albumTitle: "Ender Lilies SoundTrack",
        genreName: "Anime"
    )
    
    // 设置测试数据
    let testSongs = [song1, song2, song3, song4, song5, song6]
    let testPlaylist = Playlist(id: 1, name: "我的最爱", songs: testSongs, coverPath: "/Users/zhiye/Downloads/preview_cover_6.jpg")
    let emptyPlaylist = Playlist(id: 2, name: "最近收藏", songs: [song4, song5, song6], coverPath: "/Users/zhiye/Downloads/preview_cover_5.jpg")
    
    // 初始化 PlaylistViewModel 并手动设置数据
    let playlistVM = PlaylistViewModel(playlists: [testPlaylist, emptyPlaylist], currentPlaylistSongs: testSongs, currentPlaylistId: testPlaylist.id)
    
    return PlaylistsView()
        .environmentObject(playlistVM)
        .environmentObject(audioPlayer)
}
