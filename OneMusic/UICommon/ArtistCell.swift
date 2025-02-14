//
//  ArtistCell.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/13.
//

import SwiftUI

struct ArtistCell: View {
    @State var aObj: NSDictionary = [
        "image": "ar_1",
        "name": "Beyonce",
        "albums": "4 albums",
        "songs": "38 Songs"
    ]
    
    var body: some View {
        HStack(spacing: 15) {
            
            // 歌手图片
            Image(aObj.value(forKey: "image") as? String ?? "")
                .resizable()
                .clipShape(Circle())
                .scaledToFit()
                .frame(width: 72, height: 72)
                .cornerRadius(8)
            // 歌手介绍文字部分
            VStack(alignment: .leading) {
                
                Text(aObj.value(forKey: "name") as? String ?? "")
                    .font(.customfont(.bold, fontSize: 17))
                    .foregroundColor(Color.primaryText)
                    .lineLimit(1)
                HStack {
                    Text(aObj.value(forKey: "albums") as? String ?? "")
                        .font(.customfont(.regular, fontSize: 13))
                        .foregroundColor(Color.primaryText35)
                        .lineLimit(1)
                    Text(aObj.value(forKey: "songs") as? String ?? "")
                        .font(.customfont(.regular, fontSize: 13))
                        .foregroundColor(Color.primaryText35)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
        }
        .background(Color.bg)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: 72)
        // 长按菜单
        .contextMenu {
            VStack {
                MenuTextBtn(text: "Create Station", img: "rm_play")
                Divider()
                MenuTextBtn(text: "Share Artist...", img: "rm_share")
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
    ArtistCell()
}
