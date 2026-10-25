//
//  ToolbarCompressionDemo.swift
//  iPhoneDuoDesign
//
//  Created by xiaoyuan on 2026/10/25.
//

import SwiftUI

@available(iOS 27.1, *)
struct ToolbarCompressionDemo: View {

    @State private var preference: CompressionPreference = .automatic
    @State private var lastAction = "尚未触发"

    var body: some View {
        List {
            Section("压缩偏好") {
                Picker("优先保留", selection: $preference) {
                    ForEach(CompressionPreference.allCases) { option in
                        Text(option.title).tag(option)
                    }
                }
                .pickerStyle(.menu)

                Text(preference.explanation)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section("实验任务") {
                Label("点选不同策略，再观察工具栏和 Tab Bar。", systemImage: "hand.tap")
                Label("在 iPhone Duo 外屏横屏或内屏横屏测试。", systemImage: "iphone.gen3")
                Label("注意：Toolbar 内部项目的 overflow 和两种 bar 之间的压缩，是两层不同的行为。", systemImage: "arrow.down.to.line")
            }

            Section("最近操作") {
                Text(lastAction)
                    .foregroundStyle(.secondary)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                actionButton("新建", systemImage: "plus")
                actionButton("筛选", systemImage: "line.3.horizontal.decrease")
                actionButton("排序", systemImage: "arrow.up.arrow.down")
                actionButton("同步", systemImage: "arrow.clockwise")
            }
        }
        .toolbarVerticalCompressionBehavior(preference.behavior)
    }

    private func actionButton(
        _ title: String,
        systemImage: String
    ) -> some View {
        Button {
            lastAction = title
        } label: {
            Label(title, systemImage: systemImage)
        }
    }

    @available(iOS 27.1, *)
    private enum CompressionPreference: String, CaseIterable, Identifiable {
        case automatic
        case preferTabBar
        case preferToolbarItems

        var id: String {
            rawValue
        }

        var title: String {
            switch self {
            case .automatic:
                return "自动"
            case .preferTabBar:
                return "优先保留 Tab Bar"
            case .preferToolbarItems:
                return "优先保留工具栏"
            }
        }

        var explanation: String {
            switch self {
            case .automatic:
                "交给系统判断。默认更偏向保留导航目的地，因此工具栏先压缩。"
            case .preferTabBar:
                "尽量保留 Tab Bar；空间不足时优先压缩工具栏。"
            case .preferToolbarItems:
                "尽量保留工具栏操作；空间不足时优先压缩 Tab Bar。"
            }
        }

        var behavior: ToolbarVerticalCompressionBehavior {
            switch self {
            case .automatic:
                .automatic
            case .preferTabBar:
                .prefersTabBar
            case .preferToolbarItems:
                .prefersToolbarItems
            }
        }
    }
}

#Preview("Toolbar compression") {
    if #available(iOS 27.1, *) {
        NavigationStack {
            ToolbarCompressionDemo()
                .navigationTitle("Toolbar Compression")
                .navigationBarTitleDisplayMode(.inline)
        }
    } else {
        Text("Toolbar Overflow 需要 iOS 27.1 或更高版本。")
    }
}
