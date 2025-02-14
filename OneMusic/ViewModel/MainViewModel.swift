//
//  MainViewModel.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/11.
//

import SwiftUI

class MainViewModel: ObservableObject {
    static var share: MainViewModel = MainViewModel()
    
    @Published var selectTab: Int = 0
    @Published var isShowSideMenu: Bool = false
}
