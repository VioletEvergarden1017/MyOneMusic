//
//  AlbumDetailsView.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/11.
//

import SwiftUI

struct AlbumDetailsView: View {
    // MARK: - 页面环境变量
    @EnvironmentObject private var albumVM: AlbumViewModel
    @EnvironmentObject private var playlistVM: PlaylistViewModel
    @EnvironmentObject private var audioPlayer: AudioPlayerManager
    @Environment(\.presentationMode) var presentationMode
    
    let album: Album

    var body: some View {
        
        VStack {
            
            ScrollView {
                // MARK: - 专辑信息部分
                AlbumDetailCell(album: album)
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
                
                // 专辑曲目部分
                LazyVStack {
                    ForEach(albumVM.currentAlbumSongs) { song in
                        AlbumnSongRow(song: song)
                            .environmentObject(audioPlayer)
                            .environmentObject(playlistVM)
                            .environmentObject(albumVM)
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
                addBtn
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
    
    // MARK: - 添加至资料库按钮
    private var addBtn: some View {
        Button {
            // 将专辑添加至资料库
            
        } label: {
            Image("navi_add")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
        }

    }
    
    // MARK: - 添加至资料库按钮
    private var moreBtn: some View {
        Button {
            // 将专辑添加至资料库
            
        } label: {
            Image("navi_more")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
        }

    }
}

#Preview {
    // 预览环境变量设置
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
    let enderLiliesAlbum = [song1, song2, song3, song4, song5, song6]
    
    // 创建专辑实例
    let album = Album(
        id: 87,
        title: "Ender Lilies SoundTrack",
        artistId: 87,
        releaseDate: nil,
        coverPath: "/Users/zhiye/Downloads/enderlilies.jpg",
        artistName: "Mili",
        songs: enderLiliesAlbum
    )


    // 初始化 AlbumViewModel 并手动设置数据
    let albumVM = AlbumViewModel(
        albums: [album],
        currentAlbumSongs: enderLiliesAlbum,
        currentAlbumId: 87
    )
    
    return AlbumDetailsView(album: album)
        .environmentObject(audioPlayer)
        .environmentObject(albumVM)
        .environmentObject(playlistVM)
}
