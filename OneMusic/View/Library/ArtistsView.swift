//
//  ArtistsView.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/11.
//

import SwiftUI

struct ArtistsView: View {
    @Environment(\.presentationMode) var presentationMode // 声明页面环境参数
    @State var searchText: String = ""
    // 歌手示例数据
    @State var allArr: NSArray = [
        [
            "image": "ar_1",
            "name": "Beyonce",
            "albums": "4 albums",
            "songs": "38 Songs"
        ],
        [
          "image": "ar_2",
          "name": "Bebe Rexha",
          "albums": "2 albums",
          "songs": "18 Songs"
        ],
        [
          "image": "ar_3",
          "name": "Maroon 5",
          "albums": "5 albums",
          "songs": "46 Songs"
        ],
        ["image": "ar_4",
          "name": "Michael Jackson",
        "albums": "10 albums",
          "songs": "112 Songs"
        ],
        ["image": "ar_5",
          "name": "Queens",
        "albums": "3 albums",
         "songs": "32 Songs"
        ],
        ["image": "ar_6",
          "name": "Yani",
        "albums": "1 albums",
         "songs": "13 Songs"]
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                MySearchBar(text: $searchText)
                    .padding(.top, 120)
                // 歌手列表
                ScrollView {
                    ForEach(0..<allArr.count, id: \.self) { index in
                        
                        let aObj = allArr[index] as? NSDictionary ?? [:]
                        NavigationLink {
                            ArtistDetailsVIew()
                        } label: {
                            ArtistCell(aObj: aObj)
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
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Artists")
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
    ArtistsView()
}
