//
//  PlaylistModel.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/14.
//

import Foundation

struct Playlist: Identifiable {
    let id: Int64
    let name: String
    var songs: [Song] = []
}
