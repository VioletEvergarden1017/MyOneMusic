//
//  PlaylistRow.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/13.
//

import SwiftUI

struct PlaylistRow: View {
    @State var sObj: NSDictionary = [
        "image": "alb_1",
        "name": "Favorite Songs",
      ]
    
    var body: some View {
        VStack() {
            
            HStack(spacing: 15) {
                
                // 歌曲图片
                Image(sObj.value(forKey: "image") as? String ?? "")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                // 歌曲文字部分
                VStack(alignment: .leading) {
                    
                    Text(sObj.value(forKey: "name") as? String ?? "")
                        .font(.customfont(.regular, fontSize: 17))
                        .frame(width: 200, alignment: .leading)
                        .foregroundColor(Color.primaryText)
                        .lineLimit(1)
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
                    MenuTextBtn(text: "Add to Playlist...", img: "rm_add_list")
                    Divider()
                    MenuTextBtn(text: "Play Next", img: "rm_play")
                    MenuTextBtn(text: "Play Last", img: "rm_play")
                    Divider()
                    MenuTextBtn(text: "Share Playlist...", img: "rm_share")
                    MenuTextBtn(text: "Go to Artist", img: "rm_play")
                    Divider()
                    MenuTextBtn(text: "Favorite", img: "rm_star")
                    MenuTextBtn(text: "Suggest Less", img: "rm_thumb_down")
                }
            }
            
//            Divider()
//                .padding(.leading, 90)
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
    PlaylistRow()
}
