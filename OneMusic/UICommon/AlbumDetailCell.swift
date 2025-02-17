//
//  AlbumDetailCell.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/12.
//

import SwiftUI

struct AlbumDetailCell: View {
    let album: Album
    
    var body: some View {
        // 专辑信息部分
        VStack(alignment: .center,spacing: 10) {
            Group {
                if let uiImage = UIImage(contentsOfFile: album.coverPath ?? "") {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image("default_cover")
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(width: 256, height: 256)
            .cornerRadius(16)
            // 文字内容
            VStack(spacing: 1) {
                // 专辑名
                Text(album.title)
                    .font(.customfont(.bold, fontSize: 23))
                    .foregroundColor(Color.primaryText)
                    .lineLimit(1)
                // 歌手名按钮
                Text(album.artistName ?? "Unkonwn Artist")
                    .font(.customfont(.regular, fontSize: 20))
                    .foregroundColor(Color.primaryText35)
                // 曲风
                Text("Dance · 2013 · Lossless")
                    .font(.customfont(.bold, fontSize: 13))
            }
        }
    }
}

#Preview {
    
    let album = Album(id: 1, title: "Who You Are Is Not Enough", artistId: 1, releaseDate: nil, coverPath: "/Users/zhiye/Downloads/032981110B28104181EAF2562E102574.png", artistName: "Atheltics")
    
    AlbumDetailCell(album: album)
        .background(Color.bg)
}
