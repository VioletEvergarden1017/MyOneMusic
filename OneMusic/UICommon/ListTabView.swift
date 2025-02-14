//
//  ListTabView.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/11.
//

import SwiftUI

/**
 资料库栏目组件，用于 library 页面。
 作为跳转至songs， artist等页面的按钮
 */
struct ListTabView: View {
    var btnImage: String // 栏目图标
    var btnName: String  // 栏目名称
    var isSelect: Bool = true
    var didTap: (()->())?
    var body: some View {
        // 将其封装为一个按钮
//        Button {
//            didTap?()
//        } label: {
//            HStack {
//                HStack(spacing: 10) {
//                    Image(btnImage)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 25, height: 25)
//                    Text(btnName)
//                        .font(.customfont(.regular, fontSize: 17))
//                        .foregroundColor(Color.primaryText)
//                }
//                Spacer()
//                Image(systemName: "chevron.right")
//                    .font(.system(size: 17))
//                    .foregroundColor(Color(.systemGray2))
//            }
//            .padding()
//            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 48)
//            .background(Color.bg_light)
//            .cornerRadius(16)
//            .padding(.horizontal)
//        }

        
        HStack {
            HStack(spacing: 10) {
                Image(btnImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                Text(btnName)
                    .font(.customfont(.regular, fontSize: 17))
                    .foregroundColor(Color.primaryText)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 17))
                .foregroundColor(Color(.systemGray2))
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 48)
        .background(Color.bg_light)
        .cornerRadius(16)
        .padding(.horizontal)
        
    }
}

struct ListTabView_Previews: PreviewProvider {
    static var previews: some View {
        ListTabView(btnImage: "l_song", btnName: "Account Setting")
    }
}
