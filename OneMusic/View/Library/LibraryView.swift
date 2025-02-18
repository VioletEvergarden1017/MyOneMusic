//
//  LibraryView.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/11.
//

import SwiftUI

struct LibraryView: View {
    //MARK: - 环境对象
    @StateObject var mainVM = MainViewModel.share
    @EnvironmentObject private var songVM: SongViewModel
    @EnvironmentObject private var albumVM: AlbumViewModel
    @EnvironmentObject private var playlistVM: PlaylistViewModel
    @EnvironmentObject private var audioPlayer: AudioPlayerManager // 绑定播放器
    
    @State var selectTab: Int = 0
    
    // 全部专辑示例数据
    @State var allAlbum: NSArray = [
        [
              "image": "alb_1",
              "name": "Who You Are Is Not Enough",
              "artists": "Athletics",
              "songs": "10 Songs"
            ],
            [
              "image": "alb_2",
              "name": "Thriller",
              "artists": "Michael Jackson",
              "songs": "10 Songs"
            ],
            [
              "image": "alb_3",
              "name": "It Won't Be Soon. . ",
              "artists": "Maroon 5",
              "songs": "10 Songs"
            ],
            [
              "image": "alb_4",
              "name": "I Am... Yours",
              "artists": "Beyonce",
              "songs": "10 Songs"
            ],
            [
              "image": "alb_5",
              "name": "Earth song",
              "artists": "Michael Jackson",
              "songs": "10 Songs"
            ],
            [
              "image": "alb_6",
              "name": "Smooth criminal",
              "artists": "Michael Jackson",
              "songs": "10 Songs"
            ]
    ]
    // 一排网格
    var columGrid = [
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible(), spacing: 5)
    ]
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                // MARK: - 顶部栏
                VStack {
                    
                    ScrollView {
                        
                        // 打开侧边栏
                        HStack(spacing: 15) {
                            Button {
                                print("Open SideMenu")
                                mainVM.isShowSideMenu = true // 侧滑是否展示
                            } label: {// About 侧滑页
                                Image("menu")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                            }
                            
                            Spacer()
                            
                            // 标题
                            Text("Library")
                                .font(.customfont(.bold, fontSize: 18))
                                .foregroundColor(.primaryText80)
                            
                            Spacer()
                            
                            // 搜索按钮
                            Button { // 点击之后的操作
                                
                            } label: {
                                Image("search")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.primaryText)
                            }
                            
                        }
                        .padding(.top, .topInsets)
                        .padding(.horizontal, 20)
                        
                        // MARK: - 跳转列表
                        VStack {
                            NavigationLink {
                                SongsView()
                                    .environmentObject(playlistVM)
                                    .environmentObject(songVM)
                                    .environmentObject(audioPlayer)
                            } label: {
                                ListTabView(btnImage: "l_song", btnName: "Songs")
                            }
                            NavigationLink {
                                AlbumsView()
                                    .environmentObject(playlistVM)
                                    .environmentObject(albumVM)
                                    .environmentObject(audioPlayer)
                            } label:{
                                ListTabView(btnImage: "l_album", btnName: "Albums")
                            }
                            NavigationLink() {
                                PlaylistsView()
                                    .environmentObject(playlistVM)
                                    .environmentObject(audioPlayer)
                            } label: {
                                ListTabView(btnImage: "l_playlist", btnName: "Playlists")
                            }
                            NavigationLink(destination: ArtistsView()) {
                                ListTabView(btnImage: "l_artist", btnName: "Artists")
                            }
                            NavigationLink(destination: GenresView()) {
                                ListTabView(btnImage: "l_genre", btnName: "Genres")
                            }
                        }
                        
                        // MARK: - 最近添加至资料库
                        ViewAllSection(title: "Recently Added") {
                            
                        }// 文字组件
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        
                        // MARK: - Recently Added 网格视图部分
                        
                        LazyVGrid(columns: columGrid, spacing: 15) {
                            ForEach (0..<allAlbum.count, id: \.self) { index in
                                let sObj = allAlbum[index] as? NSDictionary ?? [:]
                                NavigationLink {
                                    //AlbumDetailsView()
                                } label: {
                                    RecentlyAddCell(sObj: sObj)
                                }
                            }
                        }
                        
                        // 仅仅用做占位
                        TabView() {
                            
                        }
                        .tabViewStyle(PageTabViewStyle( indexDisplayMode: .never))
                        .padding(.bottom, .bottomInsets + 40)
                    }
                    Spacer()
                }
            }
            .onAppear{
                UITabBar.appearance().isHidden = true
            }
            .frame(width: .screenWidth, height: .screenHeight)
            .background(Color.bg)
            .navigationTitle("")
            .navigationBarBackButtonHidden()
            .navigationBarHidden(true)
            .ignoresSafeArea()
        }
    }
}



#Preview {
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
    
    
    return VStack {
        LibraryView()
            .environmentObject(audioPlayer)
            .environmentObject(playlistVM)
            .environmentObject(songVM)
            .environmentObject(albumVM)
        
//        MusicPillView()
//            .environmentObject(audioPlayer)
    }
}
