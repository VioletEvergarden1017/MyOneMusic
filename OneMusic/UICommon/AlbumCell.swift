//
//  AlbumCell.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/17.
//

import SwiftUI



struct AlbumCell: View {
    // 专辑模型
    let album: Album
    
    var body: some View {
        // MARK: - Recently Added 网格 Cell 视图
        VStack(alignment: .leading, spacing: 1) {
            // 专辑封面
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
            .frame(width: 160, height: 160) // 补充约束条件
            .cornerRadius(16)
            // 歌曲名
            Text(album.title)
                .lineLimit(1)
                .font(.customfont(.regular, fontSize: 15))
                .frame(maxWidth: 160, alignment: .leading) // 补充约束条件
                .foregroundColor(.primaryText)
            // 歌手名
            Text(album.artistName ?? "Unkonwn Artist")
                .font(.customfont(.regular, fontSize: 13))
                .frame(maxWidth: 160, alignment: .leading)
                .foregroundColor(.primaryText60)
        }
        .background(Color.bg)
        .contextMenu {
            VStack {
                MenuTextBtn(text: "Play", img: "rm_play")
                Divider()
                MenuTextBtn(text: "Delete from Library", img: "rm_delete")
                MenuTextBtn(text: "DownLoad", img: "rm_download")
                MenuTextBtn(text: "Add to Playlist...", img: "rm_add_list")
                Divider()
                MenuTextBtn(text: "Play Next", img: "rm_play")
                MenuTextBtn(text: "Play Last", img: "rm_play")
                Divider()
                MenuTextBtn(text: "Share Album...", img: "rm_share")
                MenuTextBtn(text: "Go to Artist", img: "rm_play")
                Divider()
                MenuTextBtn(text: "Favorite", img: "rm_star")
                MenuTextBtn(text: "Suggest Less", img: "rm_thumb_down")
            }
        }
    }
}

private struct MenuTextBtn: View {
    @State var text: String = ""
    @State var img: String = ""
    
    var body: some View {
        
        Button {
            // 按下按钮的操作
        } label: {
            HStack {
                Text(text)
                    .font(.customfont(.regular, fontSize: 17))
                Spacer()
                Image(img)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .scaledToFit()
            }
            .background(Color.bg)
        }

    }
}

#Preview {
    // 展示数据
   let album = Album(id: 1, title: "Who You Are Is Not Enough", artistId: 1, releaseDate: nil, coverPath: "/Users/zhiye/Downloads/032981110B28104181EAF2562E102574.png", artistName: "Atheltics")
    
    AlbumCell(album: album)
}

