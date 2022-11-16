//
//  Primitive.swift
//  Raycaster_Graficas
//
//  Created by Stefano Aragoni on 14/11/22.
//

import MetalKit

class Primitive {
    
    static func makeCube2(device: MTLDevice, size: Float) -> MDLMesh { //crea un mesh de un cubo
        let allocator = MTKMeshBufferAllocator(device: device)
        
        guard let objAsset = Bundle.main.url(                       //IMPORTA OBJ
          forResource: "cube",
          withExtension: "obj") else {
          fatalError()
        }

        let vertexDescriptor = MTLVertexDescriptor()                    //descriptor MTL para obj
        vertexDescriptor.attributes[0].format = .float3                 //almacena coordenadas
        vertexDescriptor.attributes[0].offset = 0                       //indica en donde empieza
        vertexDescriptor.attributes[0].bufferIndex = 0                  //indica en cual de los 31 indices se envia la info

        vertexDescriptor.layouts[0].stride = MemoryLayout<SIMD3<Float>>.stride
        let meshDescriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)
        (meshDescriptor.attributes[0] as! MDLVertexAttribute).name = MDLVertexAttributePosition

        let asset = MDLAsset(url: objAsset,
                             vertexDescriptor: meshDescriptor,
                             bufferAllocator: allocator)

        let mesh = asset.childObjects(of: MDLMesh.self).first as! MDLMesh
        
        return mesh
    }
    
    static func makeCube(device: MTLDevice, size: Float) -> MDLMesh { //crea un mesh de un cubo
        let allocator = MTKMeshBufferAllocator(device: device)
        let mesh = MDLMesh(boxWithExtent: [size, size, size],
                         segments: [1, 1, 1],
                         inwardNormals: false,
                         geometryType: .triangles,                    //dibuja con triangulos
                         allocator: allocator)
        return mesh
    }
}
