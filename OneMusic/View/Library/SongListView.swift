//
//  SongListView.swift
//  OneMusic
//
//  Created by 志野陶 on 2025/2/15.
//


import SwiftUI
import PhotosUI

struct SongListView: View {
    @StateObject private var viewModel = SongViewModel()
    @State private var searchQuery: String = ""
    @State private var isShowingForm: Bool = false // 控制表单弹窗的显示
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.songs) { song in
                    SongRow(song: song, coverImage: viewModel.getCoverImage(for: song))
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else if viewModel.currentPage * viewModel.pageSize < viewModel.totalSongs {
                    Button("加载更多") {
                        viewModel.loadNextPage()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("歌曲库 (\(viewModel.totalSongs) 首)")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingForm = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .searchable(text: $searchQuery, prompt: "搜索歌曲")
            .onChange(of: searchQuery) { newQuery in
                viewModel.searchSongs(query: newQuery)
            }
            .alert("错误", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("确定", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .sheet(isPresented: $isShowingForm) {
                SongUploadForm(viewModel: viewModel)
            }
        }
    }
}

struct SongRow: View {
    let song: Song
    let coverImage: UIImage?
    
    var body: some View {
        HStack {
            if let coverImage = coverImage {
                Image(uiImage: coverImage)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
            } else {
                Image(systemName: "music.note")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading) {
                Text(song.title)
                    .font(.headline)
                Text(song.artistName ?? "未知艺术家")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct SongUploadForm: View {
    @ObservedObject var viewModel: SongViewModel
    @State private var isShowingFilePicker: Bool = false
    @State private var selectedFileURL: URL? = nil
    @State private var selectedCoverImage: PhotosPickerItem? = nil
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("歌曲信息")) {
                    TextField("歌曲标题", text: $viewModel.newSongTitle)
                    TextField("艺术家", text: $viewModel.newSongArtist)
                    TextField("专辑", text: $viewModel.newSongAlbum)
                }
                
                Section(header: Text("封面图片")) {
                    if let coverImage = viewModel.newSongCoverImage {
                        Image(uiImage: coverImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .onTapGesture {
                                // 点击图片可以重新选择
                                selectedCoverImage = nil
                                viewModel.newSongCoverImage = nil
                            }
                    } else {
                        PhotosPicker(
                            selection: $selectedCoverImage,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            Label("选择封面图片", systemImage: "photo")
                        }
                        .onChange(of: selectedCoverImage) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let image = UIImage(data: data) {
                                    viewModel.newSongCoverImage = image
                                }
                            }
                        }
                    }
                }
                
                Section {
                    Button("选择音乐文件") {
                        isShowingFilePicker = true
                    }
                    if let fileURL = selectedFileURL {
                        Text("已选择文件: \(fileURL.lastPathComponent)")
                    }
                }
                
                Section {
                    Button("上传") {
                        if let fileURL = selectedFileURL {
                            viewModel.uploadLocalSong(fileURL: fileURL)
                        }
                    }
                    .disabled(selectedFileURL == nil)
                }
            }
            .navigationTitle("上传歌曲")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        viewModel.clearForm()
                        selectedFileURL = nil
                        selectedCoverImage = nil
                    }
                }
            }
            .sheet(isPresented: $isShowingFilePicker) {
                DocumentPicker(fileURL: $selectedFileURL)
            }
        }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var fileURL: URL?
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.mp3], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let url = urls.first {
                parent.fileURL = url
            }
        }
    }
}

#Preview {
    SongListView()
}
