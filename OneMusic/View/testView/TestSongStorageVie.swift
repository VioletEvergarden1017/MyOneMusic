//
//  TestSongStorageVie.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/14.
//

import SwiftUI

struct TestSongStorageVie: View {
    
    @ObservedObject private var viewModel = SongViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    ForEach(0..<viewModel.songs.count, id: \.self) { index in
                        let sObj = viewModel.songs[index]
                        
                        TestSongCell(sObj: sObj)
                    }
                }
            }
            .navigationTitle("Songs")
            .navigationBarTitleDisplayMode(.automatic)
            .frame(width: .screenWidth, height: .screenHeight)
            .background(Color.bg)
            .ignoresSafeArea()
        }

        
    }
}

#Preview {
    TestSongStorageVie()
}
