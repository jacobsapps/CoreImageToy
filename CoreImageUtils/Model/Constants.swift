//
//  Constants.swift
//  CoreImageUtils
//
//  Created by Jacob Bartlett on 22/03/2024.
//

import CoreImage
import Foundation

enum Constants {
    static let catNames: [String] = ["catKingdom", "rosie", "cody", "luna"]
    
    static let filterCategoryNames: [String] = [kCICategoryDistortionEffect,
                                                kCICategoryGeometryAdjustment,
                                                kCICategoryColorAdjustment,
                                                kCICategoryColorEffect,
                                                kCICategoryStylize,
                                                kCICategoryBlur]
    
    static let customFilters = ImageFilterCategory(name: "Custom filters",
                                                   filterSelection: [ImageFilterSelection(filter: GrainyFilter()),
                                                                     ImageFilterSelection(filter: DiagonalFilter()),
                                                                     ImageFilterSelection(filter: WarmInversionFilter()),
                                                                     ImageFilterSelection(filter: NormalizeFilter()),
                                                                     ImageFilterSelection(filter: WaveFilter())])
}
