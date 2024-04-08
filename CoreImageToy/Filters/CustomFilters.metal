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
float4 grainyFilter(
    coreimage::sample_t s,
    coreimage::destination dest
) {
    float value = fract(sin(dot(dest.coord() / 1000, float2(12.9898, 78.233))) * 43758.5453);
    float3 noise = float3(value, value, value) * 0.1;
    float3 dampingFactor = float3(0, 0, 0) * -0.1;
    return float4(s.rgb + noise + dampingFactor, s.a);
}

[[ stitchable ]]
float4 diagonalFilter(
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
float4 warmInversionFilter(
    coreimage::sample_t s
) {
    return float4(1 - pow(s.r, 0.35), 1 - pow(s.g, 0.35), 1 - pow(s.b, 0.35), 1.0);
}

[[ stitchable ]]
float4 normalizeFilter(
    coreimage::sample_t s
) {
    return float4(pow(s.r, 2), pow(s.g, 2), pow(s.b, 2), 1.0);
}

[[ stitchable ]]
float4 waveFilter(
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
float4 gallifreyFilter(
    coreimage::sample_t s
) {
    return float4(s.g, s.b, s.r, s.a);
}

[[ stitchable ]]
float4 alienFilter(
    coreimage::sample_t s
) {
    return float4(s.b, s.r, s.g, s.a);
}

[[ stitchable ]]
float4 grayscaleFilter(
    coreimage::sample_t s
) {
    float3 grayscaleWeights = float3(0.2125, 0.7154, 0.0721);
    float avgLuminescence = dot(s.rgb, grayscaleWeights);
    return float4(avgLuminescence, avgLuminescence, avgLuminescence, s.a);
}

[[ stitchable ]]
float4 spectralFilter(
    coreimage::sample_t s
) {
    float3 grayscaleWeights = float3(0.2125, 0.7154, 0.0721);
    float avgLuminescence = dot(s.rgb, grayscaleWeights);
    float invertedLuminescence = 1 - avgLuminescence;
    float scaledLumin = pow(invertedLuminescence, 3);
    return float4(scaledLumin, scaledLumin, scaledLumin, s.a);
}

[[ stitchable ]]
float4 shiftFilter(
    coreimage::sampler src
) {
    // I actually read the docs!
    // https://developer.apple.com/metal/MetalCIKLReference6.pdf
    float4 shiftedSample = sample(src, src.coord() - float2(0.15, 0.15));
    return shiftedSample;
}

[[ stitchable ]]
float4 threeDGlassesFilter(
    coreimage::sampler src
) {
    float4 color = sample(src, src.coord());
    float2 redCoord = src.coord() - float2(0.04, 0.04);
    color.r = sample(src, redCoord).r;
    float2 blueCoord = src.coord() + float2(0.02, 0.02);
    color.b = sample(src, blueCoord).b;
    return color * color.a;
}

[[ stitchable ]]
float2 thickGlassSquares(
    float intensity,
    coreimage::destination dest
) {
    return float2(dest.coord().x + (intensity * (sin(dest.coord().x / 40))),
                  dest.coord().y + (intensity * (sin(dest.coord().y / 40))));
}

[[ stitchable ]]
float2 lensFilter(
    float width,
    float height,
    float centerX,
    float centerY,
    float radius,
    float intensity,
    coreimage::destination dest
) {
    float2 size = float2(width, height);
    float2 normalizedCoord = dest.coord() / size;
    float2 center = float2(centerX, centerY);
    float distanceFromCenter = distance(normalizedCoord, center);
    
    if (distanceFromCenter < radius) {
        float2 vectorFromCenter = normalizedCoord - center;
        float normalizedDistance = pow(distanceFromCenter / radius, 4);
        float distortion = sin(M_PI_2_F * normalizedDistance) * intensity;
        float2 distortedPosition = center + (vectorFromCenter * (1 + distortion));
        return distortedPosition * size;

    } else {
        return dest.coord();
    }
}
