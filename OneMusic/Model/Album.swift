//
//  AlbumModel.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/14.
//

import Foundation

struct Album: Identifiable {
    let id: Int64
    let title: String
    let artistId: Int64
    let releaseDate: Date?
    let coverPath: String?
    
    // 联查字段
    var artistName: String?
    var songs: [Song] = []
}
