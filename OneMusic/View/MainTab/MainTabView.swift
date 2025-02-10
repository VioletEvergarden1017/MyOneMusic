//
//  MainTabView.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/11.
//

import SwiftUI

struct MainTabView: View {
    
    @State var selectTab: Int = 0
    
    var body: some View {
        ZStack {
            
            // 选择展示的页面
//            TabView(selection: $selectTab) {
//                
//                VStack {
//                    Spacer()
//                    Text("Home")
//                    Spacer()
//                }
//            }
//            .background(Color.bg)
            // MARK: - 选择所展示的页面
            if(selectTab == 0) {
                
                VStack {
                    Spacer()
                    Text("Home")
                        .foregroundColor(.primaryText)
                    Spacer()
                }
                .frame(width: .screenWidth, height: .screenHeight)
                .background(Color.bg)
            }
            else if(selectTab == 1) {
                VStack {
                    Spacer()
                    Text("Songs")
                        .foregroundColor(.primaryText)
                    Spacer()
                }
                .frame(width: .screenWidth, height: .screenHeight)
                .background(Color.bg)
            }
            else if(selectTab == 2) {
                VStack {
                    Spacer()
                    Text("Personal")
                        .foregroundColor(.primaryText)
                    Spacer()
                }
                .frame(width: .screenWidth, height: .screenHeight)
                .background(Color.bg)
            }
            else if(selectTab == 3) {
                VStack {
                    Spacer()
                    Text("Settings")
                        .foregroundColor(.primaryText)
                    Spacer()
                }
                .frame(width: .screenWidth, height: .screenHeight)
                .background(Color.bg)
            }
            
            // MARK: - 底部导航按钮
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    // 主页
                    TabButton(title: "Home", icon: "home_tab", icon_focus: "home_tab_un", isSelect: selectTab == 0) {// 点击之后的操作
                        selectTab = 0
                    }
                    Spacer()
                    // 歌曲页
                    TabButton(title: "Library", icon: "songs_tab", icon_focus: "songs_tab_un", isSelect: selectTab == 1) {// 点击之后选择页面位歌曲页
                        selectTab = 1
                    }
                    Spacer()
                    // 个人页
                    TabButton(title: "Personal", icon: "personal_tab", icon_focus: "personal_tab_un", isSelect: selectTab == 2) {// 点击之后选择页面为设置页
                        selectTab = 2
                    }
                    Spacer()
                    // 设置页
                    TabButton(title: "Settings", icon: "setting_tab", icon_focus: "setting_tab_un", isSelect: selectTab == 3) {// 点击之后选择页面为设置页
                        selectTab = 3
                    }
                    
                    Spacer()
    
                }
                .padding(.top, 10)
                .padding(.bottom, .bottomInsets)
                .background(Color.bg)
                .shadow(radius: 5)
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

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
