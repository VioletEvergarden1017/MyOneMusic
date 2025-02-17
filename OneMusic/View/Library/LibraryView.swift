//
//  LibraryView.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/11.
//

import SwiftUI

struct LibraryView: View {
    // 环境对象
    @StateObject var mainVM = MainViewModel.share
    @EnvironmentObject private var viewModel: SongViewModel // ViewModel
    @EnvironmentObject var playlistVM: PlaylistViewModel
    @EnvironmentObject var audioPlayer: AudioPlayerManager // 绑定播放器
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
                        
                        // 页面列表
                        VStack {
                            // MARK: - 点击跳转至歌曲页面
                            NavigationLink(destination: SongsView()) {
                                ListTabView(btnImage: "l_song", btnName: "Songs")
                            }
                            NavigationLink(destination: AlbumsView()) {
                                ListTabView(btnImage: "l_album", btnName: "Albums")
                            }
                            NavigationLink(destination: ArtistsView()) {
                                ListTabView(btnImage: "l_artist", btnName: "Artists")
                            }
                            NavigationLink(destination: PlaylistsView()) {
                                ListTabView(btnImage: "l_playlist", btnName: "Playlists")
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
    LibraryView()
}
