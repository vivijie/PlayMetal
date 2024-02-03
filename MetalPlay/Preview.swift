//
//  MetalModel.swift
//  MetalPlay
//
//  Created by NEIL WANG on 2024/1/19.
//

import UIKit
import MetalKit
import SwiftUI

struct Preview: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        // MTLDevice
        let device = MTLCreateSystemDefaultDevice()!
        let frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        let view = MTKView(frame: frame, device: device)
        view.preferredFramesPerSecond = 30
        
        
        // Allow Core Image to render to the view using the Metal compute pipeline.
        view.framebufferOnly = false
        if let layer = view.layer as? CAMetalLayer {
            // Enable EDR with a color space that supports values greater than SDR.
            if #available(iOS 16.0, *) {
                layer.wantsExtendedDynamicRangeContent = true
            }
            layer.colorspace = CGColorSpace(name: CGColorSpace.extendedLinearDisplayP3)
            // Ensure the render view supports pixel values in EDR.
            view.colorPixelFormat = MTLPixelFormat.rgba16Float
        }
        
        
        guard let drawable = view.currentDrawable else {
            fatalError("LLL")
        }
        
        // MTLBuffer
        var vertexBuffer: MTLBuffer!
        let vvv = [MyVertex(position: [-1.0, -1.0], textureCoordinate: [0, 1]),
                   MyVertex(position: [-1.0, 1.0], textureCoordinate: [0, 0]),
                   MyVertex(position: [1.0, -1.0], textureCoordinate: [1, 1]),
                   MyVertex(position: [1.0, 1.0], textureCoordinate: [1, 0])
        ]
        vertexBuffer = device.makeBuffer(bytes: vvv, length: MemoryLayout<MyVertex>.size * vvv.count, options: .cpuCacheModeWriteCombined)
        
        // MTLTexture
        var textrue: MTLTexture!
        let image = UIImage(named: "Jay")
        textrue = newTextrue(with: image, device: device)

        // Render Pass
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.48, 0.74, 0.92, 1)
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        
        // commandQueue\commandBuffer\commandEncoder
        guard let commandQueue = device.makeCommandQueue() else {
            fatalError("no commandQueue")
        }
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        // Pipeline
        let library = device.makeDefaultLibrary()!
        let vertexFunction = library.makeFunction(name: "vertexShader")
        let fragmentFunction = library.makeFunction(name: "fragmentShader")
        
        let piplelineDescriptor = MTLRenderPipelineDescriptor()
        piplelineDescriptor.vertexFunction = vertexFunction
        piplelineDescriptor.fragmentFunction = fragmentFunction
        piplelineDescriptor.colorAttachments[0].pixelFormat = drawable.layer.pixelFormat
        
        var pipelineState: MTLRenderPipelineState!
        pipelineState = try! device.makeRenderPipelineState(descriptor: piplelineDescriptor)
        
        // Pipleline —> Command Encoder
        commandEncoder.setRenderPipelineState(pipelineState)
        // Buffer —> Texture —> Draw
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder.setFragmentTexture(textrue, index: 0)
        commandEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: vvv.count)
        
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
        
        return view
    }
    
    func newTextrue(with image: UIImage?, device: MTLDevice) -> MTLTexture? {
        let imageRef = (image?.cgImage)!
        let width = imageRef.width
        let height = imageRef.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let rawData = calloc(height * width * 4, MemoryLayout<UInt8>.size)
        let bytesPerPixel: Int = 4
        let bytesPerRow: Int = bytesPerPixel * width
        let bitsPerComponent: Int = 8
        let bitmapContext = CGContext(data: rawData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
        bitmapContext?.draw(imageRef, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm, width: width, height: height, mipmapped: false)
        let texture: MTLTexture? = device.makeTexture(descriptor: textureDescriptor)
        let region: MTLRegion = MTLRegionMake2D(0, 0, width, height)
        texture?.replace(region: region, mipmapLevel: 0, withBytes: rawData!, bytesPerRow: bytesPerRow)
        free(rawData)
        return texture
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Do nothing
        print("updating")
    }
}
