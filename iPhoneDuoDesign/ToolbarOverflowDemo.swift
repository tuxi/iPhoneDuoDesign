//
//  ToolbarOverflowDemo.swift
//  iPhoneDuoDesign
//
//  Created by xiaoyuan on 2026/10/25.
//

import SwiftUI

@available(iOS 27.1, *)
struct ToolbarOverflowDemo: View {
    @State private var prioritizeFrequentActions = true
    @State private var lastAction = "尚未触发"
    @State private var actionCount = 0

    var body: some View {
        List {
            Section("设计原则") {
                Text("纵向栏空间不足时，让系统按优先级收起操作。系统先比较 ToolbarItemGroup，再比较组内单项。")
                    .foregroundStyle(.secondary)

                Label("高频操作标 high，次要操作标 low。", systemImage: "arrow.up.circle")
                Label("必须进入 overflow 的操作放进 ToolbarOverflowMenu。", systemImage: "ellipsis.circle")
                Label("纵向栏在哪一侧由系统决定，与摄像头对齐；不要写死左右。", systemImage: "camera")
                Label("工具栏必须挂在真正的导航容器上，才能参与纵向栏编排。", systemImage: "navigation")
            }

            Section("实验控制") {
                Toggle("优先保留高频操作", isOn: $prioritizeFrequentActions)

                HStack {
                    Label("最近操作", systemImage: "hand.tap")
                        .layoutPriority(1)
                    Spacer(minLength: 8)
                    Text(lastAction)
                        .font(.subheadline.monospaced())
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    Text("\(actionCount) 次")
                        .font(.caption.monospaced())
                        .foregroundStyle(.tertiary)
                        .lineLimit(1)
                }
            }

            Section("当前配置") {
                LabeledContent(
                    "优先级",
                    value: prioritizeFrequentActions ? "高频操作优先" : "全部 automatic"
                )
            }

            Section("观察") {
                Label("合上盖子：工具栏进入侧边纵向栏。", systemImage: "iphone")
                Label("外屏横屏时纵向空间更少，工具栏更容易溢出。", systemImage: "arrow.down.to.line")
                Label("键盘或 PiP 出现时，也可能挤压工具栏的可用空间。", systemImage: "rectangle.topthird.inset.filled")
                Label("内屏横屏仍有纵向栏，空间更多。", systemImage: "rectangle.split.2x1")
                Label("内屏竖屏保留横向 bar，优先级差异不明显。", systemImage: "rectangle.portrait")
                Label("筛选是 horizontalOnly：没有横向 bar 时可能不显示，而不是进入 overflow。", systemImage: "arrow.left.and.right")
            }

            Section("关于压缩") {
                Text("本页主要演示工具栏项目如何进入 overflow。项目现在有根级 TabView；要比较 ToolbarVerticalCompressionBehavior 的 automatic、prefersTabBar 和 prefersToolbarItems，请切换到“压缩实验”标签页。")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .toolbar {
            toolbarContent
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        if prioritizeFrequentActions {
            prioritizedToolbar
        } else {
            defaultToolbar
        }
    }

    @ToolbarContentBuilder
    private var prioritizedToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            actionButton("收藏", systemImage: "star", recordAs: "收藏")
            actionButton("标记", systemImage: "flag", recordAs: "标记")
        }
        .visibilityPriority(.high)

        ToolbarItemGroup(placement: .topBarTrailing) {
            actionButton("分享", systemImage: "square.and.arrow.up", recordAs: "分享")
            actionButton("复制", systemImage: "doc.on.doc", recordAs: "复制")
            actionButton("导出", systemImage: "arrow.up.doc", recordAs: "导出")
        }

        ToolbarItem(placement: .topBarTrailing) {
            actionButton("刷新", systemImage: "arrow.clockwise", recordAs: "刷新")
        }
        .visibilityPriority(.low)

        ToolbarItem(placement: .topBarTrailing) {
            actionButton("删除", systemImage: "trash", recordAs: "删除")
        }
        .visibilityPriority(.low)

        ToolbarItem(placement: .topBarTrailing) {
            wideFilterMenu
        }
        .axisBehavior(.horizontalOnly)

        ToolbarOverflowMenu {
            Button {
                record("重命名")
            } label: {
                Label("重命名", systemImage: "pencil")
            }

            Button {
                record("移至文件夹")
            } label: {
                Label("移至文件夹", systemImage: "folder")
            }
        }
    }

    @ToolbarContentBuilder
    private var defaultToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            actionButton("收藏", systemImage: "star", recordAs: "收藏")
            actionButton("标记", systemImage: "flag", recordAs: "标记")
        }

        ToolbarItemGroup(placement: .topBarTrailing) {
            actionButton("分享", systemImage: "square.and.arrow.up", recordAs: "分享")
            actionButton("复制", systemImage: "doc.on.doc", recordAs: "复制")
            actionButton("导出", systemImage: "arrow.up.doc", recordAs: "导出")
        }

        ToolbarItem(placement: .topBarTrailing) {
            actionButton("刷新", systemImage: "arrow.clockwise", recordAs: "刷新")
        }

        ToolbarItem(placement: .topBarTrailing) {
            actionButton("删除", systemImage: "trash", recordAs: "删除")
        }

        ToolbarItem(placement: .topBarTrailing) {
            wideFilterMenu
        }
        .axisBehavior(.horizontalOnly)

        ToolbarOverflowMenu {
            Button {
                record("重命名")
            } label: {
                Label("重命名", systemImage: "pencil")
            }

            Button {
                record("移至文件夹")
            } label: {
                Label("移至文件夹", systemImage: "folder")
            }
        }
    }

    private var wideFilterMenu: some View {
        Menu {
            Button("按名称") { record("筛选：名称") }
            Button("按进度") { record("筛选：进度") }
        } label: {
            Label("筛选", systemImage: "line.3.horizontal.decrease.circle")
        }
    }

    private func actionButton(
        _ title: String,
        systemImage: String,
        recordAs action: String
    ) -> some View {
        Button {
            record(action)
        } label: {
            Label(title, systemImage: systemImage)
        }
    }

    private func record(_ action: String) {
        lastAction = action
        actionCount += 1
    }
}

#Preview("Toolbar Overflow") {
    if #available(iOS 27.1, *) {
        NavigationStack {
            ToolbarOverflowDemo()
                .navigationTitle("Toolbar Overflow")
                .navigationBarTitleDisplayMode(.inline)
        }
    } else {
        Text("Toolbar Overflow 需要 iOS 27.1 或更高版本。")
    }
}
