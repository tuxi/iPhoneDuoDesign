//
//  SplitViewDemoView.swift
//  iPhoneDuoDesign
//
//  Created by xiaoyuan on 2026/10/24.
//

import SwiftUI

struct SplitViewDemoView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @State private var isTaskComplete = false
    @State private var containerWidth: CGFloat = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            DemoSectionHeader(
                title: "Split View 空间实验",
                subtitle: "同一份内容根据容器宽度切换单栏或双栏，任务状态保持不变。"
            )

            ViewThatFits(in: .horizontal) {
                HStack(alignment: .top, spacing: 12) {
                    readingCard
                    taskCard
                }

                VStack(spacing: 12) {
                    readingCard
                    taskCard
                }
            }

            HStack {
                Label("当前容器", systemImage: "ruler")
                Text(
                    "\(Int(containerWidth)) pt · " +
                    "\(horizontalSizeClass == .regular ? "regular" : "compact")"
                )
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            }
            .font(.caption.monospaced())
            .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.blue.opacity(0.08), in: .rect(cornerRadius: 20))
        .onGeometryChange(for: CGFloat.self) { proxy in
            proxy.size.width
        } action: { _, newWidth in
            containerWidth = newWidth
        }

    }

    private var readingCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("继续阅读", systemImage: "book")
                .font(.headline)

            Text("Split View 会改变 App 可用的宽度。布局应根据容器调整，而不是依赖固定屏幕尺寸。")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.background, in: .rect(cornerRadius: 14))
    }

    private var taskCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("学习任务", systemImage: "checklist")
                .font(.headline)

            HStack(spacing: 8) {
                Text("完成本节观察")
                    .fixedSize(horizontal: false, vertical: true)
                    .layoutPriority(1)

                Spacer(minLength: 4)

                Toggle("完成本节观察", isOn: $isTaskComplete)
                    .labelsHidden()
                    .accessibilityLabel("完成本节观察")
            }

            Text(isTaskComplete ? "状态已保存" : "试着缩放窗口，再确认状态")
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.background, in: .rect(cornerRadius: 14))
    }
}

#Preview {
    SplitViewDemoView()
        .padding()
}
