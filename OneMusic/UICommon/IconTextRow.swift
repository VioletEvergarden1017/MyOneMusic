//
//  IconTextRow.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/11.
//

import SwiftUI

struct IconTextRow: View {
    var title: String = ""
    var icon: String = ""
    var body: some View {
        VStack {
            HStack {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                
                
                Text(title)
                    .multilineTextAlignment(.center)
                    .font(.customfont(.medium, fontSize: 14))
                    .foregroundColor(Color.primaryText.opacity(0.8))
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 40)
            
            Divider()
                .padding(.leading, 40)
        }
    }
}

#Preview {
    IconTextRow(title: "Themes", icon: "side_theme")
}
