//
//  PhotosViewModel.swift
//  CoreImageToy
//
//  Created by Jacob Bartlett on 21/03/2024.
//

import CoreImage
import PhotosUI
import SwiftUI

@Observable
final class PhotosViewModel {

    private let context = CIContext()
    
    var photoSelection: [UIImage?] = []
    var filteredPhotos: [UIImage?] = []
    var filterCategories: [ImageFilterCategory]
    
    init() {
        filterCategories = Constants.filterCategoryNames.toFilterCategories() + CollectionOfOne(Constants.customFilters)
    }
    
    func updateFilters() {
        filteredPhotos = photoSelection
            .map { apply(filters: filterCategories.selectedFilters, to: $0) }
    }
    
    func isSelected(category: ImageFilterCategory, selection: ImageFilterSelection) -> Bool {
        guard let categoryIndex = filterCategories.firstIndex(where: { $0.id == category.id }),
              let selectionIndex = filterCategories[categoryIndex].filterSelection.firstIndex(where: { $0.id == selection.id }) else { return false }
        return filterCategories[categoryIndex].filterSelection[selectionIndex].selected
    }
    
    func select(category: ImageFilterCategory, selection: ImageFilterSelection) {
        guard let categoryIndex = filterCategories.firstIndex(where: { $0.id == category.id }),
              let selectionIndex = filterCategories[categoryIndex].filterSelection.firstIndex(where: { $0.id == selection.id }) else { return }
        let isSelected = filterCategories[categoryIndex].filterSelection[selectionIndex].selected
        filterCategories[categoryIndex].filterSelection[selectionIndex].sortOrder = isSelected ? 0 : filterCategories.nextSortOrder
        filterCategories[categoryIndex].filterSelection[selectionIndex].selected.toggle()
        updateFilters()
    }
    
    func removeAllFilters() {
        filterCategories = Constants.filterCategoryNames.toFilterCategories() + CollectionOfOne(Constants.customFilters)
        updateFilters()
    }
    
    func removeAllPhotos() {
        withAnimation {
            photoSelection = []
            filteredPhotos = []
        }
        removeAllFilters()
    }
    
    private func apply(filters: [CIFilter], to image: UIImage?) -> UIImage? {
        guard let image else { return nil }
        guard let ciImage = CIImage(image: image) else { return image }
        let filteredImage = filters.reduce(ciImage) { image, filter in
            filter.setValue(image, forKey: kCIInputImageKey)
            guard let output = filter.outputImage else { return image }
            return output
        }
        guard let cgImage = context.createCGImage(filteredImage, from: filteredImage.extent) else { return image }
        return UIImage(cgImage: cgImage)
    }
}

private extension [String] {
    
    func toFilterCategories() -> [ImageFilterCategory] {
        map { categoryName in
            ImageFilterCategory(name: categoryName,
                                filterSelection: CIFilter
                .filterNames(inCategories: [categoryName])
                .compactMap { CIFilter(name: $0) }
                .filter { $0.inputKeys.contains(kCIInputImageKey) }
                .compactMap { ImageFilterSelection(filter: $0) }
            )
        }
    }
}
