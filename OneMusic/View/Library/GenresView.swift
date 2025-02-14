//
//  GenresView.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/11.
//

import SwiftUI

struct GenresView: View {
    @Environment(\.presentationMode) var presentationMode // 声明页面环境参数
    @State var searchText: String = "" // 需要搜索的歌曲名字
    
    var body: some View {
        NavigationStack {
            VStack {
                
            }
            .frame(width: .screenWidth, height: .screenHeight)
            .background(Color.bg)
            .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)  // 隐藏系统自带的返回以实现自定义返回按钮
        .navigationBarItems(leading: backBtn) // 实现自定义返回
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Genres")
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
    GenresView()
}
