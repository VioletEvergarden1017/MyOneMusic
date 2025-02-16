//
//  AudioPlayerManager.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/15.
//


import AVFoundation

class AudioPlayerManager: ObservableObject {
    static let shared = AudioPlayerManager()
    
    @Published var currentSong: Song? // 当前播放的歌曲
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var isPlaying: Bool = false
    @Published var volume: Float = 1.0 {
        didSet {
            player?.volume = volume
        }
    }
    
    private var player: AVAudioPlayer?
    private var timer: Timer?
    // 字段更新时间 2.16
    private var queue: [Song] = []    // 播放队列
    private var currentIndex: Int = 0 // 当前播放的歌曲索引
    
    // 加载歌曲
    func loadSong(_ song: Song) {
        currentSong = song
        guard let url = URL(string: song.filePath) else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            duration = player?.duration ?? 0
            player?.volume = volume
            startProgressTimer()
        } catch {
            print("Error loading audio: \(error)")
        }
    }
    // 开始速度计时器
    private func startProgressTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.currentTime = self.player?.currentTime ?? 0
        }
    }
    // 播放暂停功能
    func playPause() {
        guard let player = player else { return }
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying = player.isPlaying
    }
    // 跳转到制定时间
    func seek(to time: TimeInterval) {
        player?.currentTime = time
        if !isPlaying {
            player?.play()
            isPlaying = true
        }
    }
    
    // 将时间间隔格式转化为字符串
    func timeString(time: TimeInterval) -> String {
        let minute = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minute, seconds)
    }
}

extension AudioPlayerManager {
    
    // MARK: - 设置播放队列
    func setupQueue(tracks: [Song], startIndex: Int = 0) {
        queue = tracks
        currentIndex = startIndex
        loadSong(queue[currentIndex])
    }
    
    // 播放下一首
    func playNext() {
        guard !queue.isEmpty else { print("Play queue is Empty") ; return} // 播放队列为空则返回
        currentIndex = (currentIndex - 1 + queue.count) % queue.count
        loadSong(queue[currentIndex])
    }
    
    func playPrevious() {
        guard !queue.isEmpty else { return }
        currentIndex = (currentIndex - 1 + queue.count) % queue.count
        loadSong(queue[currentIndex])
    }
}
