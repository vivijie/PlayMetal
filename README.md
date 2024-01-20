Play Metal

![render](https://github.com/vivijie/PlayMetal/assets/1608522/3d11ab79-ce8a-453c-9d02-5fc2f39981fb)


**MTLDevice**

我们需要给 GPU 下发对应的指令，渲染管线才能有序的进行工作，而具体的指令，在 Metal 中则是通过 MTLCommandEncoder （渲染相关的，具体是 MTLRenderCommandEncoder）来体现。

为了生成 MTLRenderCommandEncoder，需要依赖 
**MTLRenderPassDescriptor **
- 描述渲染过程
- 告诉 MEtal 在一个渲染的过程中做什么动作
texture
loadAction
storeAction
cleanColor

**MTLRenderCommandEncoder**
我们可以看到，我们所谓的指令，被用我们可以编码、理解的形式，配置到 Command Encoder 上，然后 Command Encoder 将我们描述的高级指令，编码转换成 GPU 可以理解的低级指令，写入 Command Buffer 中。




// 图元绘制相关

MTLRenderPipelineDescriptor描述了渲染管线的状态，而MTLRenderPassDescriptor表示了编码的渲染命令的目的地。它们之间的关系在Metal中非常重要，因为它们共同定义了渲染过程中的状态和目的地。

![51976F6E-6E7B-4125-AA3B-9829949BAA0B](https://github.com/vivijie/PlayMetal/assets/1608522/7d1837b5-fe1d-47b9-aa9e-c1f2c679b5b4)

MTLRenderPipelineDescriptor
对各个阶段要用到的，比如顶点数据、顶点着色器、片段着色器等，进行描述。

步骤：
1. 顶点
setVertexBytes    通过顶点创建 MTLBuffer
2. 图元
drawPrimitives    绘制图元
3. 着色
makeDefaultLibrary + makeFunction    提取环境中的着色器函数
配置到 MTLRenderPipelineDescriptor
MTLRenderPipelineDescriptor 创建出对应的 MTLRenderPipelineState

// 因为着色是先配置，运行的时候才 Encoder，所以代码顺序可以是：配置着色器 - 顶点 - 图元

这里提一点，pipelineDescriptor.colorAttachments[0] 与 render pass 中的相对应，表示这个渲染管线渲染的目的 texture。需要显式的设置它的 pixelFormat，不然 GPU 不知道要怎么进行内存排布。这里设置成和 layer 的一致即可（我们的 drawable 也是从 layer 中获取的）。



// 材质贴图
MTLBuffer
makeBuffer 申请内存空间

MTLTexture
真正的图像处理过程，用特定图片作为着色器的数据源，避免手动维护 colors 列表。UIImage —> MTLTexture —> sampler2D
步骤：
创建 texture：newTexture(with: image)
传递给片段着色器 commandEncoder.setFragmentTexture(texture, index: 0)
着色器根据着色器函数进行处理
