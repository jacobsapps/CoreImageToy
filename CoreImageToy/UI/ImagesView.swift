//
//  ImagesView.swift
//  CoreImageToy
//
//  Created by Jacob Bartlett on 21/03/2024.
//

import SwiftUI

struct ImagesView: View {

    @State private var viewModel = ImagesViewModel()
    
    var body: some View {
        List(viewModel.catImages, id: \.self) {
            CatImage(image: $0)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
        }
        .listStyle(PlainListStyle())
        .padding(.bottom, 150)
        .sheet(isPresented: .constant(true)) {
            FilterSelectionControls(viewModel: $viewModel)
        }
    }

}

struct CatImage: View {
    
    let image: UIImage?
    
    var body: some View {
        Image(uiImage: image ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

#Preview {
    ImagesView()
}
