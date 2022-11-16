//
//  Shaders.metal
//  Raycaster_Graficas
//
//  Created by Stefano Aragoni on 14/11/22.
//

#include <metal_stdlib>
using namespace metal;
#import "Common.h"

//almacena vertices para enviar a GPU
struct VertexIn {
    float4 position [[attribute(0)]];
//    float4 color [[attribute(1)]];
};

struct VertexOut {
  float4 position [[position]];
  float4 color;
};


//recibe VertexIn con vertices para enviarlos a GPU
//vertex float4 vertex_main(const VertexIn vertexIn [[stage_in]]) {
//  return vertexIn.position;
//}

// ---------------------------SHADER 1---------------------------------
//recibe VertexIn con vertices para enviarlos a GPU
vertex VertexOut vertex_main(VertexIn in [[stage_in]],constant Uniforms &uniforms [[buffer(1)]]) {
    
    float r = (in.position.x + in.position.y + in.position.z) * 10;
    float g = (in.position.x * in.position.y * in.position.z) * 10;
    float b = (in.position.x + in.position.y * in.position.z) * 10;

  VertexOut out {
   .position = (uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * in.position),
   .color = float4(r,g,b,10)
  };
  return out;
}

fragment float4 fragment_main(VertexOut in [[stage_in]]) {
  return in.color;
}

// ---------------------------SHADER 2---------------------------------
//recibe VertexIn con vertices para enviarlos a GPU
vertex VertexOut vertex_main2(VertexIn in [[stage_in]],constant Uniforms &uniforms [[buffer(1)]]) {
    
    float r = 1;
    float g = 1;
    float b = 1;
    
    if(in.position.y > -0.21){
        g = 0;
        b = 0;
    }

  VertexOut out {
   .position = (uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * in.position),
   .color = float4(r,g,b,1)
  };
  return out;
}

fragment float4 fragment_main2(VertexOut in [[stage_in]]) {
  return in.color;
}


// ---------------------------SHADER 3---------------------------------
//recibe VertexIn con vertices para enviarlos a GPU
vertex VertexOut vertex_main3(VertexIn in [[stage_in]],constant Uniforms &uniforms [[buffer(1)]]) {
    
    float r = 0;
    float g = 0;
    float b = 0;
    
    if(in.position.z > 0){
        r = 1;
        g = 1;
        b = 1;
    }

  VertexOut out {
   .position = (uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * in.position),
   .color = float4(r,g,b,1)
  };
  return out;
}

fragment float4 fragment_main3(VertexOut in [[stage_in]]) {
  return in.color;
}

