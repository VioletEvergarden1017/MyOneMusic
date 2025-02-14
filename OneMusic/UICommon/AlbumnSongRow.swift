//
//  AlbumnSongRow.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/13.
//

import SwiftUI
// 播放 GIF 依赖项
import GIFImage

struct AlbumnSongRow: View {
    @State var sObj: NSDictionary = [:]
    var index: Int = 1
    var isPlay: Bool = false
    let gifPath = Bundle.main.path(forResource: "wave", ofType: "gif")
    
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                
                Text(String(index))
                    .font(.customfont(.regular, fontSize: 17))
                    .foregroundColor(Color.primaryText60)
                    .frame(alignment: .leading)
                Text(sObj.value(forKey: "name") as? String ?? "")
                    .font(.customfont(.regular, fontSize: 17))
                    .foregroundColor(Color.primaryText)
                Spacer()
                Text(sObj.value(forKey: "duration") as? String ?? "")
                    .font(.customfont(.regular, fontSize: 17))
                    .foregroundColor(Color.primaryText)
                
                if(isPlay) {
//                    Image("audio_wave")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 80, height: 40, alignment: .center)
//                    GIFImage(source: .local(filePath: gifPath!))
//                        .background(Color.bg)
                }else{
                    Menu {
                        MenuTextBtn(text: "Play", img: "rm_play")
                        Divider()
                        MenuTextBtn(text: "Delete from Library", img: "rm_delete")
                        MenuTextBtn(text: "DownLoad", img: "rm_download")
                        MenuTextBtn(text: "Add to Playlist...", img: "rm_add_list")
                        Divider()
                        MenuTextBtn(text: "Play Next", img: "rm_play")
                        MenuTextBtn(text: "Play Last", img: "rm_play")
                        Divider()
                        MenuTextBtn(text: "Share Sony...", img: "rm_share")
                        MenuTextBtn(text: "Go to Artist", img: "rm_play")
                        Divider()
                        MenuTextBtn(text: "Favorite", img: "rm_star")
                    } label: {
                        Image( "more")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                    }
                    .frame(width: 80, height: 40, alignment: .trailing)
                }
            }
            
            Divider()
                .padding(.leading, 50)
        }
        .frame(width:.screenWidth - 40, height: 44)
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
        AlbumnSongRow(sObj:["duration": "3:56", "name": "I (Find Yourself)"] )
        .background(Color.bg)
        .padding(.bottom, 200 )
}
