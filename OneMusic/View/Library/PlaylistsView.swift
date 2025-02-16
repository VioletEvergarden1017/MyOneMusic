//
//  PlaylistsView.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/11.
//

import SwiftUI

struct PlaylistsView: View {
    @Environment(\.presentationMode) var presentationMode // 声明页面环境参数
    @EnvironmentObject var playlistVM: PlaylistViewModel // 使用ViewModel
    
    // 状态变量
    @State private var showCreateAlert = false // 新建歌单弹窗
    @State private var newPlaylistName = ""    // 新歌单名字
    @State private var newPlaylistcover = ""   // 新歌单封面路径
    @State var searchText: String = "" // 需要搜索的歌单名字
    // 歌单示例数据
    @State var myPlaylists: NSArray = [
        ["image": "mp_1", "name": "My Top Tracks"],
        ["image": "mp_2", "name": "Latest Added"],
        ["image": "mp_3", "name": "History"],
        ["image": "mp_4", "name": "Favorites"]
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                MySearchBar(text: $searchText)
                    .padding(.top, 120)
                
                // 歌单
                ScrollView {
                    ForEach(playlistVM.playlists) { playlist in
                        NavigationLink {
                            PlaylistDetailView(playlist: playlist)
                        } label: {
                            PlaylistRow(playlist: playlist)
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
        .toolbar { // 导航栏功能按键
            ToolbarItem(placement: .principal) {
                Text("Playlists")
                    .font(.customfont(.bold, fontSize: 17))
                    .foregroundColor(Color.primaryText80)
            }
            ToolbarItem(placement: .primaryAction) {
                soryBtn
            }
            ToolbarItem(placement: .destructiveAction) {
                newBtn
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

    // MARK: - 新建歌单按钮
    private var newBtn: some View {
        Button {
            // 将专辑添加至资料库
            showCreateAlert.toggle()
        } label: {
            Image("navi_add")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
        }
        .alert("新建歌单", isPresented: $showCreateAlert) {
            TextField("Name", text: $newPlaylistName)
            TextField("Coverpath", text: $newPlaylistcover)
            Button("创建") {
                guard !newPlaylistName.isEmpty else { return }
                playlistVM.createPlaylist(name: newPlaylistName)
                newPlaylistName = ""
            }
            Button("Cancel", role: .cancel) {}
        }
    }
    
    // MARK: - 排序按钮
    private var soryBtn: some View {
        Menu {
            // 将专辑添加至资料库

            PlaylistSortMenu(text: "All Playlists", img: "rm_play")
            PlaylistSortMenu(text: "Favorite", img: "rm_star")
            Divider()
            PlaylistSortMenu(text: "Title")
            PlaylistSortMenu(text: "Recently Added")
            PlaylistSortMenu(text: "Recently Played")
            PlaylistSortMenu(text: "Recently Updated")
            PlaylistSortMenu(text: "Playlist Type")
        } label: {
            Image("sort")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
        }

    }
}

// MARK: - 排序按钮菜单
private struct PlaylistSortMenu: View {
    @State var text: String = ""
    @State var img: String = ""
    
    var body: some View {
        
        Button {
            // 按下按钮的操作
        } label: {
            HStack {
                Text(text)
                    .font(.customfont(.regular, fontSize: 17))
                Spacer()
                Image(img)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .scaledToFit()
            }
            .background(Color.bg)
        }

    }
}

#Preview {
    let vm = PlaylistViewModel()
    vm.currentPlaylistId = 2
    vm.playlists = [
        PreviewData.testPlaylists(),
        Playlist(
            id: 2,
            name: "我的最爱",
            songs: PreviewData.testSongs(),
            coverPath: "/Users/zhiye/Downloads/032981110B28104181EAF2562E102574.png")]
    return PlaylistsView()
        .environmentObject(vm)
}
