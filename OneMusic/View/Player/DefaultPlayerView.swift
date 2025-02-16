//
//  DefaultPlayerView.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/13.
//

import SwiftUI
import AVKit

struct DefaultPlayerView: View {
    // MARK : - 播放器核心属性
    @StateObject private var audioPlayer = AudioPlayerManager.shared // 全局播放器
    //@Binding var currentSong: Song? // 当前播放歌曲
    @Binding var isExpanded: Bool // 控制展开/收起状态
    
    // 播放器手势状态
    @State private var dragOffset: CGSize = .zero
    private let dragThreshold: CGFloat = 150 // 下滑触发阈值
    
    var body: some View {
        GeometryReader { //geometry in
            // 视图控件，用于获取子视图的几何信息
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack {
                // 背景
                Rectangle()
                    .fill(.ultraThickMaterial) // 超薄材质，即透明模糊的效果
                    .overlay(content: { // 在该视图之上叠加另外一个视图
                        Rectangle() // 叠加一个矩形
                        Image("player_mm")
                            .blur(radius: 55) // 模糊半径为 55
                    })
                
                // 主要页面布局
                VStack(spacing: 15) {
                    // 封面
                    if let coverPath = audioPlayer.currentSong?.coverPath,
                       let imageData = try? Data(contentsOf: URL(fileURLWithPath: coverPath)),
                       let coverImage = UIImage(data: imageData) {
                        Image(uiImage: coverImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width - 50, height: size.width - 50)
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    } else {
                        // 默认封面
                        Image(systemName: "music.note")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: size.width - 50, height: size.width - 50)
                            .foregroundColor(.gray)
                    }
                    
                    // 播放器控件
                    PlayerView(size)
                }
                .padding(.top, safeArea.top + (safeArea.bottom == 0 ? 10 : 0))
                .padding(.bottom, safeArea.bottom  == 0 ? 10 : 0)
                .padding(.horizontal, 25)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .clipped()
            }
            .ignoresSafeArea(.container, edges: .all)
            .offset(y: isExpanded ? 0 : size.height) // 展开/收起动画
            .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0), value: isExpanded)
            // 补充下滑切出播放器view
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // 仅仅允许向下滑动
                        if value.translation.height > 0 {
                            dragOffset = value.translation
                        }
                    }
                    .onEnded { value in
                        if value.translation.height > dragThreshold { // 滑动擦过阈值关闭页面
                            isExpanded = false
                        }
                        dragOffset = .zero
                    }
            )
        }
        .onAppear {
            if let song = audioPlayer.currentSong {
                audioPlayer.loadSong(song)
            }
        }

    }
    
    // 播放器视图
    @ViewBuilder
    func PlayerView(_ mainSize: CGSize) -> some View {
        VStack(spacing: 20) { // 播放器视图整体间距
            // 歌曲信息
            HStack(alignment: .center, spacing: 15) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(audioPlayer.currentSong?.title ?? "未知歌曲")
                        .font(.customfont(.medium, fontSize: 20))
                    Text(audioPlayer.currentSong?.artistName ?? "未知艺术家")
                        .font(.customfont(.regular, fontSize: 16))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button {
                    // 更多操作
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.white)
                        .padding()
                        .background {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .environment(\.colorScheme, .light)
                        }
                }
            }
            
            // 进度条
            CustomProgressBar(
                progress: $audioPlayer.currentTime,
                duration: audioPlayer.duration,
                thumbColor: .progressThumb,
                trackColor: .progressTrack
            )
            .frame(height: 4)
            
            // 时间显示
            HStack {
                Text(audioPlayer.timeString(time: audioPlayer.currentTime))
                Spacer()
                Text(audioPlayer.timeString(time: audioPlayer.duration))
            }
            
            // 控制按钮
            HStack(spacing: mainSize.width * 0.18) {
                Button {
                    // 上一首
                    audioPlayer.playPrevious()
                } label: {
                    Image(systemName: "backward.fill")
                        .font(mainSize.height < 300 ? .title3 : .title)
                }
                
                Button {
                    audioPlayer.playPause()
                } label: {
                    Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                        .font(mainSize.height < 300 ? .largeTitle : .system(size: 50))
                }
                
                Button {
                    // 下一首
                    audioPlayer.playNext()
                } label: {
                    Image(systemName: "forward.fill")
                        .font(mainSize.height < 300 ? .title3 : .title)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.top, 20)
            
            // 声音控件
            HStack(spacing: 15) {
                Image(systemName: "speaker.fill")
                    .foregroundColor(.playerControl)
                
                Slider(value: $audioPlayer.volume, in: 0...1)
                    .accentColor(.playerControl)
                    .frame(height: 4)
                
                Image(systemName: "speaker.wave.3.fill")
                    .foregroundColor(.playerControl)
            }
            .padding(.top, 20)
        }
        .padding(.vertical, 20)
    }

}

struct DefaultPlayerView_Previews: PreviewProvider {
    @State static var isExpanded: Bool = true
    
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
        
        return DefaultPlayerView(isExpanded: $isExpanded)
            .environmentObject(audioPlayer)
            .preferredColorScheme(.dark)
            .onAppear {
                // 测试收起动画
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isExpanded = false
                }
            }
    }
}

// MARK: - 自定义播放进度条
struct CustomProgressBar: View {
    @Binding var progress: TimeInterval
    let duration: TimeInterval
    let thumbColor: Color
    let trackColor: Color
    
    @State private var isDragging: Bool = false // 是否正在拖动
    @State private var dragProgress: TimeInterval = 0 // 拖动时的临时进度
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // 进度条轨道
                Capsule()
                    .foregroundColor(trackColor)
                    .frame(height: 4)
                
                // 进度条填充
                Capsule()
                    .foregroundColor(thumbColor)
                    .frame(
                        width: CGFloat(
                            (isDragging ? dragProgress : progress) / duration
                        ) * geometry.size.width,
                        height: 4
                    )
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        isDragging = true
                        let x = value.location.x
                        let newProgress = min(max(0, x / geometry.size.width), 1)
                        dragProgress = newProgress * duration
                    }
                    .onEnded { value in
                        isDragging = false
                        progress = dragProgress
                        // 跳转到指定时间
                        AudioPlayerManager.shared.seek(to: dragProgress)
                    }
            )
        }
        .frame(height: 4)
    }
}
                
// MARK: - 拓展 View
extension View {
    // 获取设备的屏幕圆角半径
    var deviceCornerRadius: CGFloat {
        
        let key = "_displayCornerRadicus" // 常量， 私有API的键，用于获取屏幕的 cornerRadius
        
        if let screen = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.screen {
            if let cornerRadius = screen.value(forKey: key) as? CGFloat {
                return cornerRadius
            }
            return 0
        }
        return 0
    }
}
