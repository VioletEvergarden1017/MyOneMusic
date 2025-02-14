//
//  DefaultPlayerView.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/13.
//

import SwiftUI
import AVKit

struct DefaultPlayerView: View {
    // 播放器状态变量
    @State private var player: AVAudioPlayer? // 音频播放器对象
    @State private var isPlaying = false      // 当前播放状态
    @State private var duration: TimeInterval = 0.0 // 音频总时长
    @State private var currentTime: TimeInterval = 0.0 // 当前播放时间
    
    // 控制 Sheet 拓展的绑定变量（滑动关闭）
    @Binding var expandSheet: Bool // 是否展开 Sheet
    var animation: Namespace.ID // 用于动画的命名空间ID
    @State private var animationContent: Bool = false // 控制动画内容的状态变量
    
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
                    GeometryReader { geometry in // 传递闭包的参数
                        let size = geometry.size // 将 geometry 的 size 属性赋值给size供使用
                        Image("player_bg")
                            .resizable().aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous)) // 将视图裁剪为圆角矩形， 圆角样式为连续曲线
                    }
                    .frame(height: size.width - 50)
                    .padding(.vertical, size.height < 700 ? 10 : 30)
                    
                    PlayerView(size) // 播放器视图
                }
                .padding(.top, safeArea.top + (safeArea.bottom == 0 ? 10 : 0))
                .padding(.bottom, safeArea.bottom  == 0 ? 10 : 0)
                .padding(.horizontal, 25)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .clipped()
            }
            .ignoresSafeArea(.container, edges: .all)
        }
        .onAppear(perform: setupAudio) // 视图出现的时候设置音频
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            updateProgress() // 定时更新播放进度
        }
    }
    
    // 设置音乐播放器
    private func setupAudio() {
        guard let url = Bundle.main.url(forResource: "ALL", withExtension: "mp3")
        else {
            return // 退出当前函数
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay() // prepareToPlay ： 准备音频播放的方法
            duration = player?.duration ?? 0.0
        } catch { // 捕获 do 块当中抛出的错误
            print("Error loading audio: \(error)")
        }
    }
    
    // 播放音频
    private func playAudio() {
        player?.play() // play() 调用 player 的 play 方法， 即开始播放音频
        isPlaying = true
    }
    
    // 暂停音频
    private func stopAudio() {
        player?.pause() // play() 调用 player 的 pause 方法， 即开始暂停音频
        isPlaying = false
    }
    
    // 获取播放进度
    private func updateProgress() {
        guard let player = player else { return }
        currentTime = player.currentTime // 获取播放进度
    }
    
    // 跳转至制定时间播放
    private func seekAudio(to time: TimeInterval) {
        player?.currentTime = time
        if !isPlaying {
            player?.play()
            isPlaying = true
        }
    }
    
    // 将时间间隔格式转化为字符串
    private func timeString(time: TimeInterval) -> String {
        let minute = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minute, seconds)
    }
    
    // 播放器视图
    @ViewBuilder
    func PlayerView(_ mainSize: CGSize) -> some View {
        
        GeometryReader { geometry in
            let size = geometry.size
            let spacing = size.height * 0.04 // 基于视图高度计算间距
            
            VStack(spacing: spacing) {
                VStack(spacing: spacing) {
                    HStack(alignment: .center, spacing: 15) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("All Alone With You")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text("EGOIST")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.white)
                                .padding()
                                .background() {
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .environment(\.colorScheme, .light)
                                }
                        }

                    }
                    
                    // 播放进度条
                    Slider(value: Binding(get: {
                        currentTime
                    }, set: { newValue in // 更新
                        seekAudio(to: newValue)
                    }), in: 0...duration)
                    .foregroundColor(.white)
                    
                    HStack {
                        Text(timeString(time: currentTime))
                        Spacer()
                        Text(timeString(time: duration))
                    }
                }
                .frame(height: size.height / 2.5, alignment: .top)
                
                // 上一首，暂停，下一首按钮部分
                HStack(spacing: size.width * 0.18) {
                    Button {
                        
                    } label: {
                        Image(systemName: "backward.fill")
                            .font(size.height < 300 ? .title3 : .title)
                    }
                    Button {
                        isPlaying ? stopAudio() : playAudio()
                    } label: {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(size.height < 300 ? .largeTitle : .system(size: 50))
                    }
                    Button {
                        
                    } label: {
                        Image(systemName: "backward.fill")
                            .font(size.height < 300 ? .title3 : .title)
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                
                // 调整声音模块
                VStack(spacing: spacing) {
                    HStack(spacing: 15) {
                        Image(systemName: "speaker.fill")
                        
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .environment(\.colorScheme, .light)
                            .frame(height: 5)
                        Image(systemName: "speaker.wave.3.fill")
                    }
                    
                }
                .offset(y: 40)
            }
        }
    }
    
}

struct DefaultPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultPlayerView(expandSheet: .constant(true), animation: Namespace().wrappedValue)
            .preferredColorScheme(.dark)
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
