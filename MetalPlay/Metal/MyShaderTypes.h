//
//  MyShaderTypes.h
//  MetalPlay
//
//  Created by NEIL WANG on 2024/1/19.
//

#ifndef MyShaderTypes_h
#define MyShaderTypes_h

#include <simd/simd.h>

typedef struct {
    vector_float2 position;
    vector_float2 textureCoordinate;
} MyVertex;

typedef enum MyVertexInputIndex
{
    MyVertexInputIndexVertices = 0,
    MyVertexInputIndexCount    = 1,
} MyVertexInputIndex;

typedef enum MyTextureIndex
{
    MyTextureIndexBaseColor = 0,
} MyTextureIndex;

#endif /* MyShaderTypes_h */
