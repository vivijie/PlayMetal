//
//  Vignette.metal
//  MetalPlay
//
//  Created by NEIL WANG on 2024/1/21.
//

#include <metal_stdlib>
using namespace metal;

#include <CoreImage/CoreImage.h>

extern "C" { namespace coreimage {
    float4 vignetteMetal(sample_t image, float2 center, float radius, float alpha, destination dest) {
        float distance2 = distance(dest.coord(), center);
        float darken = 1.0 - (distance2 / radius * alpha);
        image.rgb *= darken;
        return image.rgba;
    }
}}
