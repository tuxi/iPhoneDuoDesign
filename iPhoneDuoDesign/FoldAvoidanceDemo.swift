//
//  FoldAvoidanceDemoView.swift
//  iPhoneDuoDesign
//
//  Created by xiaoyuan on 2026/10/24.
//

import SwiftUI

@available(iOS 27.1, *)
struct FoldAvoidanceDemoView: View {
    private let items = [
        "Resizability",
        "Safe Area",
        "Single Experience",
        "Vertical Controls"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            DemoSectionHeader(
                title: "折叠避让实验",
                subtitle: "自定义网格读取 division reserved region，并把交互内容放到折痕两侧。"
            )

            GeometryReader { proxy in
                let regions = proxy.reservedRegions(
                    kind: .division,
                    options: .includeInactive
                )

                let activeDivision = regions.first {
                    $0.isActive
                }

                ZStack(alignment: .topLeading) {
                    if let activeDivision {
                        ReservedRegionBackground(
                            divisionFrame: activeDivision.frame,
                            containerSize: proxy.size
                        )

                        FoldSeparatedLayout(
                            items: items,
                            divisionFrame: activeDivision.frame,
                            containerSize: proxy.size
                        )
                    } else {
                        GuideGrid(items: items)
                    }
                }
                .overlay(alignment: .topLeading) {
                    RegionDiagnostics(
                        regions: regions,
                        activeDivision: activeDivision?.frame
                    )
                }
            }
            .frame(minHeight: 300, maxHeight: 420)
            .clipShape(.rect(cornerRadius: 16))

            Label(
                "红色区域代表系统保留区域，交互内容不能跨越它。",
                systemImage: "rectangle.split.2x1"
            )
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(.red.opacity(0.08), in: .rect(cornerRadius: 20))
    }
}

@available(iOS 27.1, *)
private struct GuideGrid: View {
    let items: [String]

    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ],
            spacing: 12
        ) {
            ForEach(items, id: \.self) { item in
                GuideCard(title: item)
            }
        }
        .padding()
    }
}

@available(iOS 27.1, *)
private struct GuideCard: View {
    let title: String

    var body: some View {
        Button {
            print("Selected: \(title)")
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: "book.pages")
                    .foregroundStyle(.tint)

                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text("打开指南章节")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, minHeight: 90, alignment: .leading)
            .padding()
            .background(.background, in: .rect(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}

@available(iOS 27.1, *)
private struct FoldSeparatedLayout: View {
    let items: [String]
    let divisionFrame: CGRect
    let containerSize: CGSize

    var body: some View {
        let divisionRunsHorizontally = divisionFrame.width > divisionFrame.height

        let left = min(max(divisionFrame.minX, 0), containerSize.width)
        let right = min(max(divisionFrame.maxX, left), containerSize.width)
        let top = min(max(divisionFrame.minY, 0), containerSize.height)
        let bottom = min(max(divisionFrame.maxY, top), containerSize.height)

        Group {
            if divisionRunsHorizontally {
                // 横向折痕：内容分布在折痕上方和下方
                VStack(spacing: 0) {
                    GuidePane(items: Array(items.prefix(2)))
                        .frame(width: containerSize.width, height: top)
                        .clipped()

                    Color.clear
                        .frame(height: bottom - top)

                    GuidePane(items: Array(items.suffix(2)))
                        .frame(width: containerSize.width, height: containerSize.height - bottom)
                        .clipped()
                }
            } else {
                // 竖向折痕：内容分布在折痕左侧和右侧
                HStack(spacing: 0) {
                    GuidePane(items: Array(items.prefix(2)))
                        .frame(width: left, height: containerSize.height)
                        .clipped()

                    Color.clear
                        .frame(width: right - left)

                    GuidePane(items: Array(items.suffix(2)))
                        .frame(width: containerSize.width - right, height: containerSize.height)
                        .clipped()
                }
            }
        }
        .frame(
            width: containerSize.width,
            height: containerSize.height,
            alignment: .topLeading
        )
    }
}

@available(iOS 27.1, *)
private struct GuidePane: View {
    let items: [String]

    var body: some View {
        VStack(spacing: 12) {
            ForEach(items, id: \.self) { item in
                GuideCard(title: item)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

@available(iOS 27.1, *)
private struct ReservedRegionBackground: View {
    let divisionFrame: CGRect
    let containerSize: CGSize

    var body: some View {
        let divisionRunsHorizontally = divisionFrame.width > divisionFrame.height

        let left = min(max(divisionFrame.minX, 0), containerSize.width)
        let right = min(max(divisionFrame.maxX, left), containerSize.width)
        let top = min(max(divisionFrame.minY, 0), containerSize.height)
        let bottom = min(max(divisionFrame.maxY, top), containerSize.height)

        ZStack(alignment: .topLeading) {
            if divisionRunsHorizontally {
                VStack(spacing: 0) {
                    Color.blue.opacity(0.12)
                        .frame(height: top)

                    Color.red.opacity(0.55)
                        .frame(height: bottom - top)

                    Color.green.opacity(0.12)
                        .frame(height: containerSize.height - bottom)
                }
            } else {
                HStack(spacing: 0) {
                    Color.blue.opacity(0.12)
                        .frame(width: left)

                    Color.red.opacity(0.55)
                        .frame(width: right - left)

                    Color.green.opacity(0.12)
                        .frame(width: containerSize.width - right)
                }
            }
        }
        .frame(
            width: containerSize.width,
            height: containerSize.height,
            alignment: .topLeading
        )
    }
}

@available(iOS 27.1, *)
private struct RegionDiagnostics: View {
    let regions: [ReservedRegion]
    let activeDivision: CGRect?

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("division regions: \(regions.count)")
            if let activeDivision {
                Text("active: x \(Int(activeDivision.minX)), y \(Int(activeDivision.minY))")
                Text("size: \(Int(activeDivision.width)) × \(Int(activeDivision.height))")
            } else {
                Text("active division: none")
            }
        }
        .font(.caption2.monospaced())
        .padding(7)
        .foregroundStyle(.white)
        .background(.black.opacity(0.65), in: .rect(cornerRadius: 7))
        .padding(8)
        .allowsHitTesting(false)
    }
}

#Preview {
    if #available(iOS 27.1, *) {
        FoldAvoidanceDemoView()
    } else {
        Text("Hello Fold Avoidance")
    }
}
