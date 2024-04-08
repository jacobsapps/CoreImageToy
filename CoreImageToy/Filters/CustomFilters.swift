//
//  CustomFilters.swift
//  CoreImageToy
//
//  Created by Jacob Bartlett on 22/03/2024.
//

import CoreImage
import CoreImageUtils

@ColorKernel
final class GrainyFilter: CIFilter { }

@ColorKernel
final class DiagonalFilter: CIFilter { }

@ColorKernel
final class WarmInversionFilter: CIFilter { }

@ColorKernel
final class NormalizeFilter: CIFilter { }

@ColorKernel
final class WaveFilter: CIFilter { }

@ColorKernel
final class GallifreyFilter: CIFilter { }

@ColorKernel
final class AlienFilter: CIFilter { }

@ColorKernel
final class GrayscaleFilter: CIFilter { }

@ColorKernel
final class SpectralFilter: CIFilter { }

@SamplerKernel
final class ShiftFilter: CIFilter { }

@SamplerKernel
final class ThreeDGlassesFilter: CIFilter { }

// Proof of concept
final class PixellateFacesFilter: CIFilter {
    
    private let context = CIContext()
    
    @objc dynamic public var inputImage: CIImage?
    
    override public var outputImage: CIImage? {
        guard let input = inputImage else {
            return nil
        }
        
        // Facial detection only works on-device, not simulator
        let options = [CIDetectorAccuracy: CIDetectorAccuracyLow]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: options)!
        let faces = faceDetector.features(in: input)
        
        guard !faces.isEmpty else { return input }
        
        let pixellateFilter = CIFilter(name: "CIPixellate")!
        pixellateFilter.setValue(inputImage, forKey: kCIInputImageKey)
        pixellateFilter.setValue(20, forKey: kCIInputScaleKey)
        guard let pixellatedImage = pixellateFilter.outputImage else { return input }
        
        var maskImage = CIImage(color: CIColor.clear).cropped(to: input.extent)
        
        faces.forEach {
            let bounds = CGRect(x: $0.bounds.minX,
                                y: $0.bounds.minY - ($0.bounds.height / 2),
                                width: $0.bounds.width,
                                height: $0.bounds.height * 1.5)
            let faceRect = CIImage(color: CIColor.white).cropped(to: bounds)
            maskImage = faceRect.composited(over: maskImage)
        }
        
        let blendFilter = CIFilter(name: "CIBlendWithAlphaMask")!
        blendFilter.setValue(pixellatedImage, forKey: kCIInputImageKey)
        blendFilter.setValue(inputImage, forKey: kCIInputBackgroundImageKey)
        blendFilter.setValue(maskImage, forKey: kCIInputMaskImageKey)
        
        return blendFilter.outputImage
    }
}

// Proof of concept
final class OmnidimensionalFaceFilter: CIFilter {
    
    private let context = CIContext()
    
    @objc dynamic public var inputImage: CIImage?
    
    override public var outputImage: CIImage? {
        guard let input = inputImage else {
            return nil
        }
        
        // Facial detection only works on-device, not simulator
        let options = [CIDetectorAccuracy: CIDetectorAccuracyLow]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: options)!
        let faces = faceDetector.features(in: input)
        
        guard !faces.isEmpty else { return input }
        
        let threeDFilter = ThreeDGlassesFilter()
        threeDFilter.setValue(inputImage, forKey: kCIInputImageKey)
        guard let threeDImage = threeDFilter.outputImage else { return input }
        
        var maskImage = CIImage(color: CIColor.clear).cropped(to: input.extent)
        
        faces.forEach {
            let bounds = CGRect(x: $0.bounds.minX,
                                y: $0.bounds.minY - ($0.bounds.height / 4),
                                width: $0.bounds.width,
                                height: $0.bounds.height * 1.5)
            let faceRect = CIImage(color: CIColor.white).cropped(to: bounds)
            maskImage = faceRect.composited(over: maskImage)
        }
        
        let blendFilter = CIFilter(name: "CIBlendWithAlphaMask")!
        blendFilter.setValue(threeDImage, forKey: kCIInputImageKey)
        blendFilter.setValue(inputImage, forKey: kCIInputBackgroundImageKey)
        blendFilter.setValue(maskImage, forKey: kCIInputMaskImageKey)
        
        return blendFilter.outputImage
    }
}

final class ThickGlassSquaresFilter: CIFilter {
    
    private let intensity: Float
    
    init(intensity: Float) {
        self.intensity = intensity
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc dynamic public var inputImage: CIImage?

    override public var outputImage: CIImage? {
        guard let input = inputImage else {
            return nil
        }
        return Self.kernel.apply(extent: input.extent,
                                 roiCallback: {
                $1
            },
                                 image: input,
                                 arguments: [intensity])
    }

    static private var kernel: CIWarpKernel = { () -> CIWarpKernel in
        getDistortionKernel(function: "thickGlassSquares")
    }()
    
    
    static private func getDistortionKernel(function: String) -> CIWarpKernel {
        let url = Bundle.main.url(forResource: "default", withExtension: "metallib")!
        let data = try! Data(contentsOf: url)
        return try! CIWarpKernel(functionName: function, fromMetalLibraryData: data)
    }
}

final class LensFilter: CIFilter {
    
    private let centerX: Float = 0.3
    private let centerY: Float = 0.6
    private let radius: Float = 0.2
    private let intensity: Float = 0.6
    
    @objc dynamic public var inputImage: CIImage?

    override public var outputImage: CIImage? {
        guard let input = inputImage else {
            return nil
        }
        return Self.kernel.apply(extent: input.extent,
                                 roiCallback: {
                $1
            },
                                 image: input,
                                 arguments: [input.extent.width,
                                             input.extent.height,
                                             centerX,
                                             centerY,
                                             radius,
                                             intensity])
    }

    static private var kernel: CIWarpKernel = { () -> CIWarpKernel in
        getDistortionKernel(function: "lensFilter")
    }()
    
    static private func getDistortionKernel(function: String) -> CIWarpKernel {
        let url = Bundle.main.url(forResource: "default", withExtension: "metallib")!
        let data = try! Data(contentsOf: url)
        return try! CIWarpKernel(functionName: function, fromMetalLibraryData: data)
    }
}
