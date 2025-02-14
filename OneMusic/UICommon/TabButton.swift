//
//  TabButton.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/11.
//

import SwiftUI

// 主页
struct TabButton: View {
    @State var title: String = "Home"
    @State var icon: String = "home_tab_un"
    @State var icon_focus: String = "home_tab"
    @State var isSelect: Bool = false
    var didTap: (()->())?
    
    var body: some View {
        Button {
            didTap?()
        } label: {
            VStack {
                Image(isSelect ? icon : icon_focus)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Text(title)
                    .font(.customfont(.regular, fontSize: 12))
                    .foregroundColor(isSelect ? .focus : .unfocused)
            }
        }
    }
}

#Preview {
    TabButton()
}
