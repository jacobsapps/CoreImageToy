//
//  Constants.swift
//  CoreImageToy
//
//  Created by Jacob Bartlett on 22/03/2024.
//

import CoreImage
import Foundation

enum Constants {
    
    static let filterCategoryNames: [String] = [kCICategoryColorEffect,
                                                kCICategoryStylize,
                                                kCICategoryBlur,
                                                kCICategoryDistortionEffect,
                                                kCICategoryColorAdjustment,
                                                kCICategoryGeometryAdjustment]
    
    static let customFilters = ImageFilterCategory(
        name: "My custom filters",
        filterSelection: [
            ImageFilterSelection(filter: GrainyFilter()),
            ImageFilterSelection(filter: DiagonalFilter()),
            ImageFilterSelection(filter: WarmInversionFilter()),
            ImageFilterSelection(filter: NormalizeFilter()),
            ImageFilterSelection(filter: WaveFilter()),
            ImageFilterSelection(filter: GallifreyFilter()),
            ImageFilterSelection(filter: AlienFilter()),
            ImageFilterSelection(filter: GrayscaleFilter()),
            ImageFilterSelection(filter: SpectralFilter()),
            ImageFilterSelection(filter: ShiftFilter()),
            ImageFilterSelection(filter: ThreeDGlassesFilter()),
            ImageFilterSelection(filter: PixellateFacesFilter()),
            ImageFilterSelection(filter: OmnidimensionalFaceFilter()),
            ImageFilterSelection(filter: ThickGlassSquaresFilter(intensity: 50)),
            ImageFilterSelection(filter: LensFilter())
        ]
    )
}
