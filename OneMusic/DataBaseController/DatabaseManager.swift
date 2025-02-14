//
//  DatabaseManager.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/14.
//


// 添加 Sqlite 依赖
import Foundation
import SQLite3
import SwiftUI



class DatabaseManager {
    static let shared = DatabaseManager()
    
    private var db: OpaquePointer?
    
    private init() {
        // 初始化时，连接数据库
        if let dbPath = getDatabasePath() {
            if sqlite3_open(dbPath, &db) != SQLITE_OK {
                print("Error opening database")
            } else {
                print("Database opened successfully")
                createTables()
            }
        }
    }
    
    // 获取数据库文件的路径
    private func getDatabasePath() -> String? {
        let fileManager = FileManager.default
        do {
            let documentsUrl = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let dbPath = documentsUrl.appendingPathComponent("musicApp.db").path
            print(dbPath)
            return dbPath
        } catch {
            print("Error getting document directory: \(error)")
            return nil
        }
    }
    
    // 创建数据表
    private func createTables() {
        // （乐曲）
        let createSongsTableQuery = """
        CREATE TABLE IF NOT EXISTS Songs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            artist_id INTEGER,
            album_id INTEGER,
            genre_id INTEGER,
            duration INTEGER,
            file_path TEXT,
            cover_image BLOB,
            FOREIGN KEY (album_id) REFERENCES Albums(album_id),
            FOREIGN KEY (artist_id) REFERENCES Artists(artist_id)
        );
        """
        // （专辑）
        let createAlbumsTableQuery = """
        CREATE TABLE IF NOT EXISTS Albums (
            album_id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            release_date TEXT,
            cover_image BLOB,
            artist_id INTEGER,
            FOREIGN KEY (artist_id) REFERENCES Artists(artist_id)
        );
        """
        // （艺术家）
        let createArtistsTableQuery = """
        CREATE TABLE IF NOT EXISTS Artists (
            artist_id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            bio TEXT,
            cover_image BLOB
        );
        """
        // （音乐流派）
        let createGenresTableQuery = """
        CREATE TABLE IF NOT EXISTS Genres (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
        );
        """
        // （播放列表）
        let createPlaylistsTableQuery = """
        CREATE TABLE IF NOT EXISTS Playlists (
            playlist_id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT
        );
        """
        // (关联表：播放列表和歌曲直接的多对多关系)
        let createSongPlaylistTableQuery = """
        CREATE TABLE IF NOT EXISTS Song_Playlist (
            song_id INTEGER,
            playlist_id INTEGER,
            PRIMARY KEY (song_id, playlist_id),
            FOREIGN KEY (song_id) REFERENCES Songs(id),
            FOREIGN KEY (playlist_id) REFERENCES Playlists(playlist_id)
        );
        """
        
        // 执行创建表的SQL语句
        if sqlite3_exec(db, createSongsTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating Songs table")
        }
        
        if sqlite3_exec(db, createAlbumsTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating Albums table")
        }
        
        if sqlite3_exec(db, createArtistsTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating Artists table")
        }
        
        if sqlite3_exec(db, createGenresTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating Genres table")
        }
        
        if sqlite3_exec(db, createPlaylistsTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating Playlists table")
        }
        
        if sqlite3_exec(db, createSongPlaylistTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating Song_Playlist table")
        }
    }
    
    // MARK: - 数据库对歌曲进行操作
    // 插入数据：插入歌曲
    func insertSong(title: String, artistId: Int64, albumId: Int64, genreId: Int64, duration: Int, file_path: String, coverImage: Data) {

        // 定义 sql 插入语句，使用占位符（？）
        let insertQuery = """
        INSERT INTO Songs (title, artist_id, album_id, genre_id, duration, file_path, cover_image)
        VALUES (?, ?, ?, ?, ?, ?, ?);
        """
//        let insertQuery = """
//        INSERT INTO Songs ("id", "title", "artist_id", "album_id", "genre_id", "duration", "file_path", "cover_image") 
//        VALUES ('81', 'Yellow', '1', '1', '1', '236', 'unknow', NULL);
//        """
        // 声明一个sqlite语句指针
        var stmt: OpaquePointer?
        // 准备 SQL 语句
        if sqlite3_prepare_v2(db, insertQuery, -1, &stmt, nil) == SQLITE_OK {
            
//            sqlite3_bind_text(stmt, 1, title, -1, nil)  // 4. 使用 `sqlite3_bind_text` 来绑定第一个参数 (歌曲标题)
//            sqlite3_bind_int64(stmt, 2, artistId)
//            sqlite3_bind_int64(stmt, 3, albumId)
//            sqlite3_bind_int64(stmt, 4, genreId)
//            sqlite3_bind_int(stmt, 5, Int32(duration))
//            sqlite3_bind_text(stmt, 6, filePath, -1, nil)
//            sqlite3_bind_blob(stmt, 7, (coverImage as NSData).bytes, Int32(coverImage.count), nil)
            // 调试：打印插入的值，确保它们正确
            print("###########")
            let title_cstr = title as NSString
            let filepath_cstr = file_path as NSString
            
            if sqlite3_bind_text(stmt, 1, title_cstr.utf8String, -1, nil) != SQLITE_OK {
                print("Failed to bind title: \(String(cString: sqlite3_errmsg(db)))")
            }
            if sqlite3_bind_int64(stmt, 2, artistId) != SQLITE_OK {
                print("Failed to bind artistId: \(String(cString: sqlite3_errmsg(db)))")
            }
            if sqlite3_bind_int64(stmt, 3, albumId) != SQLITE_OK {
                print("Failed to bind albumId: \(String(cString: sqlite3_errmsg(db)))")
            }
            if sqlite3_bind_int64(stmt, 4, genreId) != SQLITE_OK {
                print("Failed to bind genreId: \(String(cString: sqlite3_errmsg(db)))")
            }
            if sqlite3_bind_int(stmt, 5, Int32(duration)) != SQLITE_OK {
                print("Failed to bind duration: \(String(cString: sqlite3_errmsg(db)))")
            }
            if sqlite3_bind_text(stmt, 6, filepath_cstr.utf8String, -1, nil) != SQLITE_OK {
                print("Failed to bind filePath: \(String(cString: sqlite3_errmsg(db)))")
            }
            if sqlite3_bind_blob(stmt, 7, (coverImage as NSData).bytes, Int32(coverImage.count), nil) != SQLITE_OK {
                print("Failed to bind coverImage: \(String(cString: sqlite3_errmsg(db)))")
            }
            
            
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Song inserted successfully")
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db)) // 获取错误信息
                print("Failed to insert song: \(errorMessage)")
            }
        } else {
            print("INSERT statement preparation failed")
        }
        // 释放语句指针，释放占用的资源
        sqlite3_finalize(stmt)
    }
    
    // 查询所有歌曲
    func fetchAllSongs() -> [Song]? {
        let selectQuery = "SELECT * FROM Songs;"
        var stmt: OpaquePointer?
        var songs: [Song] = []
        
        // 如果没有封面图片，使用系统图片占位符
        let placeholderImageData = UIImage(systemName: "music.note")?.pngData() ?? Data()
        
        if sqlite3_prepare_v2(db, selectQuery, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let id = sqlite3_column_int64(stmt, 0)
                let title = String(cString: sqlite3_column_text(stmt, 1))
                let artistId = sqlite3_column_int64(stmt, 2)
                let albumId = sqlite3_column_int64(stmt, 3)
                let genreId = sqlite3_column_int64(stmt, 4)
                let duration = Int(sqlite3_column_int(stmt, 5))
                let filePath = String(cString: sqlite3_column_text(stmt, 6))
                let coverImageData = sqlite3_column_blob(stmt, 7)
                let coverImageSize = sqlite3_column_bytes(stmt, 7)
                var coverImage = Data() // 默认值为空数据
                if let coverImageData = coverImageData {
                    coverImage = Data(bytes: coverImageData, count: Int(coverImageSize))
                } else {
                    // 如果没有封面图片数据，使用占位符图像数据
                    coverImage = placeholderImageData
                }
                
                let song = Song(id: id, title: title, artistId: artistId, albumId: albumId, genreId: genreId, duration: duration, filePath: filePath, coverImage: coverImage)
                songs.append(song)
            }
        } else {
            print("SELECT statement preparation failed")
            return nil
        }
        
        sqlite3_finalize(stmt)
        return songs
    }
    
    // 更新歌曲标题
    func updateSongTitle(songId: Int64, newTitle: String) {
        let updateQuery = "UPDATE Songs SET title = ? WHERE id = ?;"
        var stmt: OpaquePointer?
        
        if sqlite3_prepare_v2(db, updateQuery, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, newTitle, -1, nil)
            sqlite3_bind_int64(stmt, 2, songId)
            
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Song title updated successfully")
            } else {
                print("Failed to update song title")
            }
        } else {
            print("UPDATE statement preparation failed")
        }
        
        sqlite3_finalize(stmt)
    }
    
    // 删除歌曲
    func deleteSong(songId: Int64) {
        let deleteQuery = "DELETE FROM Songs WHERE id = ?;"
        var stmt: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteQuery, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_int64(stmt, 1, songId)
            
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Song deleted successfully")
            } else {
                print("Failed to delete song")
            }
        } else {
            print("DELETE statement preparation failed")
        }
        
        sqlite3_finalize(stmt)
    }
    
    // MARK: - 对专辑进行操作
    func insertAlbum(title: String, release_date: String, cover_image: Data, artist_id: Int64) -> Bool {
        var stmt: OpaquePointer?
        // 插入操作SQL语句
        let insertQuery = """
        INSERT INTO Albums (title, release_date, cover_image, artist_id)
        VALUES (?, ?, ?, ?)
        """
        if sqlite3_prepare_v2(db, insertQuery, -1, &stmt, nil) != SQLITE_OK {
            print("准备插入专辑失败")
            return false
        }
        let title_cstr = title as NSString
        let realse_date_cstr = release_date as NSString
        // 绑定参数
        sqlite3_bind_text(stmt, 1, title_cstr.utf8String, -1, nil)
        sqlite3_bind_text(stmt, 2, realse_date_cstr.utf8String, -1, nil)
        sqlite3_bind_blob(stmt, 3, (cover_image as NSData).bytes, Int32(cover_image.count), nil)
        sqlite3_bind_int(stmt, 4, Int32(artist_id))
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            print("Album inserted successfully")
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db)) // 获取错误信息
            print("Error: \(errorMessage)")
        }
        
        sqlite3_finalize(stmt) // free 指针
        return true
    }
    
    
    // 关闭数据库连接
    deinit {
        if sqlite3_close(db) != SQLITE_OK {
            print("Error closing database")
        }
    }
    
    
}

