//
//  Renderer.swift
//  Raycaster_Graficas
//
//  Created by Stefano Aragoni on 14/11/22.
//

import MetalKit

class Renderer: NSObject {
    
    var timer: Float = 0                            //timer
    var uniforms = Uniforms()
    
    static var device: MTLDevice!                   //hace referencia al device (GPU)
    static var commandQueue: MTLCommandQueue!       //almacena y guarda instrucciones
    var mesh: MTKMesh!                              //mesh de objeto a dibujar
    var vertexBuffer: MTLBuffer!                    //almacena vertex info a enviar a GPU
    var pipelineState1: MTLRenderPipelineState!      //almacena shaders, colores y otros a utilizar
    var pipelineState2: MTLRenderPipelineState!      //almacena shaders, colores y otros a utilizar
    var pipelineState3: MTLRenderPipelineState!      //almacena shaders, colores y otros a utilizar
    
    var camera = Camera(x:0, y:0, x2: 0, y2: 0)

  init(metalView: MTKView) {
      //inicializa el GPU
      guard
        let device = MTLCreateSystemDefaultDevice(),
        let commandQueue = device.makeCommandQueue() else {
          fatalError("GPU not available")
      }
      Renderer.device = device
      Renderer.commandQueue = commandQueue          //crea un command queue
      metalView.device = device
      
      //-----------------------DIBUJO---------------------------
      let mdlMesh = Primitive.makeCube2(device: device, size: 1)
      do {
        mesh = try MTKMesh(mesh: mdlMesh, device: device)
      } catch let error {
          print(error.localizedDescription)
      }
          
      vertexBuffer = mesh.vertexBuffers[0].buffer  //Le da al vertexbuffer las coordenadas del mesh
      
      
      //--------------------------FUNCIONES GPU PIPELINESTATE1--------------------------
    
      //crea las funciones en el GPU
      var library = device.makeDefaultLibrary()
      var vertexFunction = library?.makeFunction(name: "vertex_main")
      var fragmentFunction = library?.makeFunction(name: "fragment_main")


      //creacion del pipeline a traves de un descriptor
      var pipelineDescriptor = MTLRenderPipelineDescriptor()
      pipelineDescriptor.vertexFunction = vertexFunction                      //funcion GPU de vertex
      pipelineDescriptor.fragmentFunction = fragmentFunction                  //funcion GPU de fragment

      //creacion del descriptor de vertices, maneja la memoria de vertices
      pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mdlMesh.vertexDescriptor)
      pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
      do {
        pipelineState1 =
          try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
      } catch let error {
        fatalError(error.localizedDescription)
      }
      
      //--------------------------FUNCIONES GPU PIPELINESTATE2--------------------------
    
      //crea las funciones en el GPU
      library = device.makeDefaultLibrary()
      vertexFunction = library?.makeFunction(name: "vertex_main2")
      fragmentFunction = library?.makeFunction(name: "fragment_main2")


      //creacion del pipeline a traves de un descriptor
      pipelineDescriptor = MTLRenderPipelineDescriptor()
      pipelineDescriptor.vertexFunction = vertexFunction                      //funcion GPU de vertex
      pipelineDescriptor.fragmentFunction = fragmentFunction                  //funcion GPU de fragment

      //creacion del descriptor de vertices, maneja la memoria de vertices
      pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mdlMesh.vertexDescriptor)
          
      pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
      do {
        pipelineState2 =
          try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
      } catch let error {
        fatalError(error.localizedDescription)
      }
      
      //--------------------------FUNCIONES GPU PIPELINESTATE3--------------------------
    
      //crea las funciones en el GPU
      library = device.makeDefaultLibrary()
      vertexFunction = library?.makeFunction(name: "vertex_main3")
      fragmentFunction = library?.makeFunction(name: "fragment_main3")


      //creacion del pipeline a traves de un descriptor
      pipelineDescriptor = MTLRenderPipelineDescriptor()
      pipelineDescriptor.vertexFunction = vertexFunction                      //funcion GPU de vertex
      pipelineDescriptor.fragmentFunction = fragmentFunction                  //funcion GPU de fragment

      //creacion del descriptor de vertices, maneja la memoria de vertices
      pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mdlMesh.vertexDescriptor)
          
      pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
      do {
        pipelineState3 =
          try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
      } catch let error {
        fatalError(error.localizedDescription)
      }
      
      //-----------------------------------------------------------

      super.init()
      
      metalView.clearColor = MTLClearColor(red: 0.1, green: 0.1,
                                           blue: 0.1, alpha: 1.0)       //color de fondo de frame
      metalView.delegate = self                 //permite utilizar funciones de Metal para dibujar
      
      
      //---------------------------TRANSFORMACIONES OBJETO--------------------------------
      
      let translation = float4x4(translation: [0, 0, 0])
      let rotation = float4x4(rotation: [0, Float(180).degreesToRadians, 0])
      uniforms.modelMatrix = translation * rotation
      uniforms.viewMatrix = float4x4(translation: [0, 0, 0]).inverse
      mtkView(metalView, drawableSizeWillChange: metalView.bounds.size)

  }
}

//permite que cada vez que se cambia tamano de pantalla, se actualice el dibujo
extension Renderer: MTKViewDelegate {
  func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
      let aspect = Float(view.bounds.width) / Float(view.bounds.height)     //aspect rratio
      let projectionMatrix =
        float4x4(projectionFov: Float(70).degreesToRadians,                 //cambios resultantes de matriz
                 near: 0.001,
                 far: 100,
                 aspect: aspect)
      uniforms.projectionMatrix = projectionMatrix                          //proyeccion final
  }
  
//dibuja en cada frame
  func draw(in view: MTKView) {
      
      guard let commandBuffer = Renderer.commandQueue.makeCommandBuffer(),                 //almacena comandos a realizar
        let renderPassDescriptor = view.currentRenderPassDescriptor,              //almacena informacion sobre attachments.
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor:    //almacena informacion para dibujar
          renderPassDescriptor)
      else { fatalError() }
      
      //-----------------------------------------------------------
      let xR = camera.retXR()
      let yR = camera.retYR()
      let xT = camera.retXT()
      let yT = camera.retYT()
      
      let shader = camera.getShader()

      let translation = float4x4(translation: [Float(xT), Float(yT), 0])
      let rotation = float4x4(rotation: [Float(xR).degreesToRadians, Float(yR).degreesToRadians, 0])     //SIMULA LA CAMARA
      uniforms.modelMatrix = translation * rotation
      uniforms.viewMatrix = float4x4(translation: [0, 0, -3]).inverse
      
      renderEncoder.setVertexBytes(&uniforms,
                                   length: MemoryLayout<Uniforms>.stride, index: 1)
      

      //-----------------------------------------------------------
      
      if(shader == 1){
          renderEncoder.setRenderPipelineState(pipelineState2)                     //le da al renderEncoder el pipeline state
      }else if(shader == 2){
          renderEncoder.setRenderPipelineState(pipelineState1)                     //le da al renderEncoder el pipeline state
      }else if(shader == 3){
          renderEncoder.setRenderPipelineState(pipelineState3)                     //le da al renderEncoder el pipeline state
      }
      
      renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)             //le da al renderEncoder los puntos del mesh
//      renderEncoder.setTriangleFillMode(.fill)             //indica como presentar el obj
      
      
      for submesh in mesh.submeshes {
        
        renderEncoder.drawIndexedPrimitives(
            type: .triangle,
            indexCount: submesh.indexCount,
            indexType: submesh.indexType,
            indexBuffer: submesh.indexBuffer.buffer,
            indexBufferOffset: submesh.indexBuffer.offset
        )
        
      }
      
      renderEncoder.endEncoding()                             //se le dice al renderEncoder que ya no se dibujara mas
      
      guard let drawable = view.currentDrawable else {        //se obtiene lo que se dibujo
        fatalError()
      }

      commandBuffer.present(drawable)                         //se le da al comandBuffer lo que se tiene que dibujar
      commandBuffer.commit()                                  //se termina de dar info y lo manda al GPU
  }
}
