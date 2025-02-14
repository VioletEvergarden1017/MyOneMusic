//
//  SideMenuView.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/11.
//

import SwiftUI
// 侧滑菜单页面
struct SideMenuView: View {
    
    @Binding var isShowing: Bool
    //var content: AnyView
    var edgeTransition: AnyTransition = .move(edge: .leading)
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            if(isShowing) {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                
                HStack {
                    ScrollView {
                        VStack {
                            
                            Spacer()
                            
                            Image("app_logo")// 修改为头像
                                .resizable()
                                .scaledToFit()
                                .frame(width: .screenWidth * 0.17, height: .screenWidth * 0.17)
                            
                            // 库内容数
                            HStack {
                                Spacer()
                                VStack {
                                    Text("328\nSongs")
                                        .multilineTextAlignment(.center)
                                        .font(.customfont(.regular, fontSize: 12))
                                        .foregroundColor(Color(hex: "ffffff"))
                                }
                                Spacer()
                                VStack {
                                    Text("49\nAlbums")
                                        .multilineTextAlignment(.center)
                                        .font(.customfont(.regular, fontSize: 12))
                                        .foregroundColor(Color(hex: "ffffff"))
                                }
                                Spacer()
                                VStack {
                                    Text("97\nArtists")
                                        .multilineTextAlignment(.center)
                                        .font(.customfont(.regular, fontSize: 12))
                                        .foregroundColor(Color(hex: "ffffff"))
                                }
                                Spacer()
                            }
                            
                            Spacer()
                        }
                        .frame(height: 240)
                        .background(Color.primaryText.opacity(0.03))
                        
                        // 侧边内容
                        LazyVStack {
                            
                            // 切换播放器的主题
                            IconTextRow(title: "Themes", icon: "side_theme")
                            IconTextRow(title: "Ringtone Cutter", icon: "side_ring_cut")
                            IconTextRow(title: "Sleep Timer", icon: "side_sleep_timer")
                            IconTextRow(title: "Equaliezer", icon: "side_eq")
                            IconTextRow(title: "Driver Mode", icon: "side_driver_mode")
                            IconTextRow(title: "Hidden Folders", icon: "side_hidden_folder")
                        }
                        .padding(15)
                        
                    } // 显示的页面
                    .frame(width: .screenWidth * 0.7)
                    .background(Color.bg)
                    .transition(edgeTransition) // 页面转换动画
                    .background(Color.clear)
                    
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
}

struct SideMenuView_Previews: PreviewProvider {
    @State static var isShow: Bool = true
    static var previews: some View {
        SideMenuView(isShowing: $isShow)

    }
}
