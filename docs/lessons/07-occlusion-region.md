# Occlusion Region：让重要内容避开摄像头遮挡

## 核心原则

iPhone Duo 的两块屏幕各有一颗前置摄像头。外屏摄像头常驻可见；内屏摄像头藏在屏幕下，只在相机工作时出现。系统用 reserved region 描述这类会遮住内容的区域，类型是 `.occlusion`。

- 内屏摄像头区域只在相机激活时 `isActive == true`。
- 查询时加上 `.includeInactive`，可以提前拿到暂未激活区域的位置，避免区域激活时布局突然跳动。
- `region.frame` 位于当前 `GeometryProxy` 的坐标空间；它可能部分或全部落在容器之外，不要假设从 `(0, 0)` 开始。
- 不要写死摄像头的位置和尺寸；姿态、旋转和屏幕切换都会改变它。
- 只移动确实会被遮挡的控件，不要把整页内容一起挪开。

## 系统 API

```swift
GeometryReader { proxy in
    let regions = proxy.reservedRegions(
        kind: .occlusion,
        options: .includeInactive
    )

    ForEach(regions.indices, id: \.self) { index in
        let region = regions[index]
        // region.frame, region.isActive
    }
}
```

## 本项目中的实验

实验使用全屏画布，而不是内嵌卡片：

- 遮挡区域位于屏幕边缘；内嵌卡片的坐标空间在卡片内部，实测两块区域的 `y` 分别是 -64 和 -280，矩形会被完全裁掉。
- 全屏后两块区域都能落在画布内，`region.frame` 变成可直接绘制的正值。
- 红色表示激活区域，橙色虚线表示未激活区域。
- 左下角诊断卡显示区域数量、激活数量，以及每块区域的 frame。
- 画布只忽略顶部安全区，底部诊断卡仍留在安全区内，避免被标签栏遮挡。

这次不接入真实相机；摄像头激活前后 `isActive` 的变化，可以在相机 App 或接入 AVFoundation 后再观察。

## 验证清单

- 内屏展开时，`occlusion regions` 和 `active` 的数量是否随相机使用状态变化？
- 加上 `.includeInactive` 后，未激活区域的位置是否也能看到？
- 旋转、开合和切换内外屏后，`region.frame` 是否跟着变化，而不是固定值？
- 重要控件是否只做最小移动，而不是整页重排？
- 画布延伸区域内的诊断信息是否仍在安全区内、可读可点？
