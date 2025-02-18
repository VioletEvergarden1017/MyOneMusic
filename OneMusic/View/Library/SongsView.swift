//
//  SongsVIew.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/11.
//

import SwiftUI

struct SongsView: View {
    @Environment(\.presentationMode) var presentationMode // 声明页面环境参数
    @EnvironmentObject private var songVM: SongViewModel // ViewModel
    @EnvironmentObject private var playlistVM: PlaylistViewModel
    @EnvironmentObject private var audioPlayer: AudioPlayerManager // 绑定播放器
    @State var searchText: String = "" // 需要搜索的歌曲名字
    
    var body: some View {
        NavigationStack {
            VStack{
                MySearchBar(text: $searchText)
                    .padding(.top, 120)

                ScrollView {
                    VStack {
                        // 确保使用 viewModel.songs 中的数据
                        ForEach(songVM.songs) { song in
                            SongsCell(sObj: song)
                                .environmentObject(audioPlayer) // 传递播放器
                                .environmentObject(playlistVM)
                                .onAppear {
                                    print("1.songsCell被调用，这个视图在加载")
                                }
                                .onDisappear {
                                    print("2.被删除，数据被删除了")
                                }
                        }

                    }
                }
                .frame(height: 500)
                
                Spacer()
            }
            .padding(.bottom, .bottomInsets + 44)
            .frame(width: .screenWidth, height: .screenHeight)
            .background(Color.bg)
            .ignoresSafeArea()
        }
        // MARK: - 实现文件上传至资料库
        .fileImporter(
            isPresented: $songVM.isShowingFilePicker,
            allowedContentTypes: [.audio],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    songVM.uploadLocalSong(fileURL: url)
                }
            case .failure(let error):
                songVM.errorMessage = "文件选择失败: \(error.localizedDescription)"
            }
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
            
            // 添加歌曲至资料库按钮，代码更新时间2.18
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    songVM.isShowingFilePicker = true
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.primaryText80)
                }
            }
        }
        // 在 SongsView 中添加一个表单视图
        .sheet(isPresented: $songVM.isShowingFilePicker) {
            VStack {
                Text("Upload Song to Library")
                    .font(.title)
                    .padding()
                
                TextField("Title", text: $songVM.newSongTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Artist", text: $songVM.newSongArtist)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Album", text: $songVM.newSongAlbum)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Select cover for song") {
                    // 打开图片选择器
                }
                .padding()
                
                Button("Upload") {
                    // 触发文件选择器
                    songVM.isShowingFilePicker = true
                }
                .padding()
            }
            .padding()
        }
        // 给出错误信息
        .alert("Error", isPresented: .constant(songVM.errorMessage != nil)) {
            Button("Confirm", role: .cancel) {
                songVM.errorMessage = nil
            }
        } message: {
            Text(songVM.errorMessage ?? "")
        }
//        .onAppear {
//            print("SongsView appeared with \(viewModel.songs.count) songs")
//            print("环境对象状态：",
//                  "playlistVM: \(playlistVM)",
//                  "audioPlayer: \(audioPlayer)")
//        }
//        .onDisappear {
//            print("SongsView disappeared")
//        }

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
/**
 *日志： 解决了困扰了一天的初始化问题，为什么两个cell一直不能加载现在终于解决了。问题根源在于 SongViewModel
 *的初始化逻辑与预览模式的数据设置存在冲突。当 SongViewModel 实例化时，其 init() 方法会立即调用
 *loadSongs()，而默认情况下 shouldLoadFromDatabase true，这会导致异步加载数据库数据的操作覆盖手动设置的测试数据。
 *SongViewModel 的 init() 方法会触发 loadSongs()，而默认 shouldLoadFromDatabase = true，导致异步加载覆盖手动设置的 songs。即使预览中设置了 songVM.shouldLoadFromDatabase = false，初始化的异步操作可能已在执行，最终覆盖手动数据。
 *在预览中创建 SongViewModel 时，直接传递 shouldLoadFromDatabase: false，确保初始化时不触发 loadSongs()。
 */
#Preview {
    // 创建 SongViewModel 时跳过初始化
    let songVM = SongViewModel(shouldLoadFromDatabase: false)
    let playlistVM = PlaylistViewModel()
    let audioPlayer = AudioPlayerManager.shared
    
    // 创建真实测试数据
    let song1 = Song(
       id: 1,
       title: "All Alone With You",
       duration: 35,
       filePath: "/Users/zhiye/Downloads/6005970A0Q9.mp3",
       coverPath: "/Users/zhiye/Downloads/EGOIST-All-Alone-With-You.jpg",
       albumId: nil,
       artistId: nil,
       genreId: nil,
       releaseDate: nil,
       artistName: "EGOIST111",
       albumTitle: "Extra Terrestrial Biological Entities",
       genreName: "Anime"
   )
    let song2 = Song(
       id: 2,
       title: "Bible",
       duration: 240,
       filePath: "/Users/zhiye/Downloads/ENDER LILIES Quietus of the Knights Original Soundtrack/Bulbel.mp3",
       coverPath: "/Users/zhiye/Downloads/enderlilies.jpg",
       albumId: nil,
       artistId: nil,
       genreId: nil,
       releaseDate: nil,
       artistName: "Mili",
       albumTitle: "Sample Album",
       genreName: "Anime"
   )
    let song3 = Song(
        id: 3,
        title: "Lily",
        duration: 240,
        filePath: "/Users/zhiye/Downloads/ENDER LILIES Quietus of the Knights Original Soundtrack/Lily.mp3",
        coverPath: "/Users/zhiye/Downloads/enderlilies.jpg",
        albumId: 87,
        artistId: nil,
        genreId: nil,
        releaseDate: nil,
        artistName: "Mili",
        albumTitle: "Ender Lilies SoundTrack",
        genreName: "Anime"
    )
    let song4 = Song(
        id: 4,
        title: "Harmonious",
        duration: 240,
        filePath: "/Users/zhiye/Downloads/ENDER LILIES Quietus of the Knights Original Soundtrack/Harmonious.mp3",
        coverPath: "/Users/zhiye/Downloads/enderlilies.jpg",
        albumId: 87,
        artistId: nil,
        genreId: nil,
        releaseDate: nil,
        artistName: "Mili",
        albumTitle: "Ender Lilies SoundTrack",
        genreName: "Anime"
    )
    let song5 = Song(
        id: 5,
        title: "North",
        duration: 240,
        filePath: "/Users/zhiye/Downloads/ENDER LILIES Quietus of the Knights Original Soundtrack/North-Mili,Binary Haze Interactive.128.mp3",
        coverPath: "/Users/zhiye/Downloads/enderlilies.jpg",
        albumId: 87,
        artistId: nil,
        genreId: nil,
        releaseDate: nil,
        artistName: "Mili",
        albumTitle: "Ender Lilies SoundTrack",
        genreName: "Anime"
    )
    let song6 = Song(
        id: 6,
        title: "Rosary",
        duration: 240,
        filePath: "/Users/zhiye/Downloads/ENDER LILIES Quietus of the Knights Original Soundtrack/Rosary - Intro-Binary Haze Interactive,Mili.128.mp3",
        coverPath: "/Users/zhiye/Downloads/enderlilies.jpg",
        albumId: 87,
        artistId: nil,
        genreId: nil,
        releaseDate: nil,
        artistName: "Mili",
        albumTitle: "Ender Lilies SoundTrack",
        genreName: "Anime"
    )
       
    // MARK: - 强制刷新数据
    songVM.songs = [song1, song2, song3, song4, song5, song6]
    songVM.shouldLoadFromDatabase = false // 禁止从数据库加载数据
    
    playlistVM.playlists = [
        Playlist(
            id: 1,
            name: "我的最爱",
            songs: [song1, song2], // 包含测试歌曲
            coverPath: "/Users/zhiye/Downloads/enderlilies.jpg"
        )
    ]
    
    // MARK: - 添加调试输出
    print("歌曲数量: \(songVM.songs.count)")
    print("封面路径是否存在: \(FileManager.default.fileExists(atPath: song1.coverPath ?? ""))")
    
    // 设置当前播放器歌曲
    audioPlayer.currentSong = songVM.songs.first
    // 设置当前播放队列为songVM.songs最终实现播放的功能
    playlistVM.currentPlaylistSongs = songVM.songs
    
    return VStack {
        SongsView()
            .environmentObject(songVM)
            .environmentObject(playlistVM)
            .environmentObject(audioPlayer)
        // 显示悬浮播放胶囊
        MusicPillView()
            .environmentObject(audioPlayer)
    }
    .background(Color.bg)
}


