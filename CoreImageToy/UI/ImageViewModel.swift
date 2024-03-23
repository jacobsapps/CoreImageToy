//
//  ImagesViewModel.swift
//  CoreImageToy
//
//  Created by Jacob Bartlett on 21/03/2024.
//

import CoreImage
import SwiftUI

@Observable
final class ImagesViewModel {

    private let context = CIContext()
    
    var catImages: [UIImage?] = []
    var filterCategories: [ImageFilterCategory]
    
    init() {
        catImages = Constants.catNames
            .compactMap { UIImage(named: $0) }
        filterCategories = CollectionOfOne(Constants.customFilters) + Constants.filterCategoryNames.toFilterCategories()
    }
    
    func updateFilters() {
        catImages = Constants.catNames
            .compactMap { UIImage(named: $0) }
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
        filterCategories = CollectionOfOne(Constants.customFilters) + Constants.filterCategoryNames.toFilterCategories()
        updateFilters()
    }
    
    private func apply(filter: CIFilter, to image: UIImage) -> UIImage {
        let originalImage = CIImage(image: image)
        filter.setValue(originalImage, forKey: kCIInputImageKey)
        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return image }
        return UIImage(cgImage: cgImage)
    }
    
    private func apply(filter1: CIFilter, filter2: CIFilter, to image: UIImage) -> UIImage {
        let originalImage = CIImage(image: image)
        filter1.setValue(originalImage, forKey: kCIInputImageKey)
        guard let output1 = filter1.outputImage else { return image }
        filter2.setValue(output1, forKey: kCIInputImageKey)
        guard let output2 = filter2.outputImage,
              let cgImage = context.createCGImage(output2, from: output2.extent) else { return image }
        return UIImage(cgImage: cgImage)
    }
    
    private func apply(filters: [CIFilter], to image: UIImage) -> UIImage {
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
