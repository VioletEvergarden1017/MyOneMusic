//
//  MusicPillView.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/15.
//

import SwiftUI

struct MusicPillView: View {
    @EnvironmentObject var audioPlayer: AudioPlayerManager
    @State private var isExpanded: Bool = false // 控制播放器展开状态
    
    var body: some View {
        if let currentSong = audioPlayer.currentSong {
            Button {
                isExpanded.toggle() // 切换播放器展开状态
            } label: {
                HStack(spacing: 12) {
                    // 封面
                    if let coverPath = currentSong.coverPath,
                       let imageData = try? Data(contentsOf: URL(fileURLWithPath: coverPath)),
                       let coverImage = UIImage(data: imageData) {
                        Image(uiImage: coverImage)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(8)
                    } else {
                        Image(systemName: "music.note")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                            .background(Color.primaryText10)
                            .cornerRadius(8)
                    }
                    
                    // 歌曲信息
                    VStack(alignment: .leading) {
                        Text(currentSong.title)
                            .font(.customfont(.medium, fontSize: 14))
                            .foregroundColor(Color.primaryText80)
                            .lineLimit(1)
                        Text(currentSong.artistName ?? "未知艺术家")
                            .font(.customfont(.regular, fontSize: 12))
                            .foregroundColor(.primaryText60)
                    }
                    
                    Spacer()
                    
                    // 控制按钮
                    Button {
                        audioPlayer.playPause()
                    } label: {
                        Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                            .foregroundColor(.primaryApp)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial) // 透明磨砂效果
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                )
                .padding(.horizontal, 20)
                // 打开播放器详细view的切换动画
                //.opacity(isExpanded ? 0 : 1) // 展开时胶囊淡出
                .scaleEffect(isExpanded ? 0.8 : 1)
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isExpanded)
            }
            .fullScreenCover(isPresented: $isExpanded) {
                DefaultPlayerView(isExpanded: $isExpanded)
                    .environmentObject(audioPlayer)
            }
        }
    }
}

// 效果预览
struct MusicPillView_Previews: PreviewProvider {
    static var previews: some View {
        let audioPlayer = AudioPlayerManager.shared
        audioPlayer.currentSong = Song(
            id: 1,
            title: "All Alone With You",
            duration: 240,
            filePath: Bundle.main.path(forResource: "ALL", ofType: "mp3") ?? "",
            coverPath: Bundle.main.path(forResource: "all", ofType: "jpg") ?? "",
            albumId: nil,
            artistId: nil,
            genreId: nil,
            releaseDate: nil,
            artistName: "EGOIST",
            albumTitle: "Extra Terrestrial Biological Entities",
            genreName: "Anime"
        )
        
        return MusicPillView()
            .environmentObject(audioPlayer)
            .preferredColorScheme(.dark)
    }
}
