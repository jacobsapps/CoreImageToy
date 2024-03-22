//
//  ImageFilterCategory.swift
//  MetalImage
//
//  Created by Jacob Bartlett on 22/03/2024.
//

import CoreImage
import Foundation

struct ImageFilterCategory: Identifiable {
    var id: String { name }
    let name: String
    var filterSelection: [ImageFilterSelection]
}

extension [ImageFilterCategory] {
    var selectedFilters: [CIFilter] {
        self.flatMap { $0.filterSelection }
            .filter { $0.selected }
            .sorted(by: { $0.sortOrder < $1.sortOrder })
            .map { $0.filter }
    }
}

extension [ImageFilterCategory] {
    var nextSortOrder: Int {
        (self.flatMap { $0.filterSelection }
            .map { $0.sortOrder }
            .max() ?? 0) + 1
    }
}
