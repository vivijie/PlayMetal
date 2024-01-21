//
//  Shaders.metal
//  MetalPlay
//
//  Created by NEIL WANG on 2024/1/19.
//

#include <metal_stdlib>
using namespace metal;

#import "MyShaderTypes.h"

typedef struct {
    float4 position [[position]];
    float2 textCoords;
} RasterizerData;

vertex RasterizerData vertexShader(constant MyVertex *vertices [[buffer(MyVertexInputIndexVertices)]],
                                     uint vid [[vertex_id]])
{
    RasterizerData outVertex;

    outVertex.position = vector_float4(vertices[vid].position, 0.0, 1.0);
    outVertex.textCoords = vertices[vid].textureCoordinate;

    return outVertex;
}

fragment float4 fragmentShader(RasterizerData inVertex [[stage_in]],
                               texture2d<float> tex2d [[texture(MyTextureIndexBaseColor)]]) {
    //即 const 修饰的是类型，constexpr 修饰的是用来算出值的那段代码。
    //在 MSL 中，Sampler 必须用 constexpr 来修饰。所以，记住它就好了。
    constexpr sampler textureSampler (mag_filter::linear, min_filter::linear);
    return float4(tex2d.sample(textureSampler, inVertex.textCoords));
}
