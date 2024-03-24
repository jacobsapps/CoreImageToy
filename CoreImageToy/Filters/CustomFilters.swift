//
//  CustomFilters.swift
//  CoreImageToy
//
//  Created by Jacob Bartlett on 22/03/2024.
//

import CoreImage

// TODO: Lots of boilerplate here, can I make this into a macro?
private func getKernel(function: String) -> CIColorKernel {
    let url = Bundle.main.url(forResource: "default", withExtension: "metallib")!
    let data = try! Data(contentsOf: url)
    return try! CIColorKernel(functionName: function, fromMetalLibraryData: data)
}

final class GrainyFilter: CIFilter {
    
    static var kernel: CIColorKernel = { () -> CIColorKernel in
        getKernel(function: "grainy")
    }()
    
    @objc dynamic var inputImage: CIImage?
    
    override var outputImage: CIImage? {
        get {
            guard let input = inputImage else { return nil }
            return Self.kernel.apply(extent: input.extent, arguments: [input])
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
            return Self.kernel.apply(extent: input.extent, arguments: [input])
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
            return Self.kernel.apply(extent: input.extent, arguments: [input])
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
            return Self.kernel.apply(extent: input.extent, arguments: [input])
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
            return Self.kernel.apply(extent: input.extent, arguments: [input])
        }
    }
}

final class GallifreyFilter: CIFilter {
    
    static var kernel: CIColorKernel = { () -> CIColorKernel in
        getKernel(function: "gallifrey")
    }()
    
    @objc dynamic var inputImage: CIImage?
    
    override var outputImage: CIImage? {
        get {
            guard let input = inputImage else { return nil }
            return Self.kernel.apply(extent: input.extent, arguments: [input])
        }
    }
}

final class AlienFilter: CIFilter {
    
    static var kernel: CIColorKernel = { () -> CIColorKernel in
        getKernel(function: "alien")
    }()
    
    @objc dynamic var inputImage: CIImage?
    
    override var outputImage: CIImage? {
        get {
            guard let input = inputImage else { return nil }
            return Self.kernel.apply(extent: input.extent, arguments: [input])
        }
    }
}

final class GrayscaleFilter: CIFilter {
    
    static var kernel: CIColorKernel = { () -> CIColorKernel in
        getKernel(function: "grayscale")
    }()
    
    @objc dynamic var inputImage: CIImage?
    
    override var outputImage: CIImage? {
        get {
            guard let input = inputImage else { return nil }
            return Self.kernel.apply(extent: input.extent, arguments: [input])
        }
    }
}

final class SpectralFilter: CIFilter {
    
    static var kernel: CIColorKernel = { () -> CIColorKernel in
        getKernel(function: "spectral")
    }()
    
    @objc dynamic var inputImage: CIImage?
    
    override var outputImage: CIImage? {
        get {
            guard let input = inputImage else { return nil }
            return Self.kernel.apply(extent: input.extent, arguments: [input])
        }
    }
}


final class ShiftFilter: CIFilter {
    
    static var kernel: CIKernel = { () -> CIKernel in
        getBaseCIKernel(function: "shift")
    }()
    
    @objc dynamic var inputImage: CIImage?
    
    // Slightly more ceremony here since we are passing a
    // coreimage::sampler to the shader rather than an image
    override var outputImage: CIImage? {
        get {
            guard let input = inputImage else { return nil }
            let sampler = CISampler(image: input)
            return Self.kernel.apply(extent: input.extent,
                                     roiCallback: { $1 },
                                     arguments: [sampler])
        }
    }
    
    private static func getBaseCIKernel(function: String) -> CIKernel {
        let url = Bundle.main.url(forResource: "default", withExtension: "metallib")!
        let data = try! Data(contentsOf: url)
        return try! CIKernel(functionName: function, fromMetalLibraryData: data)
    }
}

final class VoidStuffFilter: CIFilter {
    
    static var kernel: CIKernel = { () -> CIKernel in
        getBaseCIKernel(function: "voidStuff")
    }()
    
    @objc dynamic var inputImage: CIImage?
    
    // Slightly more ceremony here since we are passing a
    // coreimage::sampler to the shader rather than an image
    override var outputImage: CIImage? {
        get {
            guard let input = inputImage else { return nil }
            let sampler = CISampler(image: input)
            return Self.kernel.apply(extent: input.extent,
                                     roiCallback: { $1 },
                                     arguments: [sampler])
        }
    }
    
    private static func getBaseCIKernel(function: String) -> CIKernel {
        let url = Bundle.main.url(forResource: "default", withExtension: "metallib")!
        let data = try! Data(contentsOf: url)
        return try! CIKernel(functionName: function, fromMetalLibraryData: data)
    }
}
