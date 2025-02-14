//
//  Song.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/14.
//

import Foundation

struct Song: Identifiable {
    let id: Int64
    let title: String
    let duration: Int
    let filePath: String
    let coverPath: String?
    let albumId: Int64?
    let artistId: Int64?
    let genreId: Int64?
    let releaseDate: Date?
    
    // 需要联查的字段（非数据库直接存储）
    var artistName: String?
    var albumTitle: String?
    var genreName: String?
}
