//
//  SongModel.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/13.
//

import Foundation

class Song: Identifiable{
    var id: Int64
    var title: String
    var artistId: Int64
    var albumId: Int64
    var genreId: Int64
    var duration: Int
    var filePath: String
    var coverImage: Data
    
    init(id: Int64, title: String, artistId: Int64, albumId: Int64, genreId: Int64, duration: Int, filePath: String, coverImage: Data) {
        self.id = id
        self.title = title
        self.artistId = artistId
        self.albumId = albumId
        self.genreId = genreId
        self.duration = duration
        self.filePath = filePath
        self.coverImage = coverImage
    }
}
