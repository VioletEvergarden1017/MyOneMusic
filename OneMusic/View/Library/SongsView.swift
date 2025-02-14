//
//  SongsVIew.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/11.
//

import SwiftUI

struct SongsView: View {
    @Environment(\.presentationMode) var presentationMode // 声明页面环境参数
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
    
    var body: some View {
        NavigationStack {
            
            VStack{
                MySearchBar(text: $searchText)
                    .padding(.top, 120)
                //Divider()
                
                ScrollView {
                    ForEach(0..<allArr.count, id: \.self) { index in
                        
                        let sObj = allArr[index] as? NSDictionary ?? [:]
                        
                        SongsCell(sObj: sObj)
                    }
                    ForEach(0..<allArr.count, id: \.self) { index in
                        
                        let sObj = allArr[index] as? NSDictionary ?? [:]
                        
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
