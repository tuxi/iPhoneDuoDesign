//
//  OcclusionRegionDemoView.swift
//  iPhoneDuoDesign
//
//  Created by xiaoyuan on 2026/10/25.
//

import SwiftUI

@available(iOS 27.1, *)
struct OcclusionRegionDemoView: View {
    var body: some View {
        GeometryReader { proxy in
            let regions = proxy.reservedRegions(
                kind: .occlusion,
                options: .includeInactive
            )

            ZStack(alignment: .topLeading) {
                Color.blue.opacity(0.08)

                ForEach(regions.indices, id: \.self) { index in
                    regionShape(regions[index])
                }

                legend(proxy: proxy, regions: regions)
            }
        }
        .ignoresSafeArea(edges: .top)
    }

    private func regionShape(_ region: ReservedRegion) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(
                region.isActive
                ? Color.red.opacity(0.35)
                : Color.orange.opacity(0.12)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        region.isActive ? Color.red : Color.orange,
                        style: StrokeStyle(
                            lineWidth: 2,
                            dash: region.isActive ? [] : [6, 4]
                        )
                    )
            }
            .overlay {
                Text(region.isActive ? "active" : "inactive")
                    .font(.caption2.monospaced())
                    .padding(4)
                    .background(.background.opacity(0.85), in: .capsule)
            }
            .frame(
                width: max(region.frame.width, 1),
                height: max(region.frame.height, 1)
            )
            .position(
                x: region.frame.midX,
                y: region.frame.midY
            )
    }

    private func legend(
        proxy: GeometryProxy,
        regions: [ReservedRegion]
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("摄像头遮挡区域")
                .font(.headline)

            Text("红色 = 激活，橙色虚线 = 未激活。画布覆盖整屏，便于观察区域位置。")
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Text("occlusion regions: \(regions.count) · active: \(regions.filter(\.isActive).count)")
                .font(.caption2.monospaced())

            ForEach(regions.indices, id: \.self) { index in
                let frame = regions[index].frame
                Text("r\(index): \(Int(frame.minX)),\(Int(frame.minY)) · \(Int(frame.width))×\(Int(frame.height))")
                    .font(.caption2.monospaced())
            }

            Text("region.frame 位于当前 GeometryProxy 的坐标空间；不要写死摄像头位置或尺寸。")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .background(.regularMaterial, in: .rect(cornerRadius: 12))
        .padding(.leading, 16)
        .padding(.bottom, max(proxy.safeAreaInsets.bottom, 16))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
    }
}

#Preview("Occlusion Region") {
    if #available(iOS 27.1, *) {
        NavigationStack {
            OcclusionRegionDemoView()
                .navigationTitle("Occlusion Region")
                .navigationBarTitleDisplayMode(.inline)
        }
    } else {
        Text("Occlusion Region 需要 iOS 27.1 或更高版本。")
    }
}
