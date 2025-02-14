//
//  testDataBaseView.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/14.
//

import SwiftUI
import AVKit

class AudioPlayerViewModel: ObservableObject {
    @Published var player: AVPlayer?
    
    // 初始化播放器并播放音频
    func playAudio(url: URL) {
        let player = AVPlayer(url: url)
        self.player = player
        player.play()
    }
    
    // 停止播放
    func stopAudio() {
        player?.pause()
    }
}

struct testDatabaseView: View {
    @ObservedObject private var viewModel = SongViewModel()
    @StateObject var audioPlayerVM = AudioPlayerViewModel()
    // 假设这个 URL 来自数据库

    
    var body: some View {
        NavigationStack {
            List(viewModel.songs, id: \.id) { song in
                //let audioURL = URL(string: song.filePath ?? "")
                HStack {
//                    if let uiImage = UIImage(data: song.coverImage) {
//                        Image(uiImage: uiImage)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 50, height: 50)
//                    }
                    
                    VStack(alignment: .leading) {
                        Text(song.title)
                            .font(.headline)
                        Text("Duration: \(song.duration) seconds")
                            .font(.subheadline)
                        
                        Text(song.filePath)
                        Text(song.filePath)
                        
                        
                        Button(action: {
                            // 播放音频
                            //audioPlayerVM.playAudio(url: audioURL)
                        }) {
                            Text("Play Audio")
                                .font(.title)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Songs")
//            .onAppear {
//                // 这里可以插入一首歌曲来测试
//                if let imageData = try? Data(contentsOf: URL(fileURLWithPath: "/Users/zhiye/Downloads/032981110B28104181EAF2562E102574.png")) {
//                    // 在此处提供有效的图片数据
//                    let testSong = Song(id: 760,
//                                        title: "Lost Stars",
//                                        artistId: 324200,
//                                        albumId: 100,
//                                        artistName: "f",
//                                        genreId: 30,
//                                        duration: 410,
//                                        filePath: "/Users/zhiye/Downloads/6005970A0Q9.mp3",
//                                        coverImage: "/Users/zhiye/Documents/OneMusicLibrary/Who You Are Is Not Enough/WhoYouAreIsNotEnough.png"
//                    )
//                    viewModel.addSong(song: testSong)
//                    
//                    
//                } else {
//                    // 处理没有封面图片的情况
//                    print("Unable to load cover image.")
//                }
//            }
            
        }
    }
}

#Preview {
    testDatabaseView()
}
