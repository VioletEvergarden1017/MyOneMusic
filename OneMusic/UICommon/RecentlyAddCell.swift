//
//  RecentlyAddCell.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/12.
//

import SwiftUI

/**
 Recently Added Grid Cell 视图，用于 Library 视图作为网格单元使用。长按对歌曲进行操作
 */

struct RecentlyAddCell: View {
    
    @State var sObj: NSDictionary = [
        "image": "alb_1",
        "name": "Who You Are Is Not Enough",
        "artists": "Michael Jackson",
        "songs": "10 Songs"
      ]
    
    var body: some View {
        // MARK: - Recently Added 网格 Cell 视图
        VStack(alignment: .leading, spacing: 1) {
            // 歌曲封面
            Image(sObj.value(forKey: "image") as? String ?? "")
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160) // 补充约束条件
                .cornerRadius(8)
            // 歌曲名
            Text(sObj.value(forKey: "name") as? String ?? "")
                .lineLimit(1)
                .font(.customfont(.regular, fontSize: 15))
                .frame(maxWidth: 160, alignment: .leading) // 补充约束条件
                .foregroundColor(.primaryText)
            // 歌手名
            Text(sObj.value(forKey: "artists") as? String ?? "")
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
    RecentlyAddCell()
}
