//
//  AlbumsView.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/11.
//

import SwiftUI

struct AlbumsView: View {
    
    @Environment(\.presentationMode) var presentationMode // 声明页面环境参数
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
                        ForEach (0..<allAlb.count, id:\.self) {
                            index in
                            
                            let sObj = allAlb[index] as? NSDictionary ?? [:]
                            
                            NavigationLink {
                                AlbumDetailsView()
                            } label: {
                                RecentlyAddCell(sObj: sObj)
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
    AlbumsView()
}
