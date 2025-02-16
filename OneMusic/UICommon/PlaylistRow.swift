//
//  PlaylistRow.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/13.
//

import SwiftUI

struct PlaylistRow: View {
    
    let playlist: Playlist // 使用playlist模型
    
    var body: some View {
        VStack() {
            
            HStack(spacing: 15) {
                
                // 歌曲图片
                if let uiImage = UIImage(contentsOfFile: playlist.coverPath ?? "") {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                }
                // 歌曲文字部分
                VStack(alignment: .leading) {
                    
                    Text(playlist.name)
                        .font(.customfont(.regular, fontSize: 17))
                        .frame(width: 200, alignment: .leading)
                        .foregroundColor(Color.primaryText)
                        .lineLimit(1)
                    
                    //Text
                }
                
                Spacer()
                
                Image("next")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .padding(.trailing, 10)
            }
            .background(Color.bg)
            .frame(height: 80)
            // 长按菜单
            .contextMenu {
                VStack {
                    MenuTextBtn(text: "Play", img: "rm_play")
                    Divider()
                    MenuTextBtn(text: "Delete from Library", img: "rm_delete")
                    MenuTextBtn(text: "DownLoad", img: "rm_download")
                    Divider()
                    MenuTextBtn(text: "Play Next", img: "rm_play")
                    MenuTextBtn(text: "Play Last", img: "rm_play")
                    Divider()
                    MenuTextBtn(text: "Share Playlist...", img: "rm_share")
                }
            }
            
        }
        .padding(.horizontal, 20)
        .frame(height: 100)
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
    var playlist = Playlist(
        id: 1,
        name: "My Favorite Song",
        songs: [Song(id: 34, title: "CountingStars", duration: 345, filePath: "/Users/zhiye/Downloads/6005970A0Q9.mp3", coverPath: "/Users/zhiye/Downloads/EGOIST-All-Alone-With-You.jpg", albumId: nil, artistId: nil, genreId: nil, releaseDate: nil)],
        coverPath: "/Users/zhiye/Downloads/032981110B28104181EAF2562E102574.png"
    )
    PlaylistRow(playlist: playlist)
}
