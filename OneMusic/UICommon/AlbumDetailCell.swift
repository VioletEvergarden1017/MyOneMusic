//
//  AlbumDetailCell.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/12.
//

import SwiftUI

struct AlbumDetailCell: View {
    
    var body: some View {
        // 专辑信息部分
        VStack(alignment: .center,spacing: 10) {
            Image("alb_1")
                .resizable()
                .scaledToFit()
                .frame(width: 256, height: 256)
                .cornerRadius(16)
            // 文字内容
            VStack(spacing: 1) {
                // 歌曲名
                Text("Athletics")
                    .font(.customfont(.bold, fontSize: 23))
                    .foregroundColor(Color.primaryText)
                    .lineLimit(1)
                // 歌手名按钮
                Text("占位")
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
    AlbumDetailCell().background(Color.bg)
}
