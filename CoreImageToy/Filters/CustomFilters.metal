//
//  CustomFilters.metal
//  CoreImageToy
//
//  Created by Jacob Bartlett on 22/03/2024.
//

#include <metal_stdlib>
#include <CoreImage/CoreImage.h>
using namespace metal;

[[ stitchable ]]
float4 grainy(
    coreimage::sample_t s,
    coreimage::destination dest
) {
    float value = fract(sin(dot(dest.coord(), float2(12.9898, 78.233))) * 43758.5453);
    float4 noise = float4(value, value, value, 1) * 0.1;
    float4 dampingFactor = float4(0, 0, 0, 1) * -0.1;
    return s + noise + dampingFactor;
}

[[ stitchable ]]
float4 diagonal(
    coreimage::sample_t s,
    coreimage::destination dest
) {
    float diagLine = dest.coord().x - dest.coord().y;
    float onDiagonal = fract(diagLine / 10.0);
    if (onDiagonal > 0.5) {
        float4 lightLines = float4(1, 1, 1, 1) * 0.1;
        float4 dampingFactor = float4(0, 0, 0, 1) * -0.1;
        return s + lightLines + dampingFactor;
    }
    return s;
}

[[ stitchable ]]
float4 warmInvert(
    coreimage::sample_t s,
    coreimage::destination dest
) {
    return float4(1 - pow(s.r, 0.35), 1 - pow(s.g, 0.35), 1 - pow(s.b, 0.35), 1.0);
}

[[ stitchable ]]
float4 normalize(
    coreimage::sample_t s,
    coreimage::destination dest
) {
    return float4(pow(s.r, 2), pow(s.g, 2), pow(s.b, 2), 1.0);
}

[[ stitchable ]]
float4 wave(
    coreimage::sample_t s,
    coreimage::destination dest
) {
    float baseOscillation = (sin(dest.coord().x / 15) + 1) * 0.5;
    float minOscillation = 0.8;
    float maxOscillation = 1.0;
    float oscillationRange = maxOscillation - minOscillation;
    float adjustedOscillationFactor = minOscillation + (baseOscillation * oscillationRange);
    return s * adjustedOscillationFactor;
}

[[ stitchable ]]
float4 gallifrey(
    coreimage::sample_t s,
    coreimage::destination dest
) {
    return float4(s.g, s.b, s.r, s.a);
}

[[ stitchable ]]
float4 alien(
    coreimage::sample_t s,
    coreimage::destination dest
) {
    return float4(s.b, s.r, s.g, s.a);
}

[[ stitchable ]]
float4 grayscale(
    coreimage::sample_t s,
    coreimage::destination dest
) {
    float3 grayscaleWeights = float3(0.2125, 0.7154, 0.0721);
    float avgLuminescence = dot(s.rgb, grayscaleWeights);
    return float4(avgLuminescence, avgLuminescence, avgLuminescence, s.a);
}

[[ stitchable ]]
float4 spectral(
    coreimage::sample_t s,
    coreimage::destination dest
) {
    float3 grayscaleWeights = float3(0.2125, 0.7154, 0.0721);
    float avgLuminescence = dot(s.rgb, grayscaleWeights);
    float invertedLuminescence = 1 - avgLuminescence;
    float scaledLumin = pow(invertedLuminescence, 3);
    return float4(scaledLumin, scaledLumin, scaledLumin, s.a);
}

[[ stitchable ]]
float4 shift(
    coreimage::sampler src
) {
    // I actually read the docs!
    // https://developer.apple.com/metal/MetalCIKLReference6.pdf
    float4 shiftedSample = sample(src, src.coord() - float2(0.15, 0.15));
    return shiftedSample;
}

[[ stitchable ]]
float4 voidStuff(
    coreimage::sampler src
) {
    float4 color = sample(src, src.coord());
    float2 redCoord = src.coord() - float2(0.1, 0.1);
    color.r = sample(src, redCoord).r;
    float2 blueCoord = src.coord() + float2(0.05, 0.05);
    color.b = sample(src, blueCoord).b;
    return color * color.a;
}
