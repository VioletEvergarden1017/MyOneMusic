//
//  RecommedBanner.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/11.
//

import SwiftUI

struct ViewAllSection: View {
    
    @State var title: String = "Title"
    @State var button: String = "View all"
    var didTap: (()->())?
    
    var body: some View {
        
        HStack {
            // banner 歌曲名
            Text(title)
                .font(.customfont(.medium, fontSize: 15))
                .foregroundColor(.primaryText80)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            // banner 推荐歌曲的歌手名
            Button {
                didTap?()
            } label: {
                Text(button)
                    .font(.customfont(.regular, fontSize: 11))
                    .foregroundColor(Color.org)
            }

        }
    }
}

#Preview {
    ViewAllSection()
}
