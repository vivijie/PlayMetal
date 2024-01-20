//
//  MetalModel.swift
//  MetalPlay
//
//  Created by NEIL WANG on 2024/1/19.
//

import MetalKit
import UIKit
import SwiftUI

struct MetalModel: MTKViewrep {
    
    func makeUIView(context: Context) -> some UIView {
        
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
    let device = MTLCreateSystemDefaultDevice()!
    let frame = CGRect(x: 0, y: 0, width: 400, height: 400)
    
    init(frame: CGRect) {
        self.frame = frame
    }
    
    let view = MTKView(frame: frame, device: device)

    func render() {
        guard let drawable = view.currentDrawable else {
            fatalError("LLL")
        }
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.48, 0.74, 0.92, 1)
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        
        /// Step1: Device created commandQueue
        guard let commandQueue = device.makeCommandQueue() else {
            fatalError("no commandQueue")
        }
        /// Step2: commandQueue created commandBuffer
        let commandBuffer = commandQueue.makeCommandBuffer()!
        /// Step3: commandBuffer created commandEncoder depend on descriptor
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

}
