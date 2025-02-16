//
//  OneDatabaseManager.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/14.
//

import Foundation
import SwiftUI
import SQLite3

class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: OpaquePointer?
    
    private init() {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("musicDB.sqlite")
        //print("\(fileURL)")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
            return
        }
        
        createTables()
    }
    
    private func createTables() {
        // 创建艺术家表
        let createArtistsTable = """
        CREATE TABLE IF NOT EXISTS artists (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE
        );
        """
        // 创建流派表
        let createGenresTable = """
        CREATE TABLE IF NOT EXISTS genres (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE
        );
        """
        // 创建专辑表
        let createAlbumsTable = """
        CREATE TABLE IF NOT EXISTS albums (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            artist_id INTEGER,
            release_date DATE,
            cover_path TEXT,
            FOREIGN KEY (artist_id) REFERENCES artists(id)
        );
        """
        // 创建歌曲表（核心表）
        let createSongsTable = """
        CREATE TABLE IF NOT EXISTS songs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            duration INTEGER NOT NULL, -- 单位：秒
            file_path TEXT NOT NULL UNIQUE,
            cover_path TEXT,
            album_id INTEGER,
            artist_id INTEGER,
            genre_id INTEGER,
            release_date DATE,
            FOREIGN KEY (album_id) REFERENCES albums(id),
            FOREIGN KEY (artist_id) REFERENCES artists(id),
            FOREIGN KEY (genre_id) REFERENCES genres(id)
        );
        """
        // 创建播放列表表
        let createPlaylistsTable = """
        CREATE TABLE IF NOT EXISTS playlists (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE
            cover_path
        );
        """
        // 创建播放列表与歌曲的关联表
        let createPlaylistSongsTable = """
        CREATE TABLE IF NOT EXISTS playlist_songs (
            playlist_id INTEGER NOT NULL,
            song_id INTEGER NOT NULL,
            order_index INTEGER,
            PRIMARY KEY (playlist_id, song_id),
            FOREIGN KEY (playlist_id) REFERENCES playlists(id),
            FOREIGN KEY (song_id) REFERENCES songs(id)
        );
        """
        // 其他表的创建语句同上文SQL部分...
        
        executeStatement(createArtistsTable)
        executeStatement(createGenresTable)
        executeStatement(createAlbumsTable)
        executeStatement(createSongsTable)
        executeStatement(createPlaylistsTable)
        executeStatement(createPlaylistSongsTable)
    }
    
    // 封装执行一条sql指令操作的函数
    private func executeStatement(_ query: String) {
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Error executing statement: \(errmsg)")
            }
        }
        sqlite3_finalize(statement)
    }
    
    // 后续添加CRUD操作方法...
}

extension DatabaseManager {
    // MARK: - 错误处理
    enum DBError: Error {
        case invalidPath
        case databaseError(String)
    }
    
    // MARK: - 通用方法
    private func prepareStatement(_ sql: String) throws -> OpaquePointer {
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            throw DBError.databaseError("Error preparing statement: \(errmsg)")
        }
        return statement!
    }
    
    // MARK: - 艺术家操作
    func getOrCreateArtist(name: String) throws -> Int64 {
        // 先尝试获取已有艺术家
        let fetchSql = "SELECT id FROM artists WHERE name = ?;"
        let fetchStmt = try prepareStatement(fetchSql)
        defer { sqlite3_finalize(fetchStmt) }
        
        sqlite3_bind_text(fetchStmt, 1, (name as NSString).utf8String, -1, nil)
        
        if sqlite3_step(fetchStmt) == SQLITE_ROW {
            return sqlite3_column_int64(fetchStmt, 0)
        }
        
        // 不存在则创建新艺术家
        let insertSql = "INSERT INTO artists (name) VALUES (?);"
        let insertStmt = try prepareStatement(insertSql)
        defer { sqlite3_finalize(insertStmt) }
        
        sqlite3_bind_text(insertStmt, 1, (name as NSString).utf8String, -1, nil)
        
        guard sqlite3_step(insertStmt) == SQLITE_DONE else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            throw DBError.databaseError("Failed to insert artist: \(errmsg)")
        }
        
        return sqlite3_last_insert_rowid(db)
    }
    
    // MARK: - 专辑操作
    func getOrCreateAlbum(title: String, artistId: Int64, releaseDate: Date?, coverPath: String?) throws -> Int64 {
        let fetchSql = """
        SELECT id FROM albums 
        WHERE title = ? AND artist_id = ?;
        """
        let fetchStmt = try prepareStatement(fetchSql)
        defer { sqlite3_finalize(fetchStmt) }
        
        sqlite3_bind_text(fetchStmt, 1, (title as NSString).utf8String, -1, nil)
        sqlite3_bind_int64(fetchStmt, 2, artistId)
        
        if sqlite3_step(fetchStmt) == SQLITE_ROW {
            return sqlite3_column_int64(fetchStmt, 0)
        }
        
        let insertSql = """
        INSERT INTO albums 
        (title, artist_id, release_date, cover_path) 
        VALUES (?, ?, ?, ?);
        """
        let insertStmt = try prepareStatement(insertSql)
        defer { sqlite3_finalize(insertStmt) }
        
        sqlite3_bind_text(insertStmt, 1, (title as NSString).utf8String, -1, nil)
        sqlite3_bind_int64(insertStmt, 2, artistId)
        if let date = releaseDate {
            sqlite3_bind_double(insertStmt, 3, date.timeIntervalSince1970)
        } else {
            sqlite3_bind_null(insertStmt, 3)
        }
        sqlite3_bind_text(insertStmt, 4, (coverPath as NSString?)?.utf8String, -1, nil)
        
        guard sqlite3_step(insertStmt) == SQLITE_DONE else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            throw DBError.databaseError("Failed to insert album: \(errmsg)")
        }
        
        return sqlite3_last_insert_rowid(db)
    }
    
    // MARK: - 歌曲操作（核心方法）
    func insertSong(song: Song) throws {
        var artistId: Int64 = 0
        var albumId: Int64?
        var genreId: Int64?
        
        // 开启事务
        guard sqlite3_exec(db, "BEGIN TRANSACTION", nil, nil, nil) == SQLITE_OK else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            throw DBError.databaseError("Failed to begin transaction: \(errmsg)")
        }
        
        do {
            // 处理艺术家
            artistId = try getOrCreateArtist(name: song.artistName ?? "Unknown Artist")
            
            // 处理专辑
            if let albumTitle = song.albumTitle {
                albumId = try getOrCreateAlbum(
                    title: albumTitle,
                    artistId: artistId,
                    releaseDate: song.releaseDate,
                    coverPath: song.coverPath
                )
            }
            
            // 处理流派
            if let genreName = song.genreName {
                let genreSql = "INSERT OR IGNORE INTO genres (name) VALUES (?);"
                let genreStmt = try prepareStatement(genreSql)
                defer { sqlite3_finalize(genreStmt) }
                
                sqlite3_bind_text(genreStmt, 1, (genreName as NSString).utf8String, -1, nil)
                guard sqlite3_step(genreStmt) == SQLITE_DONE else {
                    throw DBError.databaseError("Failed to insert genre")
                }
                genreId = sqlite3_last_insert_rowid(db)
            }
            
            // 插入歌曲
            let songSql = """
            INSERT INTO songs 
            (title, duration, file_path, cover_path, album_id, artist_id, genre_id, release_date)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?);
            """
            let songStmt = try prepareStatement(songSql)
            defer { sqlite3_finalize(songStmt) }
            
            sqlite3_bind_text(songStmt, 1, (song.title as NSString).utf8String, -1, nil)
            sqlite3_bind_int64(songStmt, 2, Int64(song.duration))
            sqlite3_bind_text(songStmt, 3, (song.filePath as NSString).utf8String, -1, nil)
            sqlite3_bind_text(songStmt, 4, (song.coverPath as NSString?)?.utf8String, -1, nil)
            albumId != nil ? sqlite3_bind_int64(songStmt, 5, albumId!) : sqlite3_bind_null(songStmt, 5)
            sqlite3_bind_int64(songStmt, 6, artistId)
            genreId != nil ? sqlite3_bind_int64(songStmt, 7, genreId!) : sqlite3_bind_null(songStmt, 7)
            if let date = song.releaseDate {
                sqlite3_bind_double(songStmt, 8, date.timeIntervalSince1970)
            } else {
                sqlite3_bind_null(songStmt, 8)
            }
            
            guard sqlite3_step(songStmt) == SQLITE_DONE else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                throw DBError.databaseError("Failed to insert song: \(errmsg)")
            }
            
            // 提交事务
            guard sqlite3_exec(db, "COMMIT", nil, nil, nil) == SQLITE_OK else {
                throw DBError.databaseError("Failed to commit transaction")
            }
        } catch {
            // 回滚事务
            sqlite3_exec(db, "ROLLBACK", nil, nil, nil)
            throw error
        }
    }
    
    // MARK: - 查询所有歌曲（带关联信息）
    func fetchAllSongs() throws -> [Song] {
        let sql = """
        SELECT s.id, s.title, s.duration, s.file_path, s.cover_path, 
               a.name as artist_name, al.title as album_title, g.name as genre_name
        FROM songs s
        LEFT JOIN artists a ON s.artist_id = a.id
        LEFT JOIN albums al ON s.album_id = al.id
        LEFT JOIN genres g ON s.genre_id = g.id
        ORDER BY s.title;
        """
        
        let stmt = try prepareStatement(sql)
        defer { sqlite3_finalize(stmt) }
        
        var songs = [Song]()
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int64(stmt, 0)
            let title = String(cString: sqlite3_column_text(stmt, 1))
            let duration = Int(sqlite3_column_int64(stmt, 2))
            let filePath = String(cString: sqlite3_column_text(stmt, 3))
            let coverPath = sqlite3_column_text(stmt, 4).map { String(cString: $0) }
            
            let artistName = sqlite3_column_text(stmt, 5).map { String(cString: $0) }
            let albumTitle = sqlite3_column_text(stmt, 6).map { String(cString: $0) }
            let genreName = sqlite3_column_text(stmt, 7).map { String(cString: $0) }
            
            let song = Song(
                id: id,
                title: title,
                duration: duration,
                filePath: filePath,
                coverPath: coverPath,
                albumId: nil,
                artistId: nil,
                genreId: nil,
                releaseDate: nil,
                artistName: artistName,
                albumTitle: albumTitle,
                genreName: genreName
            )
            songs.append(song)
        }
        return songs
    }
    
    // MARK: - 播放列表操作
    func createPlaylist(name: String, coverPath: String?) throws -> Int64 {
        let sql = """
        "INSERT INTO playlists (name, cover_path) 
        VALUES (?, ?);
        """
        let stmt = try prepareStatement(sql)
        sqlite3_bind_text(stmt, 1, (name as NSString).utf8String, -1, nil)
        if let coverPath = coverPath {
            sqlite3_bind_text(stmt, 2, (coverPath as NSString).utf8String, -1, nil)
        } else {
            sqlite3_bind_null(stmt, 2)
        }
        guard sqlite3_step(stmt) == SQLITE_DONE else {
            throw DBError.databaseError("Failed to create playlist")
        }
        return sqlite3_last_insert_rowid(db)
    }
    
    func addSongToPlaylist(songId: Int64, playlistId: Int64) throws {
        let sql = """
        INSERT INTO playlist_songs (playlist_id, song_id) 
        VALUES (?, ?);
        """
        let stmt = try prepareStatement(sql)
        defer { sqlite3_finalize(stmt) }
        
        sqlite3_bind_int64(stmt, 1, playlistId)
        sqlite3_bind_int64(stmt, 2, songId)
        
        guard sqlite3_step(stmt) == SQLITE_DONE else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            throw DBError.databaseError("Failed to add song to playlist: \(errmsg)")
        }
    }
    
}

/** 插入歌曲如何使用说明
 let newSong = Song(
     id: 0,
     title: "Song Title",
     duration: 240,
     filePath: "/path/to/song.mp3",
     coverPath: "/path/to/cover.jpg",
     albumId: nil,
     artistId: nil,
     genreId: nil,
     releaseDate: Date(),
     artistName: "Artist Name",
     albumTitle: "Album Title",
     genreName: "Pop"
 )

 do {
     try DatabaseManager.shared.insertSong(song: newSong)
 } catch {
     print("Insert failed: \(error)")
 }
 */

// MARK: - 各类查询拓展
extension DatabaseManager {
    
    // MARK: - 查询专辑列表
    func fetchAlbums() throws -> [Album] {
        let sql = """
        SELECT a.id, a.title, a.artist_id, a.release_date, a.cover_path, 
               ar.name as artist_name,
               COUNT(s.id) as song_count
        FROM albums a
        LEFT JOIN artists ar ON a.artist_id = ar.id
        LEFT JOIN songs s ON a.id = s.album_id
        GROUP BY a.id
        ORDER BY a.title;
        """
        
        let stmt = try prepareStatement(sql)
        defer { sqlite3_finalize(stmt) }
        
        var albums = [Album]()
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int64(stmt, 0)
            let title = String(cString: sqlite3_column_text(stmt, 1))
            let artistId = sqlite3_column_int64(stmt, 2)
            let releaseDate = sqlite3_column_type(stmt, 3) == SQLITE_NULL ? nil : Date(timeIntervalSince1970: sqlite3_column_double(stmt, 3))
            let coverPath = sqlite3_column_text(stmt, 4).map { String(cString: $0) }
            let artistName = String(cString: sqlite3_column_text(stmt, 5))
            let songCount = Int(sqlite3_column_int64(stmt, 6))
            
            let album = Album(
                id: id,
                title: title,
                artistId: artistId,
                releaseDate: releaseDate,
                coverPath: coverPath,
                artistName: artistName,
                songs: [] // 歌曲列表可以通过 fetchSongsForAlbum 方法单独加载
            )
            albums.append(album)
        }
        return albums
    }
    
    // MARK: - 查询专辑详细信息
    func fetchSongsForAlbum(albumId: Int64) throws -> [Song] {
        let sql = """
        SELECT s.id, s.title, s.duration, s.file_path, s.cover_path,
               a.name as artist_name, al.title as album_title, g.name as genre_name
        FROM songs s
        LEFT JOIN artists a ON s.artist_id = a.id
        LEFT JOIN albums al ON s.album_id = al.id
        LEFT JOIN genres g ON s.genre_id = g.id
        WHERE s.album_id = ?
        ORDER BY s.title;
        """
        
        let stmt = try prepareStatement(sql)
        defer { sqlite3_finalize(stmt) }
        
        sqlite3_bind_int64(stmt, 1, albumId)
        
        var songs = [Song]()
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int64(stmt, 0)
            let title = String(cString: sqlite3_column_text(stmt, 1))
            let duration = Int(sqlite3_column_int64(stmt, 2))
            let filePath = String(cString: sqlite3_column_text(stmt, 3))
            let coverPath = sqlite3_column_text(stmt, 4).map { String(cString: $0) }
            let artistName = String(cString: sqlite3_column_text(stmt, 5))
            let albumTitle = String(cString: sqlite3_column_text(stmt, 6))
            let genreName = sqlite3_column_text(stmt, 7).map { String(cString: $0) }
            
            let song = Song(
                id: id,
                title: title,
                duration: duration,
                filePath: filePath,
                coverPath: coverPath,
                albumId: albumId,
                artistId: nil,
                genreId: nil,
                releaseDate: nil,
                artistName: artistName,
                albumTitle: albumTitle,
                genreName: genreName
            )
            songs.append(song)
        }
        return songs
    }
    
    // MARK: - 查询艺术家列表
    func fetchArtists() throws -> [Artist] {
        let sql = """
        SELECT a.id, a.name, COUNT(s.id) as song_count
        FROM artists a
        LEFT JOIN songs s ON a.id = s.artist_id
        GROUP BY a.id
        ORDER BY a.name;
        """
        
        let stmt = try prepareStatement(sql)
        defer { sqlite3_finalize(stmt) }
        
        var artists = [Artist]()
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int64(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let songCount = Int(sqlite3_column_int64(stmt, 2))
            
            let artist = Artist(
                id: id,
                name: name
            )
            artists.append(artist)
        }
        return artists
    }
    
    // MARK: - 查询艺术家详细
    func fetchSongsForArtist(artistId: Int64) throws -> [Song] {
        let sql = """
        SELECT s.id, s.title, s.duration, s.file_path, s.cover_path,
               a.name as artist_name, al.title as album_title, g.name as genre_name
        FROM songs s
        LEFT JOIN artists a ON s.artist_id = a.id
        LEFT JOIN albums al ON s.album_id = al.id
        LEFT JOIN genres g ON s.genre_id = g.id
        WHERE s.artist_id = ?
        ORDER BY s.title;
        """
        
        let stmt = try prepareStatement(sql)
        defer { sqlite3_finalize(stmt) }
        
        sqlite3_bind_int64(stmt, 1, artistId)
        
        var songs = [Song]()
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int64(stmt, 0)
            let title = String(cString: sqlite3_column_text(stmt, 1))
            let duration = Int(sqlite3_column_int64(stmt, 2))
            let filePath = String(cString: sqlite3_column_text(stmt, 3))
            let coverPath = sqlite3_column_text(stmt, 4).map { String(cString: $0) }
            let artistName = String(cString: sqlite3_column_text(stmt, 5))
            let albumTitle = String(cString: sqlite3_column_text(stmt, 6))
            let genreName = sqlite3_column_text(stmt, 7).map { String(cString: $0) }
            
            let song = Song(
                id: id,
                title: title,
                duration: duration,
                filePath: filePath,
                coverPath: coverPath,
                albumId: nil,
                artistId: artistId,
                genreId: nil,
                releaseDate: nil,
                artistName: artistName,
                albumTitle: albumTitle,
                genreName: genreName
            )
            songs.append(song)
        }
        return songs
    }
    
    // MARK: - 查询流派列表
    func fetchGenres() throws -> [Genre] {
        let sql = """
        SELECT g.id, g.name, COUNT(s.id) as song_count
        FROM genres g
        LEFT JOIN songs s ON g.id = s.genre_id
        GROUP BY g.id
        ORDER BY g.name;
        """
        
        let stmt = try prepareStatement(sql)
        defer { sqlite3_finalize(stmt) }
        
        var genres = [Genre]()
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int64(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let songCount = Int(sqlite3_column_int64(stmt, 2))
            
            let genre = Genre(
                id: id,
                name: name,
                songCount: songCount
            )
            genres.append(genre)
        }
        return genres
    }
    
    // MARK: - 查询播放列表详细
    func fetchSongsForPlaylist(playlistId: Int64) throws -> [Song] {
        let sql = """
        SELECT s.id, s.title, s.duration, s.file_path, s.cover_path,
               a.name as artist_name, al.title as album_title, g.name as genre_name
        FROM songs s
        LEFT JOIN artists a ON s.artist_id = a.id
        LEFT JOIN albums al ON s.album_id = al.id
        LEFT JOIN genres g ON s.genre_id = g.id
        LEFT JOIN playlist_songs ps ON s.id = ps.song_id
        WHERE ps.playlist_id = ?
        ORDER BY ps.order_index;
        """
        
        let stmt = try prepareStatement(sql)
        defer { sqlite3_finalize(stmt) }
        
        sqlite3_bind_int64(stmt, 1, playlistId)
        
        var songs = [Song]()
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int64(stmt, 0)
            let title = String(cString: sqlite3_column_text(stmt, 1))
            let duration = Int(sqlite3_column_int64(stmt, 2))
            let filePath = String(cString: sqlite3_column_text(stmt, 3))
            let coverPath = sqlite3_column_text(stmt, 4).map { String(cString: $0) }
            let artistName = String(cString: sqlite3_column_text(stmt, 5))
            let albumTitle = String(cString: sqlite3_column_text(stmt, 6))
            let genreName = sqlite3_column_text(stmt, 7).map { String(cString: $0) }
            
            let song = Song(
                id: id,
                title: title,
                duration: duration,
                filePath: filePath,
                coverPath: coverPath,
                albumId: nil,
                artistId: nil,
                genreId: nil,
                releaseDate: nil,
                artistName: artistName,
                albumTitle: albumTitle,
                genreName: genreName
            )
            songs.append(song)
        }
        return songs
    }
    
    // MARK: - 查询各类的总数（数量值）
    func fetchTotalSongCount() throws -> Int {
        let sql = "SELECT COUNT(*) FROM songs;"
        let stmt = try prepareStatement(sql)
        defer { sqlite3_finalize(stmt) }
        
        guard sqlite3_step(stmt) == SQLITE_ROW else {
            throw DBError.databaseError("Failed to fetch song count")
        }
        return Int(sqlite3_column_int64(stmt, 0))
    }
    
    func fetchTotalAlbumCount() throws -> Int {
        let sql = "SELECT COUNT(*) FROM albums;"
        let stmt = try prepareStatement(sql)
        defer { sqlite3_finalize(stmt) }
        
        guard sqlite3_step(stmt) == SQLITE_ROW else {
            throw DBError.databaseError("Failed to fetch album count")
        }
        return Int(sqlite3_column_int64(stmt, 0))
    }
    
    func fetchTotalArtistCount() throws -> Int {
        let sql = "SELECT COUNT(*) FROM artists;"
        let stmt = try prepareStatement(sql)
        defer { sqlite3_finalize(stmt) }
        
        guard sqlite3_step(stmt) == SQLITE_ROW else {
            throw DBError.databaseError("Failed to fetch artist count")
        }
        return Int(sqlite3_column_int64(stmt, 0))
    }
    
    func fetchTotalGenreCount() throws -> Int {
        let sql = "SELECT COUNT(*) FROM genres;"
        let stmt = try prepareStatement(sql)
        defer { sqlite3_finalize(stmt) }
        
        guard sqlite3_step(stmt) == SQLITE_ROW else {
            throw DBError.databaseError("Failed to fetch genre count")
        }
        return Int(sqlite3_column_int64(stmt, 0))
    }
    
    func fetchTotalPlaylistCount() throws -> Int {
        let sql = "SELECT COUNT(*) FROM playlists;"
        let stmt = try prepareStatement(sql)
        defer { sqlite3_finalize(stmt) }
        
        guard sqlite3_step(stmt) == SQLITE_ROW else {
            throw DBError.databaseError("Failed to fetch playlist count")
        }
        return Int(sqlite3_column_int64(stmt, 0))
    }
}


// MARK: - 删除操作
extension DatabaseManager {
    
    // 删除歌曲（级联删除关联数据）
    func deleteSong(songId: Int64) throws {
        let transactionQuery = "BEGIN TRANSACTION;"
        let rollbackQuery = "ROLLBACK;"
        let commitQuery = "COMMIT;"
        
        guard sqlite3_exec(db, transactionQuery, nil, nil, nil) == SQLITE_OK else {
            throw DBError.databaseError("开启事务失败")
        }
        
        do {
            // 1. 从播放列表移除关联
            let deletePlaylistLinks = """
            DELETE FROM playlist_songs 
            WHERE song_id = ?;
            """
            let stmt1 = try prepareStatement(deletePlaylistLinks)
            defer { sqlite3_finalize(stmt1) }
            sqlite3_bind_int64(stmt1, 1, songId)
            guard sqlite3_step(stmt1) == SQLITE_DONE else {
                throw DBError.databaseError("删除播放列表关联失败")
            }
            
            // 2. 删除歌曲本体
            let deleteSongQuery = """
            DELETE FROM songs 
            WHERE id = ?;
            """
            let stmt2 = try prepareStatement(deleteSongQuery)
            defer { sqlite3_finalize(stmt2) }
            sqlite3_bind_int64(stmt2, 1, songId)
            guard sqlite3_step(stmt2) == SQLITE_DONE else {
                throw DBError.databaseError("删除歌曲失败")
            }
            
            // 提交事务
            guard sqlite3_exec(db, commitQuery, nil, nil, nil) == SQLITE_OK else {
                throw DBError.databaseError("提交事务失败")
            }
        } catch {
            sqlite3_exec(db, rollbackQuery, nil, nil, nil)
            throw error
        }
    }
    
    // 删除专辑及关联歌曲（可选级联）
    func deleteAlbum(albumId: Int64, cascade: Bool = true) throws {
        try executeTransaction {
            if cascade {
                // 先删除专辑下的所有歌曲
                let deleteSongsQuery = """
                DELETE FROM songs 
                WHERE album_id = ?;
                """
                let stmt = try prepareStatement(deleteSongsQuery)
                defer { sqlite3_finalize(stmt) }
                sqlite3_bind_int64(stmt, 1, albumId)
                guard sqlite3_step(stmt) == SQLITE_DONE else {
                    throw DBError.databaseError("删除专辑歌曲失败")
                }
            }
            
            // 删除专辑本体
            let deleteAlbumQuery = """
            DELETE FROM albums 
            WHERE id = ?;
            """
            let stmt = try prepareStatement(deleteAlbumQuery)
            defer { sqlite3_finalize(stmt) }
            sqlite3_bind_int64(stmt, 1, albumId)
            guard sqlite3_step(stmt) == SQLITE_DONE else {
                throw DBError.databaseError("删除专辑失败")
            }
        }
    }
    
    // 删除播放列表（自动清理关联）
    func deletePlaylist(playlistId: Int64) throws {
        try executeTransaction {
            // 删除关联条目
            let deleteLinks = """
            DELETE FROM playlist_songs 
            WHERE playlist_id = ?;
            """
            let stmt1 = try prepareStatement(deleteLinks)
            defer { sqlite3_finalize(stmt1) }
            sqlite3_bind_int64(stmt1, 1, playlistId)
            guard sqlite3_step(stmt1) == SQLITE_DONE else {
                throw DBError.databaseError("清理播放列表关联失败")
            }
            
            // 删除播放列表本体
            let deletePlaylist = """
            DELETE FROM playlists 
            WHERE id = ?;
            """
            let stmt2 = try prepareStatement(deletePlaylist)
            defer { sqlite3_finalize(stmt2) }
            sqlite3_bind_int64(stmt2, 1, playlistId)
            guard sqlite3_step(stmt2) == SQLITE_DONE else {
                throw DBError.databaseError("删除播放列表失败")
            }
        }
    }
    
    // 通用事务执行方法
    private func executeTransaction(block: () throws -> Void) throws {
        let begin = "BEGIN TRANSACTION;"
        let commit = "COMMIT;"
        let rollback = "ROLLBACK;"
        
        guard sqlite3_exec(db, begin, nil, nil, nil) == SQLITE_OK else {
            throw DBError.databaseError("事务启动失败")
        }
        
        do {
            try block()
            guard sqlite3_exec(db, commit, nil, nil, nil) == SQLITE_OK else {
                throw DBError.databaseError("事务提交失败")
            }
        } catch {
            sqlite3_exec(db, rollback, nil, nil, nil)
            throw error
        }
    }
}

// MARK: - 更新操作
extension DatabaseManager {
    
    // 更新歌曲基本信息
    func updateSong(_ song: Song) throws {
        let query = """
        UPDATE songs SET
            title = ?,
            duration = ?,
            genre_id = ?,
            release_date = ?
        WHERE id = ?;
        """
        
        try executeTransaction {
            let stmt = try prepareStatement(query)
            defer { sqlite3_finalize(stmt) }
            
            sqlite3_bind_text(stmt, 1, (song.title as NSString).utf8String, -1, nil)
            sqlite3_bind_int64(stmt, 2, Int64(song.duration))
            if let genreId = song.genreId {
                sqlite3_bind_int64(stmt, 3, genreId)
            } else {
                sqlite3_bind_null(stmt, 3)
            }
            if let date = song.releaseDate {
                sqlite3_bind_double(stmt, 4, date.timeIntervalSince1970)
            } else {
                sqlite3_bind_null(stmt, 4)
            }
            sqlite3_bind_int64(stmt, 5, song.id)
            
            guard sqlite3_step(stmt) == SQLITE_DONE else {
                throw DBError.databaseError("歌曲更新失败")
            }
        }
    }
    
    // 更新播放列表名称
    func updatePlaylistName(playlistId: Int64, newName: String) throws {
        let query = """
        UPDATE playlists 
        SET name = ? 
        WHERE id = ?;
        """
        
        let stmt = try prepareStatement(query)
        defer { sqlite3_finalize(stmt) }
        
        sqlite3_bind_text(stmt, 1, (newName as NSString).utf8String, -1, nil)
        sqlite3_bind_int64(stmt, 2, playlistId)
        
        guard sqlite3_step(stmt) == SQLITE_DONE else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            if errmsg.contains("UNIQUE constraint") {
                throw DBError.databaseError("播放列表名称已存在")
            }
            throw DBError.databaseError("更新失败: \(errmsg)")
        }
    }
    
    // 更新专辑封面路径
    func updateAlbumCover(albumId: Int64, newCoverPath: String?) throws {
        let query = """
        UPDATE albums 
        SET cover_path = ? 
        WHERE id = ?;
        """
        
        let stmt = try prepareStatement(query)
        defer { sqlite3_finalize(stmt) }
        
        if let path = newCoverPath {
            sqlite3_bind_text(stmt, 1, (path as NSString).utf8String, -1, nil)
        } else {
            sqlite3_bind_null(stmt, 1)
        }
        sqlite3_bind_int64(stmt, 2, albumId)
        
        guard sqlite3_step(stmt) == SQLITE_DONE else {
            throw DBError.databaseError("封面更新失败")
        }
    }
    
    // 更新歌曲在播放列表中的顺序
    func updatePlaylistSongOrder(playlistId: Int64, songIds: [Int64]) throws {
        try executeTransaction {
            // 清空原有顺序
            let clearOrderQuery = """
            UPDATE playlist_songs 
            SET order_index = NULL 
            WHERE playlist_id = ?;
            """
            let stmt1 = try prepareStatement(clearOrderQuery)
            defer { sqlite3_finalize(stmt1) }
            sqlite3_bind_int64(stmt1, 1, playlistId)
            guard sqlite3_step(stmt1) == SQLITE_DONE else {
                throw DBError.databaseError("清除顺序失败")
            }
            
            // 设置新顺序
            let updateOrderQuery = """
            UPDATE playlist_songs 
            SET order_index = ? 
            WHERE playlist_id = ? AND song_id = ?;
            """
            for (index, songId) in songIds.enumerated() {
                let stmt = try prepareStatement(updateOrderQuery)
                defer { sqlite3_finalize(stmt) }
                
                sqlite3_bind_int64(stmt, 1, Int64(index))
                sqlite3_bind_int64(stmt, 2, playlistId)
                sqlite3_bind_int64(stmt, 3, songId)
                
                guard sqlite3_step(stmt) == SQLITE_DONE else {
                    throw DBError.databaseError("更新顺序失败")
                }
            }
        }
    }
}

// MARK: - 更新与删除使用示例
/**
 // 删除歌曲示例
 do {
     try DatabaseManager.shared.deleteSong(songId: 123)
 } catch {
     print("删除失败: \(error)")
 }

 // 更新播放列表名称示例
 do {
     try DatabaseManager.shared.updatePlaylistName(playlistId: 1, newName: "我的最爱")
 } catch DatabaseManager.DBError.databaseError(let msg) {
     print("错误: \(msg)")
 }

 // 批量更新播放列表顺序
 let songOrder = [45, 32, 78] // 歌曲ID数组
 do {
     try DatabaseManager.shared.updatePlaylistSongOrder(
         playlistId: 1,
         songIds: songOrder
     )
 } catch {
     print("顺序更新失败: \(error)")
 }
 */

// MARK: - 分页查询
extension DatabaseManager {
    
    // 分页查询歌曲
    func fetchSongs(page: Int, pageSize: Int) throws -> [Song] {
        let offset = (page - 1) * pageSize
        let sql = """
        SELECT s.id, s.title, s.duration, s.file_path, s.cover_path,
               a.name as artist_name, al.title as album_title, g.name as genre_name
        FROM songs s
        LEFT JOIN artists a ON s.artist_id = a.id
        LEFT JOIN albums al ON s.album_id = al.id
        LEFT JOIN genres g ON s.genre_id = g.id
        ORDER BY s.title
        LIMIT ? OFFSET ?;
        """
        
        let stmt = try prepareStatement(sql)
        defer { sqlite3_finalize(stmt) }
        
        sqlite3_bind_int64(stmt, 1, Int64(pageSize))
        sqlite3_bind_int64(stmt, 2, Int64(offset))
        
        var songs = [Song]()
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int64(stmt, 0)
            let title = String(cString: sqlite3_column_text(stmt, 1))
            let duration = Int(sqlite3_column_int64(stmt, 2))
            let filePath = String(cString: sqlite3_column_text(stmt, 3))
            let coverPath = sqlite3_column_text(stmt, 4).map { String(cString: $0) }
            let artistName = String(cString: sqlite3_column_text(stmt, 5))
            let albumTitle = String(cString: sqlite3_column_text(stmt, 6))
            let genreName = sqlite3_column_text(stmt, 7).map { String(cString: $0) }
            
            let song = Song(
                id: id,
                title: title,
                duration: duration,
                filePath: filePath,
                coverPath: coverPath,
                albumId: nil,
                artistId: nil,
                genreId: nil,
                releaseDate: nil,
                artistName: artistName,
                albumTitle: albumTitle,
                genreName: genreName
            )
            songs.append(song)
        }
        return songs
    }
    
    // 分页查询专辑
    func fetchAlbums(page: Int, pageSize: Int) throws -> [Album] {
        let offset = (page - 1) * pageSize
        let sql = """
        SELECT a.id, a.title, a.artist_id, a.release_date, a.cover_path,
               ar.name as artist_name,
               COUNT(s.id) as song_count
        FROM albums a
        LEFT JOIN artists ar ON a.artist_id = ar.id
        LEFT JOIN songs s ON a.id = s.album_id
        GROUP BY a.id
        ORDER BY a.title
        LIMIT ? OFFSET ?;
        """
        
        let stmt = try prepareStatement(sql)
        defer { sqlite3_finalize(stmt) }
        
        sqlite3_bind_int64(stmt, 1, Int64(pageSize))
        sqlite3_bind_int64(stmt, 2, Int64(offset))
        
        var albums = [Album]()
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int64(stmt, 0)
            let title = String(cString: sqlite3_column_text(stmt, 1))
            let artistId = sqlite3_column_int64(stmt, 2)
            let releaseDate = sqlite3_column_type(stmt, 3) == SQLITE_NULL ? nil : Date(timeIntervalSince1970: sqlite3_column_double(stmt, 3))
            let coverPath = sqlite3_column_text(stmt, 4).map { String(cString: $0) }
            let artistName = String(cString: sqlite3_column_text(stmt, 5))
            let songCount = Int(sqlite3_column_int64(stmt, 6))
            
            let album = Album(
                id: id,
                title: title,
                artistId: artistId,
                releaseDate: releaseDate,
                coverPath: coverPath,
                artistName: artistName,
                songs: []
            )
            albums.append(album)
        }
        return albums
    }
}

// MARK: - 分页查询使用示例
/**
 do {
     let page1Songs = try DatabaseManager.shared.fetchSongs(page: 1, pageSize: 20)
     let page2Songs = try DatabaseManager.shared.fetchSongs(page: 2, pageSize: 20)
     
     print("第1页歌曲: \(page1Songs.count) 首")
     print("第2页歌曲: \(page2Songs.count) 首")
 } catch {
     print("分页查询失败: \(error)")
 }
 */

// MARK: - 歌曲搜索操作
extension DatabaseManager {
    
    // 搜索歌曲
    func searchSongs(query: String) throws -> [Song] {
        let sql = """
        SELECT s.id, s.title, s.duration, s.file_path, s.cover_path,
               a.name as artist_name, al.title as album_title, g.name as genre_name
        FROM songs s
        LEFT JOIN artists a ON s.artist_id = a.id
        LEFT JOIN albums al ON s.album_id = al.id
        LEFT JOIN genres g ON s.genre_id = g.id
        WHERE s.title LIKE ? 
           OR a.name LIKE ? 
           OR al.title LIKE ?
        ORDER BY s.title;
        """
        
        let stmt = try prepareStatement(sql)
        defer { sqlite3_finalize(stmt) }
        
        // 使用 % 实现模糊匹配
        let searchQuery = "%\(query)%"
        sqlite3_bind_text(stmt, 1, (searchQuery as NSString).utf8String, -1, nil)
        sqlite3_bind_text(stmt, 2, (searchQuery as NSString).utf8String, -1, nil)
        sqlite3_bind_text(stmt, 3, (searchQuery as NSString).utf8String, -1, nil)
        
        var songs = [Song]()
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int64(stmt, 0)
            let title = String(cString: sqlite3_column_text(stmt, 1))
            let duration = Int(sqlite3_column_int64(stmt, 2))
            let filePath = String(cString: sqlite3_column_text(stmt, 3))
            let coverPath = sqlite3_column_text(stmt, 4).map { String(cString: $0) }
            let artistName = String(cString: sqlite3_column_text(stmt, 5))
            let albumTitle = String(cString: sqlite3_column_text(stmt, 6))
            let genreName = sqlite3_column_text(stmt, 7).map { String(cString: $0) }
            
            let song = Song(
                id: id,
                title: title,
                duration: duration,
                filePath: filePath,
                coverPath: coverPath,
                albumId: nil,
                artistId: nil,
                genreId: nil,
                releaseDate: nil,
                artistName: artistName,
                albumTitle: albumTitle,
                genreName: genreName
            )
            songs.append(song)
        }
        return songs
    }
}

// MARK: - 歌单列表操作
// DatabaseManager.swift
extension DatabaseManager {
    // 获取歌单列表
    func fetchPlaylists() throws -> [Playlist] {
        let sql = "SELECT * FROM playlists"
        let stmt = try prepareStatement(sql)
        var playlists = [Playlist]()
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int64(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            playlists.append(Playlist(id: id, name: name))
        }
        return playlists
    }
    
    // 从歌单中删除
    func removeSongFromPlaylist(songId: Int64, playlistId: Int64) throws {
        let sql = """
        DELETE FROM playlist_songs
        WHERE playlist_id = ? AND song_id = ?;
        """
        let stmt = try prepareStatement(sql)
        sqlite3_bind_int64(stmt, 1, playlistId)
        sqlite3_bind_int64(stmt, 2, songId)
        guard sqlite3_step(stmt) == SQLITE_DONE else {
            throw DBError.databaseError("Failed to remove song from playlist")
        }
    }
}

// MARK: - 动态生成封面逻辑
extension DatabaseManager {
    
    // 生成动态封面
    func generatePlaylistCover(songs: [Song]) -> String {
        let covers = songs.compactMap { $0.coverPath }.prefix(4)
        let size = CGSize(width: 500, height: 500)
        
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            UIColor.systemBackground.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            // 排列最多4张封面
            for (index, path) in covers.enumerated() {
                guard let uiImage = UIImage(contentsOfFile: path) else { continue }
                let rect = coverRectForIndex(index, total: covers.count)
                uiImage.draw(in: rect)
            }
        }
        
        let filename = "playlist_\(UUID().uuidString).jpg"
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent(filename)
        
        do {
            try image.jpegData(compressionQuality: 0.8)?.write(to: url)
            return url.path
        } catch {
            return ""
        }
    }

    private func coverRectForIndex(_ index: Int, total: Int) -> CGRect {
        switch total {
        case 1: return CGRect(x: 0, y: 0, width: 500, height: 500)
        case 2: return CGRect(x: index == 0 ? 0 : 250, y: 0, width: 250, height: 500)
        case 3: return CGRect(
            x: index == 2 ? 250 : 0,
            y: index == 2 ? 250 : 0,
            width: index == 2 ? 250 : 250,
            height: index == 2 ? 250 : 250
        )
        default: return CGRect(
            x: index % 2 == 0 ? 0 : 250,
            y: index < 2 ? 0 : 250,
            width: 250,
            height: 250
        )
        }
    }
}
