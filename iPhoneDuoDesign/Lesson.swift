//
//  Lesson.swift
//  iPhoneDuoDesign
//
//  Created by xiaoyuan on 2026/10/24.
//

import Foundation

struct Lesson: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let systemImage: String
    let status: Status
    let principle: String
    let experiment: String
    
    enum Status: String, Hashable {
        case start = "开始"
        case next = "下一步"
        case later = "稍后"
    }
}

struct LessonGroup: Identifiable {
    let id: String
    let title: String
    let lessons: [Lesson]
}



let testLesson = Lesson(
    id: "-",
    title: "iPhone Duo",
    subtitle: "Design for iPhone Duo",
    systemImage: "rectangle.stack",
    status: .later,
    principle: "Sheet 和画中画会改变可用空间，界面需要在变化过程中保持可用。",
    experiment: "检查 Sheet、Split View 和 PiP 下的内容缩放与控件位置。"
)



let lessonGroups: [LessonGroup] = [
    LessonGroup(
        id: "p0",
        title: "P0 · 基础适配",
        lessons: [
            Lesson(
                id: "resizability",
                title: "Resizability",
                subtitle: "让布局自由缩放",
                systemImage: "arrow.up.left.and.arrow.down.right",
                status: .start,
                principle: "不要依赖固定屏幕宽度或姿态断点，让布局根据可用空间自然变化。",
                experiment: "拖动窗口或使用 Device Hub，观察同一套界面如何适应不同宽高比。"
            ),
            Lesson(
                id: "safe-area",
                title: "Safe Area",
                subtitle: "让内容避开系统区域",
                systemImage: "rectangle.inset.filled",
                status: .next,
                principle: "使用安全区和布局边距，让内容自动为侧边控件、摄像头和折叠区域让位。",
                experiment: "对比使用安全区与忽略安全区的布局，确认交互元素始终可见、可点击。"
            ),
            Lesson(
                id: "single-experience",
                title: "Single Experience",
                subtitle: "保持内外屏功能一致",
                systemImage: "rectangle.2.swap",
                status: .next,
                principle: "设备开合时，功能、层级和状态应该保持一致，而不是切换成两套互不相同的 App。",
                experiment: "在外屏和内屏之间切换，确认当前导航和编辑状态可以自然延续。"
            )
        ]
    ),
    LessonGroup(
        id: "p1",
        title: "P1 · 体验增强",
        lessons: [
            Lesson(
                id: "inner-display",
                title: "Inner Display",
                subtitle: "用双栏呈现更多层级",
                systemImage: "rectangle.split.2x1",
                status: .later,
                principle: "内屏不应该只是拉伸后的外屏，可以使用 Split View 或双栏布局展示更多内容。",
                experiment: "比较单栏、双栏和 NavigationSplitView 在不同可用宽度下的行为。"
            ),
            Lesson(
                id: "vertical-controls",
                title: "Vertical Controls",
                subtitle: "让系统管理侧边控件",
                systemImage: "sidebar.right",
                status: .later,
                principle: "优先使用系统导航容器和 toolbar，让系统负责侧边布局、分组和 overflow。",
                experiment: "逐渐增加 toolbar actions，观察空间不足时系统如何处理溢出。"
            )
        ]
    ),
    LessonGroup(
        id: "p2",
        title: "P2 · 深入探索",
        lessons: [
            Lesson(
                id: "fold-avoidance",
                title: "Fold Avoidance",
                subtitle: "让交互元素避开折痕",
                systemImage: "rectangle.split.2x1.fill",
                status: .later,
                principle: "滚动内容可以经过中央区域，但按钮等交互元素需要避开折痕。",
                experiment: "分别观察系统组件和自定义布局在半折状态下的差异。"
            ),
            Lesson(
                id: "sheets-and-pip",
                title: "Sheets & PiP",
                subtitle: "验证动态尺寸变化",
                systemImage: "rectangle.stack",
                status: .later,
                principle: "Sheet 和画中画会改变可用空间，界面需要在变化过程中保持可用。",
                experiment: "检查 Sheet、Split View 和 PiP 下的内容缩放与控件位置。"
            )
        ]
    )
]
