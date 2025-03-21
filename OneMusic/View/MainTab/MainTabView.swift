//
//  MainTabView.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/11.
//

import SwiftUI

struct MainTabView: View {
    // 核心环节对象
    @StateObject var mainVM =  MainViewModel.share
    @StateObject var audioPlayer = AudioPlayerManager.shared
    @StateObject var songVM = SongViewModel()
    @StateObject var playlistVM = PlaylistViewModel()
    @StateObject var albumVM = AlbumViewModel()
    var body: some View {
        ZStack {
            
            // MARK: - 选择所展示的页面
            // 主要内容区域
            Group {
                if(mainVM.selectTab == 0) {
                    HomeView() // 显示主页
                }
                else if(mainVM.selectTab == 1) { // 显示资料库页面
                    LibraryView()
                        .environmentObject(songVM)
                        .environmentObject(playlistVM)
                        .environmentObject(albumVM)
                        .environmentObject(audioPlayer)
                        .onAppear {
                            songVM.loadSongs(page: 1)
                            print("强制刷新歌曲数量：\(songVM.songs.count)")
                        }
                }
                else if(mainVM.selectTab == 2) {
                    VStack {
                        Spacer()
                        Text("Personal")
                            .foregroundColor(.primaryText)
                        Spacer()
                    }
                    .frame(width: .screenWidth, height: .screenHeight)
                    .background(Color.bg)
                }
                else if(mainVM.selectTab == 3) {
                    VStack {
                        Spacer()
                        Text("Settings")
                            .foregroundColor(.primaryText)
                        Spacer()
                    }
                    .frame(width: .screenWidth, height: .screenHeight)
                    .background(Color.bg)
                }
            }
            .frame(width: .screenWidth, height: .screenHeight)
            .padding(.bottom, 44) // 为悬浮胶囊和 TabBar 预留部分控价
            
            Button {
                songVM.resetLibraryImportStatus()
            } label: {
                Text("重新设置导入状态")
            }


            // MARK: - 全局悬浮的music胶囊
            MusicPillView()
                .environmentObject(audioPlayer)
                .offset(y:300) // 悬浮在TabBar上方
            
            //MARK: - 底部导航按钮
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    // 主页
                    TabButton(title: "Home", icon: "home_tab", icon_focus: "home_tab_un", isSelect: mainVM.selectTab == 0) {// 点击之后的操作
                        mainVM.selectTab = 0
                    }
                    Spacer()
                    // 歌曲页
                    TabButton(title: "Library", icon: "songs_tab", icon_focus: "songs_tab_un", isSelect: mainVM.selectTab == 1) {// 点击之后选择页面位歌曲页
                        mainVM.selectTab = 1
                    }
                    Spacer()
                    // 个人页
                    TabButton(title: "Personal", icon: "personal_tab", icon_focus: "personal_tab_un", isSelect: mainVM.selectTab == 2) {// 点击之后选择页面为设置页
                        mainVM.selectTab = 2
                    }
                    Spacer()
                    // 设置页
                    TabButton(title: "Settings", icon: "setting_tab", icon_focus: "setting_tab_un", isSelect: mainVM.selectTab == 3) {// 点击之后选择页面为设置页
                        mainVM.selectTab = 3 // 修改ViewModel的参数
                    }
                    
                    Spacer()
    
                }
                .frame(height: 44)
                .padding(.bottom, .bottomInsets)
                .padding(.top, 10)
                .background(Color.bg)
                .shadow(radius: 5)
            }
            .padding(.bottom, .bottomInsets)
            // 采用 ViewModel 的参数
            SideMenuView(isShowing: $mainVM.isShowSideMenu)
        }
        .background(Color.bg)
        .ignoresSafeArea()
    }
}

#Preview {
    let mainVM = MainViewModel.share
    let audioPlayer = AudioPlayerManager.shared
    let songVM = SongViewModel(shouldLoadFromDatabase: false)
    // 创建测试数据
    let song1 = Song(
        id: 1,
        title: "Bulbel",
        duration: 35,
        filePath: "/Users/zhiye/Downloads/ENDER LILIES Quietus of the Knights Original Soundtrack/Bulbel.mp3",
        coverPath: "/Users/zhiye/Downloads/enderlilies.jpg",
        albumId: 87,
        artistId: nil,
        genreId: nil,
        releaseDate: nil,
        artistName: "Mili",
        albumTitle: "Ender Lilies SoundTrack",
        genreName: "Anime"
    )
    let song2 = Song(
        id: 2,
        title: "Compounding",
        duration: 240,
        filePath: "/Users/zhiye/Downloads/ENDER LILIES Quietus of the Knights Original Soundtrack/Compounding-Binary Haze Interactive,Mili.128.mp3",
        coverPath: "/Users/zhiye/Downloads/enderlilies.jpg",
        albumId: 87,
        artistId: nil,
        genreId: nil,
        releaseDate: nil,
        artistName: "Mili",
        albumTitle: "Ender Lilies SoundTrack",
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
    let playlist3 = Playlist(id: 3, name: "后摇滚", songs: [song4, song6], coverPath: "/Users/zhiye/Downloads/032981110B28104181EAF2562E102574.png")
    let playlist4 = Playlist(id: 4, name: "睡前轻音乐", songs: [song5, song6], coverPath: "/Users/zhiye/Downloads/1400x1400bb.jpg")
    let playlist5 = Playlist(id: 5, name: "杂", songs: [song4], coverPath: "/Users/zhiye/Downloads/preview_cover_4.jpg")
    
    // 初始化 PlaylistViewModel 并手动设置数据
    let playlistVM = PlaylistViewModel(playlists: [testPlaylist, emptyPlaylist, playlist3, playlist4, playlist5], currentPlaylistSongs: testSongs, currentPlaylistId: testPlaylist.id)

    // 创建专辑是实例数据
    let list1 = [song1, song2, song3]
    let list2 = [song4]
    let list3 = [song5]
    let list4 = [song6]
    
    // 创建专辑实例
    let album1 = Album(
        id: 1,
        title: "Ender Lilies SoundTrack",
        artistId: 56,
        releaseDate: nil,
        coverPath: "/Users/zhiye/Downloads/enderlilies.jpg",
        artistName: "Mili",
        songs: list1
    )
    let album2 = Album(
        id: 2,
        title: "Ender Magnolia SoundTrack",
        artistId: 87,
        releaseDate: nil,
        coverPath: "/Users/zhiye/Downloads/preview_cover_5.jpg",
        artistName: "Mili",
        songs: list2
    )
    let album3 = Album(
        id: 3,
        title: "album3",
        artistId: 187,
        releaseDate: nil,
        coverPath: "/Users/zhiye/Downloads/preview_cover_6.jpg",
        artistName: "Mili",
        songs: list3
    )
    let album4 = Album(
        id: 4,
        title: "album4",
        artistId: 7,
        releaseDate: nil,
        coverPath: "/Users/zhiye/Downloads/1400x1400bb.jpg",
        artistName: "Linkin Park",
        songs: list4
    )
    
    let albumVM = AlbumViewModel(
        albums: [album1, album2, album3, album4],
        currentAlbumSongs: list1,
        currentAlbumId: 1
    )
    songVM.songs = [song1, song2, song3, song4, song5, song6]
    return MainTabView()
        .environmentObject(mainVM)
        .environmentObject(audioPlayer)
        .environmentObject(songVM)
        .environmentObject(playlistVM)
        .environmentObject(albumVM)
}
