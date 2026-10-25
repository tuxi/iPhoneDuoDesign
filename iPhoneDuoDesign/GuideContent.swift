//
//  GuideContent.swift
//  iPhoneDuoDesign
//
//  Created by xiaoyuan on 2026/10/24.
//

import SwiftUI

struct GuideEntry {
    let summary: String
    let points: [String]
}

extension Lesson {
    var guideEntry: GuideEntry {
        switch id {
        case "resizability":
            GuideEntry(
                summary: "把 App 设计成可以自由缩放的单一体验，而不是为每一种姿态准备一套完全不同的界面。",
                points: [
                    "使用 compact 和 regular 两种尺寸等级理解主要空间差异。",
                    "避免固定宽度、屏幕尺寸和姿态专属断点。",
                    "让布局根据容器提供的空间自然扩展或收缩。"
                ]
            )
        case "safe-area":
            GuideEntry(
                summary: "安全区和布局边距帮助内容避开侧边控件、摄像头和其他系统保留区域。",
                points: [
                    "交互元素必须保持可见、可读和可点击。",
                    "视觉背景可以延伸，但交互内容应该位于安全区域内。",
                    "使用容器尺寸和安全区，不要猜测具体设备尺寸。"
                ]
            )
        case "single-experience":
            GuideEntry(
                summary: "用户会在使用过程中打开、关闭或改变设备姿态，因此功能、层级和状态必须保持连续。",
                points: [
                    "不要把功能绑定到某个姿态。",
                    "布局可以变化，但用户不应该重新学习同一项功能。",
                    "导航、编辑状态和用户输入应该跨布局保持。"
                ]
            )
        case "vertical-controls":
            GuideEntry(
                summary: "工具栏、导航控件和 Tab Bar 应该使用系统语义，让系统在不同空间下管理它们的排列。",
                points: [
                    "使用系统 toolbar 和 ToolbarItemGroup。",
                    "为图标操作同时提供 Label 标题，便于 overflow 和辅助功能。",
                    "把高频操作和相关操作组织成清晰的组。"
                ]
            )
        case "inner-display":
            GuideEntry(
                summary: "内屏不应该只是被拉伸的外屏，可以利用额外宽度展示更多层级或重新排列内容。",
                points: [
                    "层级型内容适合使用 Split View。",
                    "可重排内容可以从单栏变成双栏。",
                    "信息密集型 App 可以考虑把 Tab Bar 展示为 Sidebar。"
                ]
            )
        case "split-view-multitasking":
            GuideEntry(
                summary: "Split View 是系统级多任务布局。App 不需要自己创建分屏，而要能适应系统分配的窗口空间。",
                points: [
                    "根据容器空间调整布局，不要假设 App 始终占满整个显示屏。",
                    "使用 size class、容器尺寸和安全区理解当前可用空间。",
                    "空间变化时，尽量保留用户输入和交互状态。",
                    "在 App 位于 Split View 左侧和右侧时都检查控件位置。"
                ]
            )
        case "adaptive-arrangements":
            GuideEntry(
                summary: "ArrangementView 是导航容器和内容容器之间的布局层，负责根据环境编排两个相关视图。",
                points: [
                    "主视图展示核心内容，次视图展示与它相关的内容。",
                    "split arrangement 适合两个视图都需要同时可见的主次关系。",
                    "不要把 ArrangementView 放进 ScrollView，也不要把导航容器塞进 ArrangementView。"
                ]
            )
        case "toolbar-overflow":
            GuideEntry(
                summary: "Toolbar 溢出由系统管理：为操作声明优先级，让系统决定谁留下、谁进入 overflow 菜单。",
                points: [
                    "用 ToolbarItemGroup 分组，系统先决定整组去留，再比较单项优先级。",
                    "用 visibilityPriority 标记高频操作；不要手动隐藏按钮或另建溢出菜单。",
                    "过宽控件用 axisBehavior(.horizontalOnly) 留在横向 bar，不强行放进纵向栏。",
                    "toolbarVerticalCompressionBehavior 决定空间不足时优先保留工具栏还是标签栏；它仅在根级标签栏与工具栏竞争时可见。"
                ]
            )
        case "multiple-scenes":
            GuideEntry(
                summary: "WindowGroup 声明可重复创建的窗口，Window 声明单实例窗口；Scene 是它们的一次具体实例。",
                points: [
                    "WindowGroup 适合便签这类可多开的窗口；Window 适合唯一的主界面。",
                    "每个 Scene 独立存活；关闭一个不会自动关闭其他 Scene。",
                    "系统会恢复最后一个存活的 Scene，不会自动重建已经关闭的主窗口。",
                    "用 openWindow(id:) 显式请求重新打开指定窗口。",
                    "打开新窗口前检查 supportsMultipleWindows。"
                ]
            )
        case "occlusion-region":
            GuideEntry(
                summary: "Occlusion 区域会覆盖部分内容，例如正在使用的内屏摄像头区域。",
                points: [
                    "用 reservedRegions(kind: .occlusion) 查询遮挡区域。",
                    "使用 includeInactive 同时观察未激活区域，提前了解它的位置。",
                    "region.frame 位于当前 GeometryProxy 的坐标空间。",
                    "只移动需要避开遮挡的重要内容，避免整个界面不必要地跳动。"
                ]
            )
        default:
            GuideEntry(
                summary: "继续使用系统组件和自适应容器，让 App 在不同尺寸和姿态下保持一致。",
                points: [
                    "优先使用系统提供的布局容器。",
                    "让交互元素保持可发现、可访问和可操作。",
                    "在 Device Hub 中验证不同姿态。"
                ]
            )
        }
    }
}

struct GuideSectionView: View {
    let entry: GuideEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("设计指南", systemImage: "book.pages")
                .font(.headline)

            Text(entry.summary)
                .font(.body)

            VStack(alignment: .leading, spacing: 10) {
                ForEach(entry.points, id: \.self) { point in
                    Label(point, systemImage: "checkmark.circle")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.tint.opacity(0.08), in: .rect(cornerRadius: 16))
    }
}
