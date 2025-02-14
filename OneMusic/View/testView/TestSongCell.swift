//
//  TestSongCell.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/14.
//

import SwiftUI

struct TestSongCell: View {
    // 示例数据
    @State var sObj: Song = Song(id: 9,
                                 title: "AllAloneWithYou",
                                 artistId: 1,
                                 albumId: 1,
                                 genreId: 1,
                                 duration: 240,
                                 filePath: "/Users/zhiye/Downloads/6005970A0Q9.mp3",
                                 coverImage: Data()
    )

    var body: some View {
        HStack {
            
            // 歌曲图片
            Image("s1")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .cornerRadius(8)
            // 歌曲文字部分
            VStack(alignment: .leading) {
                
                HStack {
                    Text("AlbumId:" + String(sObj.albumId))
                        .font(.customfont(.regular, fontSize: 13))
                        .foregroundColor(Color.primaryText)
                        .lineLimit(1)
                    Text("GenreID:" + String(sObj.genreId))
                        .font(.customfont(.regular, fontSize: 13))
                        .foregroundColor(Color.primaryText)
                        .lineLimit(1)
                    Text("Duration:" + String(sObj.duration))
                        .font(.customfont(.regular, fontSize: 13))
                        .foregroundColor(Color.primaryText)
                        .lineLimit(1)
                }
                Text(sObj.title)
                    .font(.customfont(.regular, fontSize: 13))
                    .foregroundColor(Color.primaryText)
                    .lineLimit(1)
                Text(sObj.filePath)
                    .font(.customfont(.regular, fontSize: 13))
                    .foregroundColor(Color.primaryText35)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Image("more")
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .padding(.trailing, 10)
        }
        .background(Color.bg)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: 72)
        // 长按菜单
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
    TestSongCell()
}
