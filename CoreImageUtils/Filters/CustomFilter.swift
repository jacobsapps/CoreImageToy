//
//  CustomFilter.swift
//  MetalImage
//
//  Created by Jacob Bartlett on 22/03/2024.
//

import CoreImage

final class GrainyFilter: CIFilter {
    
    static var kernel: CIColorKernel = { () -> CIColorKernel in
        getKernel(function: "grainy")
    }()
    
    @objc dynamic var inputImage: CIImage?
    
    override var outputImage: CIImage? {
        get {
            guard let input = inputImage else { return nil }
            return GrainyFilter.kernel.apply(extent: input.extent, arguments: [input])
        }
    }
}

final class DiagonalFilter: CIFilter {
    
    static var kernel: CIColorKernel = { () -> CIColorKernel in
        getKernel(function: "diagonal")
    }()
    
    @objc dynamic var inputImage: CIImage?
    
    override var outputImage: CIImage? {
        get {
            guard let input = inputImage else { return nil }
            return DiagonalFilter.kernel.apply(extent: input.extent, arguments: [input])
        }
    }
}

final class WarmInversionFilter: CIFilter {
    
    static var kernel: CIColorKernel = { () -> CIColorKernel in
        getKernel(function: "warmInvert")
    }()
    
    @objc dynamic var inputImage: CIImage?
    
    override var outputImage: CIImage? {
        get {
            guard let input = inputImage else { return nil }
            return WarmInversionFilter.kernel.apply(extent: input.extent, arguments: [input])
        }
    }
}

final class NormalizeFilter: CIFilter {
    
    static var kernel: CIColorKernel = { () -> CIColorKernel in
        getKernel(function: "normalize")
    }()
    
    @objc dynamic var inputImage: CIImage?
    
    override var outputImage: CIImage? {
        get {
            guard let input = inputImage else { return nil }
            return NormalizeFilter.kernel.apply(extent: input.extent, arguments: [input])
        }
    }
}

final class WaveFilter: CIFilter {
    
    static var kernel: CIColorKernel = { () -> CIColorKernel in
        getKernel(function: "wave")
    }()
    
    @objc dynamic var inputImage: CIImage?
    
    override var outputImage: CIImage? {
        get {
            guard let input = inputImage else { return nil }
            return WaveFilter.kernel.apply(extent: input.extent, arguments: [input])
        }
    }
}

private func getKernel(function: String) -> CIColorKernel {
    let url = Bundle.main.url(forResource: "default", withExtension: "metallib")!
    let data = try! Data(contentsOf: url)
    return try! CIColorKernel(functionName: function, fromMetalLibraryData: data)
}
