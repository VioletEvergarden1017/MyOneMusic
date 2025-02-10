//
//  HomeView.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/11.
//

import SwiftUI

struct HomeView: View {
    
    @State var textSearch: String = ""
    @State var recommendedForYou = [
        [
            "image": "img_1",
            "name": "Sound of Sky",
            "artists": "Dilon Bruce"
        ],
        [
            "image": "img_2",
            "name": "Girl on Fire",
            "artists": "Alecia Keys"
        ]
    ]
    @State var playlistArr = [
        [
                    "image": "img_3",
                    "name": "Classic Playlist",
                    "artists": "Piano Guys"
                ],
                [
                    "image": "img_4",
                    "name": "Summer Playlist",
                    "artists": "Dilon Bruce"
                ],
                [
                    "image": "img_5",
                    "name": "Pop Music",
                    "artists": "Michael Jackson"
                ]
            ]

    var recentlyPlayedArr: NSArray = [
                [
                    "rate": 4,
                    "name": "Billie Jean",
                    "artists": "Michael Jackson"
                ],
                [
                    "rate": 4,
                    "name": "Earth Song",
                    "artists": "Michael Jackson"
                ],
                [
                    "rate": 4,
                    "name": "Mirror",
                    "artists": "Justin Timberlake"
                ],
                [
                    "rate": 4,
                    "name": "Remember the Time",
                    "artists": "Michael Jackson"
                ]
    ]
    
    var body: some View {
        ZStack {
            
            // 整个页面位ScrollView
            ScrollView() {
                // MARK: - 第一个部分 Recommended 推荐的音乐
                VStack {
                    Text("Recommended") // 推荐标题
                        .font(.customfont(.medium, fontSize: 15))
                        .foregroundColor(.primaryText80)
                        .padding(.top, .topInsets + 56)
                        .padding(.horizontal, 20)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 15) {
                            ForEach(recommendedForYou.indices, id: \.self) { index in
                                
                                let sObj = recommendedForYou[index]
                                
                                VStack {
                                    // banner 图片
                                    Image(sObj["image"] ?? "")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 230, height: 125)
                                        .padding(.bottom, 4)
                                    // banner 歌曲名
                                    Text(sObj["name"] ?? "")
                                        .font(.customfont(.bold, fontSize: 13))
                                        .foregroundColor(.primaryText60)
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    // banner 推荐歌曲的歌手名
                                    Text(sObj["artists"] ?? "")
                                        .font(.customfont(.bold, fontSize: 10))
                                        .foregroundColor(.primaryText80)
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    //Spacer()
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                
                // MARK: - 第二个部分，推荐的歌单标题
                ViewAllSection(title: "Playlists") {

                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(playlistArr.indices, id: \.self) { index in
                            
                            let sObj = playlistArr[index]
                            
                            VStack {
                                // banner 图片
                                Image(sObj["image"] ?? "")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110, height: 110)
                                    .padding(.bottom, 4)
                                // banner 歌曲名
                                Text(sObj["name"] ?? "")
                                    .font(.customfont(.bold, fontSize: 13))
                                    .foregroundColor(.primaryText60)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                // banner 推荐歌曲的歌手名
                                Text(sObj["artists"] ?? "")
                                    .font(.customfont(.bold, fontSize: 10))
                                    .foregroundColor(.primaryText80)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                //Spacer()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                // MARK: - 第三个部分， 最近播放
                ViewAllSection(title: "Recently Played") {
                   
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                
                // 最近播放的音乐部分
                LazyVStack(spacing: 10) {
                    ForEach(0..<recentlyPlayedArr.count, id: \.self) { index in
                        let sObj = recentlyPlayedArr[index] as? [String:Any] ?? [:]
                        
                        HStack {
                            //  播放按钮部分
                            Button {
                                
                            } label: {
                                Image("play_btn")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                            }
                            // 歌曲文字部分
                            VStack {
                                // 歌曲名
                                Text(sObj["name"] as? String ?? "")
                                    .font(.customfont(.bold, fontSize: 13))
                                    .foregroundColor(.primaryText60)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                // 歌手名
                                Text(sObj["artists"] as? String ?? "")
                                    .font(.customfont(.bold, fontSize: 10))
                                    .foregroundColor(.secondaryText)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            }
                            
                            // 打分部分
                            VStack {
                                Image("fav")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                                // 评分星星
                                HStack(spacing: 2) {
                                    ForEach( 1...5, id: \.self ) { index in

                                        Image(systemName: "star.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 12, height: 12)
                                            .foregroundColor(.orange)
                                    }
                                }
                            }
                        }
                        
                        Divider()
                            .padding(.leading, 60)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
            }
           
            
            // MARK: - 顶部搜索栏
            VStack {
                
                HStack(spacing: 15) {
                    Button {
                        
                    } label: {// About 侧滑页
                        Image("menu")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                    }
                    
                    HStack {
                        // 搜索栏
                        Image("search")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.primaryText)
                        
                        TextField("Search Songs", text: $textSearch)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .foregroundColor(.primaryText10)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(Color(hex: "497D74"))
                    .cornerRadius(30)
                    

                }
                .padding(.top, .topInsets)
                .padding(.horizontal, 20)
                Spacer()
            }
            
        }
        .frame(width: .screenWidth, height: .screenHeight)
        .background(Color.bg)
        .navigationTitle("")
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

#Preview {
    HomeView()
}
