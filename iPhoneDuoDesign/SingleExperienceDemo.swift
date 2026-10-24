//
//  SingleExperienceDemo.swift
//  iPhoneDuoDesign
//
//  Created by xiaoyuan on 2026/10/24.
//

import SwiftUI

struct SingleExperienceDemo: View {
    @State private var selectedSection: DemoSection = .overview
    @State private var isPinned = false
    @State private var note = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            DemoSectionHeader(
                title: "状态连续性实验",
                subtitle: "尝试改变窗口宽度：布局会改变，但选择、开关和输入内容应该保持不变。"
            )

            ViewThatFits(in: .horizontal) {
                HStack(alignment: .top, spacing: 16) {
                    SingleExperienceSectionPicker(selection: $selectedSection)
                        .frame(maxWidth: 180)

                    Divider()

                    SingleExperienceContent(
                        section: selectedSection,
                        isPinned: $isPinned,
                        note: $note
                    )
                }

                VStack(alignment: .leading, spacing: 16) {
                    Picker("当前页面", selection: $selectedSection) {
                        ForEach(DemoSection.allCases) { section in
                            Text(section.title).tag(section)
                        }
                    }
                    .pickerStyle(.menu)

                    SingleExperienceContent(
                        section: selectedSection,
                        isPinned: $isPinned,
                        note: $note
                    )
                }
            }
            .frame(minHeight: 260, alignment: .top)

            HStack(spacing: 12) {
                Label("当前页面：\(selectedSection.title)", systemImage: "rectangle.on.rectangle")
                Spacer()
                Text("笔记 \(note.count) 字")
                    .foregroundStyle(.secondary)
            }
            .font(.caption)
        }
        .padding()
        .background(.green.opacity(0.09), in: .rect(cornerRadius: 20))
    }
}

enum DemoSection: String, CaseIterable, Identifiable {
    case overview
    case checklist
    case notes

    var id: String { rawValue }

    var title: String {
        switch self {
        case .overview:
            "概览"
        case .checklist:
            "检查清单"
        case .notes:
            "我的笔记"
        }
    }

    var systemImage: String {
        switch self {
        case .overview:
            "house"
        case .checklist:
            "checklist"
        case .notes:
            "note.text"
        }
    }
}

private struct SingleExperienceSectionPicker: View {
    @Binding var selection: DemoSection

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(DemoSection.allCases) { section in
                Button {
                    selection = section
                } label: {
                    Label(section.title, systemImage: section.systemImage)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.bordered)
                .tint(selection == section ? .accentColor : .secondary)
            }
        }
    }
}

private struct SingleExperienceContent: View {
    let section: DemoSection
    @Binding var isPinned: Bool
    @Binding var note: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label(section.title, systemImage: section.systemImage)
                .font(.title3.bold())

            switch section {
            case .overview:
                Text("这是同一份内容模型在不同可用空间下的两种呈现方式。布局可以重排，但用户不需要重新学习功能。")
                    .foregroundStyle(.secondary)
                Toggle("固定这个页面", isOn: $isPinned)

            case .checklist:
                Label("导航层级保持一致", systemImage: "checkmark.circle.fill")
                Label("操作状态保持一致", systemImage: "checkmark.circle.fill")
                Label("内容不会因为姿态改变而丢失", systemImage: "checkmark.circle.fill")

            case .notes:
                TextField("记录这次实验的观察", text: $note, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3...6)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.background, in: .rect(cornerRadius: 14))
    }
}

#Preview("Single Experience") {
    SingleExperienceDemo()
        .padding()
}
