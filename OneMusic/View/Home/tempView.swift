import SwiftUI

struct ContentView: View {
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack {
                // 搜索框
                SearchBar(text: $searchText)
                    .padding(.horizontal)

                // 内容列表
                List {
                    ForEach(filteredItems, id: \.self) { item in
                        Text(item)
                    }
                }
                .navigationTitle("Search")
            }
        }
    }

    // 过滤后的数据
    var filteredItems: [String] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    // 示例数据
    let items = ["Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape"]
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search", text: $text)
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

                        if !text.isEmpty {
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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
