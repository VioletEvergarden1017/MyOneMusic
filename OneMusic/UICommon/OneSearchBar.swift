//
//  SearchBar.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/12.
//

import SwiftUI

struct OneSearchBar: View {

    @State var text: String
    @State private var isEditing = false

        var body: some View {
            HStack {

                TextField("Search ...", text: $text)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)

                            if isEditing {
                                Button(action: {
                                    self.text = ""
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                    )
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        withAnimation {
                            self.isEditing = true
                        }
                    }


                if isEditing {
                    Button(action: {
                        self.isEditing = false
                        self.text = ""

                    }) {
                        Text("Cancel")
                    }
                    .padding(.trailing, 10)
                    .transition(.move(edge: .trailing))
                }
            }
        }
}


#Preview {
    OneSearchBar(text: "")
}
