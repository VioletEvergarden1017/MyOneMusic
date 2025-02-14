//
//  SongsVIew.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/11.
//

import SwiftUI

struct SongsView: View {
    @Environment(\.presentationMode) var presentationMode // 声明页面环境参数
    @ObservedObject private var viewModel = SongViewModel() // ViewModel
    @State var searchText: String = "" // 需要搜索的歌曲名字
    // all songs示例数据
    @State var allArr: NSArray = [
        [
            
            "image": "s1",
            "name": "Billie Jean",
            "artist": "Michael Jackson"
        ],
        [
            "image": "s2",
            "name": "Be the girl",
            "artist": "Bebe Rexa"
        ],
        [
            "image": "s3",
            "name": "Countryman",
            "artist": "Daughtry"
        ],
        [
            "image": "s4",
            "name": "Do you feel lonelyness",
            "artist": "Marc Anthony"
        ],
        [
            "image": "s5",
            "name": "Earth song",
            "artist": "Michael Jackson"
        ],
        [
            "image": "s6",
            "name": "Smooth criminal",
            "artist": "Michael Jackson"
        ],
        [
            "image": "s7",
            "name": "The way you make me feel",
            "artist": "Michael Jackson"
        ],
        
        [
            "image": "s9",
            "name": "Somebody that I used to know",
            "artist": "Gotye"
        ],
        [
            "image": "s10",
            "name": "Wild Thoughts",
            "artist": "Michael Jackson"
        ]
    ]
    
//    var mysongs: [Song] = [
//        Song(id: 1, title: "I", artistId: 1, albumId: 1, artistName: "Athelics", genreId: 1, duration: 1, filePath: "/Users/zhiye/Documents/OneMusicLibrary/Who You Are Is Not Enough/I.mp3", coverImage: "/Users/zhiye/Documents/OneMusicLibrary/Who You Are Is Not Enough/WhoYouAreIsNotEnough.png"),
//        Song(id: 2, title: "II (Find Yourself)", artistId: 1, albumId: 1, artistName: "Athelics", genreId: 1, duration: 2, filePath: "/Users/zhiye/Documents/OneMusicLibrary/Who You Are Is Not Enough/II (Find Yourself).mp3", coverImage: "/Users/zhiye/Documents/OneMusicLibrary/Who You Are Is Not Enough/WhoYouAreIsNotEnough.png"),
//        Song(id: 3, title: "II)", artistId: 1, albumId: 1, artistName: "Athelics", genreId: 1, duration: 3, filePath: "/Users/zhiye/Documents/OneMusicLibrary/Who You Are Is Not Enough/II.mp3", coverImage: "/Users/zhiye/Documents/OneMusicLibrary/Who You Are Is Not Enough/WhoYouAreIsNotEnough.png"),
//        Song(id: 4, title: "III (Find Yourself)", artistId: 1, albumId: 1, artistName: "Athelics", genreId: 1, duration: 4, filePath: "/Users/zhiye/Documents/OneMusicLibrary/Who You Are Is Not Enough/III (Find Yourself) .mp3", coverImage: "/Users/zhiye/Documents/OneMusicLibrary/Who You Are Is Not Enough/WhoYouAreIsNotEnough.png"),
//        Song(id: 5, title: "III", artistId: 1, albumId: 1, artistName: "Athelics", genreId: 1, duration: 5, filePath: "/Users/zhiye/Documents/OneMusicLibrary/Who You Are Is Not Enough/III.mp3", coverImage: "/Users/zhiye/Documents/OneMusicLibrary/Who You Are Is Not Enough/WhoYouAreIsNotEnough.png"),
//        Song(id: 6, title: "IV", artistId: 1, albumId: 1, artistName: "Athelics", genreId: 1, duration: 6, filePath: "/Users/zhiye/Documents/OneMusicLibrary/Who You Are Is Not Enough/IV.mp3", coverImage: "/Users/zhiye/Documents/OneMusicLibrary/Who You Are Is Not Enough/WhoYouAreIsNotEnough.png"),
//    ]
    
    
    var body: some View {
        NavigationStack {
            
            VStack{
                MySearchBar(text: $searchText)
                    .padding(.top, 120)
//                    .onTapGesture {
//                        for song in mysongs {
//                            viewModel.addSong(song: song)
//                        }
//                    }
                //Divider()
                
//                Button {
//                    testAdd()
//                } label: {
//                    Text("Add all song")
//                }

                
                ScrollView {
                    ForEach(0..<viewModel.songs.count, id: \.self) { index in
                        
                        let sObj = viewModel.songs[index]
                        
                        SongsCell(sObj: sObj)
                    }
                }
                
                Spacer()
            }
            .padding(.bottom, .bottomInsets + 44)
            .frame(width: .screenWidth, height: .screenHeight)
            .background(Color.bg)
            .ignoresSafeArea()
        }
        // 隐藏系统自带的返回按钮(会使得系统侧滑逻辑实效，需要自定义新的侧滑逻辑)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backBtn) // 实现自定义返回
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Songs")
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

//    private func testAdd() {
//        for song in mysongs {
//            viewModel.addSong2(song: song)
//        }
//    }
}


// MARK: - 自定义搜索栏
struct MySearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color.bg_light)
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image("search")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding(.leading, 10)
                        Spacer()
                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                    //.background(Color.bg_light)
                )
                .padding(.horizontal, 20)
        }
        
    }
}

#Preview {
    SongsView()
}
