//
//  CustomFilters.metal
//  MetalImage
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
