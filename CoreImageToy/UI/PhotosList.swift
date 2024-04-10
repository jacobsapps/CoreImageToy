//
//  PhotosList.swift
//  CoreImageToy
//
//  Created by Jacob Bartlett on 21/03/2024.
//

import SwiftUI
import PhotosUI

struct PhotosList: View {
    
    @State private var viewModel = PhotosViewModel()
    @State private var pickerItemSelection = [PhotosPickerItem]()
    
    var body: some View {
        NavigationStack {
            photosViewBody
                .onChange(of: pickerItemSelection) {
                    viewModel.removeAllPhotos()
                    Task {
                        let images = await withTaskGroup(of: Data?.self, returning: [UIImage].self) { group in
                            for item in pickerItemSelection {
                                group.addTask {
                                    try? await item.loadTransferable(type: Data.self)
                                }
                            }
                            return await group
                                .compactMap { $0 }
                                .reduce(into: [UIImage]()) { partialResult, data in
                                    partialResult.append(UIImage(data: data))
                                }.compactMap { $0 }
                        }
                        viewModel.photoSelection = images
                        viewModel.filteredPhotos = images
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        
                        Button(action: {
                            viewModel.removeAllPhotos()
                            
                        }, label: {
                            Image(systemName: "trash")
                        })
                        
//                        Button(action: {
//                            Task {
//                                await viewModel.sharePhotos()
//                            }
//                            
//                        }, label: {
//                            Image(systemName: "square.and.arrow.up")
//                        })
                    }
                }
                .navigationTitle("Core Image Toy")
        }
    }
    
    @ViewBuilder var photosViewBody: some View {
        if viewModel.filteredPhotos.isEmpty {
            PhotosPicker("Select Photos", selection: $pickerItemSelection, matching: .images)
            
        } else {
            List(viewModel.filteredPhotos.compactMap { $0 }, id: \.self) {
                Photo(image: $0)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            .padding(.bottom, 200)
            .sheet(isPresented: .constant(!viewModel.filteredPhotos.isEmpty)) {
                FilterSelectionControls(viewModel: $viewModel)
            }
        }
    }
}

struct Photo: View {
    
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

#Preview {
    PhotosList()
}
