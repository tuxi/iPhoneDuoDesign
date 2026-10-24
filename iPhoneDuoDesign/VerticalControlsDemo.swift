//
//  VerticalControlsDemo.swift
//  iPhoneDuoDesign
//
//  Created by xiaoyuan on 2026/10/24.
//

import SwiftUI

struct VerticalControlsDemo: View {
    @State private var isMarked = false
    @State private var isShared = false
    @State private var selectedFilter = "全部"

    private let filters = ["全部", "未完成", "已完成"]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            DemoSectionHeader(
                title: "语义化 Toolbar 实验",
                subtitle: "使用系统 toolbar、分组和 Label，让系统在不同尺寸下决定控件如何排列。"
            )

            NavigationStack {
                List {
                    Section("内容") {
                        Label("系统会根据可用空间排列控件", systemImage: "rectangle.3.group")
                        Label("图标和标题同时提供给系统", systemImage: "text.badge.checkmark")
                        Label("高频操作应该保持容易访问", systemImage: "hand.tap")
                    }

                    Section("当前状态") {
                        LabeledContent("筛选", value: selectedFilter)
                        LabeledContent("已标记", value: isMarked ? "是" : "否")
                        LabeledContent("分享", value: isShared ? "已触发" : "未触发")
                    }
                }
                .navigationTitle("Toolbar Lab")
                .toolbar {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        Button {
                            isMarked.toggle()
                        } label: {
                            Label("标记", systemImage: isMarked ? "star.fill" : "star")
                        }
                    }

                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button {
                            isShared = true
                        } label: {
                            Label("分享", systemImage: "square.and.arrow.up")
                        }

                        Menu {
                            Picker("筛选", selection: $selectedFilter) {
                                ForEach(filters, id: \.self) { filter in
                                    Text(filter).tag(filter)
                                }
                            }
                        } label: {
                            Label("筛选", systemImage: "line.3.horizontal.decrease.circle")
                        }
                    }

                    ToolbarItemGroup(placement: .bottomBar) {
                        Text("系统 Toolbar")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Button("完成") {}
                    }
                }
            }
            .frame(minHeight: 330)
            .clipShape(.rect(cornerRadius: 16))

            Label(
                "不要用自建 HStack 模拟系统 Toolbar；语义化的控件才能参与系统的布局、分组和 overflow。",
                systemImage: "lightbulb"
            )
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(.purple.opacity(0.09), in: .rect(cornerRadius: 20))
    }
}

#Preview("Vertical Controls") {
    VerticalControlsDemo()
        .padding()
}
