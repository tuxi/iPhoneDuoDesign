//
//  LessonDemoView.swift
//  iPhoneDuoDesign
//
//  Created by xiaoyuan on 2026/10/24.
//

import SwiftUI

struct LessonDemoView: View {
    let lessonID: String

    @ViewBuilder
    var body: some View {
        switch lessonID {
        case "resizability":
            ResizabilityDemo()
        case "safe-area":
            SafeAreaDemo()
        default:
            Text("这个案例的可运行实验还在准备中。")
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.thinMaterial, in: .rect(cornerRadius: 16))
        }
    }
}

struct ResizabilityDemo: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            DemoSectionHeader(
                title: "可缩放实验",
                subtitle: "ViewThatFits 会根据容器空间选择合适的排列，不需要屏幕宽度断点。"
            )

            ViewThatFits(in: .horizontal) {
                HStack(spacing: 12) {
                    ResizabilityCard(title: "内容", value: "自然扩展", systemImage: "rectangle.expand.vertical")
                    ResizabilityCard(title: "布局", value: "横向排列", systemImage: "rectangle.split.2x1")
                    ResizabilityCard(title: "状态", value: "保持一致", systemImage: "arrow.triangle.2.circlepath")
                }

                VStack(spacing: 12) {
                    ResizabilityCard(title: "内容", value: "自然扩展", systemImage: "rectangle.expand.vertical")
                    ResizabilityCard(title: "布局", value: "纵向排列", systemImage: "rectangle.split.1x2")
                    ResizabilityCard(title: "状态", value: "保持一致", systemImage: "arrow.triangle.2.circlepath")
                }
            }

            HStack {
                Label("当前尺寸等级", systemImage: "ruler")
                Spacer()
                Text(horizontalSizeClass == .regular ? "regular" : "compact")
                    .font(.headline.monospaced())
                    .foregroundStyle(.tint)
            }
            .font(.subheadline)
        }
        .padding()
        .background(.blue.opacity(0.08), in: .rect(cornerRadius: 20))
    }
}

private struct ResizabilityCard: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: systemImage)
                .foregroundStyle(.tint)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.background, in: .rect(cornerRadius: 14))
    }
}

struct SafeAreaDemo: View {
    @State private var useSafeAreaInset = true

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            DemoSectionHeader(
                title: "安全区实验",
                subtitle: "背景可以延伸，但交互内容应该依赖安全区和容器边距。"
            )

            Toggle("使用 safeAreaInset 放置底部操作", isOn: $useSafeAreaInset)
                .font(.subheadline)

            Group {
                if useSafeAreaInset {
                    SafeAreaCanvas()
                        .safeAreaInset(edge: .bottom, spacing: 0) {
                            SafeAreaActionBar()
                        }
                } else {
                    SafeAreaCanvas()
                        .overlay(alignment: .bottom) {
                            SafeAreaActionBar()
                        }
                }
            }
            .frame(minHeight: 220)
            .clipShape(.rect(cornerRadius: 16))
        }
        .padding()
        .background(.orange.opacity(0.10), in: .rect(cornerRadius: 20))
    }
}

private struct SafeAreaCanvas: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                LinearGradient(
                    colors: [.orange.opacity(0.75), .pink.opacity(0.65)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                VStack(spacing: 8) {
                    Image(systemName: "rectangle.inset.filled")
                        .font(.largeTitle)
                    Text("背景区域")
                        .font(.headline)
                    Text("内容通过容器边距保持可读和可点击")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(.thinMaterial, in: .rect(cornerRadius: 16))
                .padding()
            }
            .overlay(alignment: .topLeading) {
                Text("容器：\(Int(proxy.size.width)) × \(Int(proxy.size.height))\n安全区：\(Int(proxy.safeAreaInsets.top)) / \(Int(proxy.safeAreaInsets.bottom))")
                    .font(.caption2.monospaced())
                    .padding(8)
                    .background(.black.opacity(0.35), in: .rect(cornerRadius: 8))
                    .foregroundStyle(.white)
                    .padding(10)
            }
        }
    }
}

private struct SafeAreaActionBar: View {
    var body: some View {
        Button("继续") {}
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(.bar)
    }
}

private struct DemoSectionHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview("Resizability") {
    ResizabilityDemo()
        .padding()
}

#Preview("Safe Area") {
    SafeAreaDemo()
        .padding()
}
