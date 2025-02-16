//
//  Playable.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/17.
//

import Foundation

protocol Playable {
    func setupQueue(tracks: [Song], startIndex: Int)
    func play()
}
