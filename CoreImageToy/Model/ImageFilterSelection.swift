//
//  ImageFilterSelection.swift
//  CoreImageToy
//
//  Created by Jacob Bartlett on 22/03/2024.
//

import CoreImage
import Foundation

struct ImageFilterSelection: Identifiable {
    
    var id: String { filter.name }
    let filter: CIFilter
    var selected: Bool
    var sortOrder: Int = 0
    
    init(filter: CIFilter) {
        self.filter = filter
        self.selected = false
    }
}
