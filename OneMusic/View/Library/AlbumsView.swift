//
//  AlbumsView.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/11.
//

import SwiftUI

struct AlbumsView: View {
    // MARK: - 环境变量设置
    @Environment(\.presentationMode) var presentationMode // 声明页面环境参数
    @EnvironmentObject private var playlistVM: PlaylistViewModel // ViewModel
    @EnvironmentObject private var albumVM: AlbumViewModel
    @EnvironmentObject private var audioPlayer: AudioPlayerManager
    @State var searchText: String = "" // 需要搜索的歌曲名字
    // 专辑示例数据
    @State var allAlb: NSArray = [
        [
              "image": "alb_1",
              "name": "History",
              "artists": "Michael Jackson",
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
    var columnGrid = [
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible(), spacing: 5)
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                MySearchBar(text: $searchText)
                    .padding(.top, 120)
                
                // 专辑滚动界面
                ScrollView {
                    LazyVGrid(columns: columnGrid, spacing: 15) {
                        ForEach (albumVM.albums) { album in
                            NavigationLink {
                                AlbumDetailsView(album: album)
                                    .environmentObject(playlistVM)
                                    .environmentObject(albumVM)
                                    .environmentObject(audioPlayer)
                                    .onAppear {
                                        albumVM.currentAlbumSongs = album.songs
                                    }
                            } label: {
                                AlbumCell(album: album)
                            }
                        }
                    }
                    .padding(15)
                    
                }
                .padding(.bottom, .bottomInsets + 40)
            }

            .frame(width: .screenWidth, height: .screenHeight)
            .background(Color.bg)
            .ignoresSafeArea()
            
        }
        .navigationBarBackButtonHidden(true)  // 隐藏系统自带的返回以实现自定义返回按钮
        .navigationBarItems(leading: backBtn) // 实现自定义返回
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Albums")
                    .font(.customfont(.bold, fontSize: 17))
                    .foregroundColor(Color.primaryText80)
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
}

#Preview {
    let playlistVM = PlaylistViewModel()
    let audioPlayer = AudioPlayerManager.shared
    
    let song1 = Song(
        id: 1,
        title: "Bulbel",
        duration: 35,
        filePath: "/Users/zhiye/Downloads/ENDER LILIES Quietus of the Knights Original Soundtrack/Bulbel.mp33",
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
    // 声明歌曲数组
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
    
    AlbumsView()
        .environmentObject(playlistVM)
        .environmentObject(albumVM)
        .environmentObject(audioPlayer)
}
