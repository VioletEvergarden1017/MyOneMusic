//
//  CacheManager.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/15.
//


import Foundation

class CacheManager {
    static let shared = CacheManager()
    
    // 内存缓存
    private let memoryCache = NSCache<NSString, AnyObject>()
    
    // 磁盘缓存目录
    private let diskCacheDirectory: URL = {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("MusicAppCache")
    }()
    
    private init() {
        // 创建磁盘缓存目录
        try? FileManager.default.createDirectory(at: diskCacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }
    
    // MARK: - 内存缓存
    func setMemoryCache<T: AnyObject>(_ object: T, forKey key: String) {
        memoryCache.setObject(object, forKey: key as NSString)
    }
    
    func getMemoryCache<T: AnyObject>(forKey key: String) -> T? {
        return memoryCache.object(forKey: key as NSString) as? T
    }
    
    func removeMemoryCache(forKey key: String) {
        memoryCache.removeObject(forKey: key as NSString)
    }
    
    // MARK: - 磁盘缓存
    func setDiskCache<T: Codable>(_ object: T, forKey key: String) throws {
        let fileURL = diskCacheDirectory.appendingPathComponent(key)
        let data = try JSONEncoder().encode(object)
        try data.write(to: fileURL)
    }
    
    func getDiskCache<T: Codable>(forKey key: String) throws -> T? {
        let fileURL = diskCacheDirectory.appendingPathComponent(key)
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func removeDiskCache(forKey key: String) throws {
        let fileURL = diskCacheDirectory.appendingPathComponent(key)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try FileManager.default.removeItem(at: fileURL)
        }
    }
    
    // MARK: - 清理缓存
    func clearMemoryCache() {
        memoryCache.removeAllObjects()
    }
    
    func clearDiskCache() throws {
        try FileManager.default.removeItem(at: diskCacheDirectory)
        try FileManager.default.createDirectory(at: diskCacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }
}

/**
 // 缓存专辑封面
 let coverImage = UIImage(named: "album_cover")
 CacheManager.shared.setMemoryCache(coverImage, forKey: "album_cover_123")

 // 从缓存获取封面
 if let cachedImage: UIImage = CacheManager.shared.getMemoryCache(forKey: "album_cover_123") {
     print("从内存缓存获取封面")
 }

 // 缓存歌曲元数据
 let songMetadata = Song(id: 1, title: "Song Title", duration: 240, filePath: "/path/to/song.mp3", coverPath: nil, albumId: nil, artistId: nil, genreId: nil, releaseDate: nil, artistName: nil, albumTitle: nil, genreName: nil)
 try CacheManager.shared.setDiskCache(songMetadata, forKey: "song_1")

 // 从磁盘缓存获取歌曲元数据
 if let cachedSong: Song = try CacheManager.shared.getDiskCache(forKey: "song_1") {
     print("从磁盘缓存获取歌曲元数据: \(cachedSong.title)")
 }
 */
