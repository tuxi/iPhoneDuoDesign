//
//  InnerDisplayDemo.swift
//  iPhoneDuoDesign
//
//  Created by xiaoyuan on 2026/10/24.
//

import SwiftUI

struct InnerDisplayDemo: View {
    @State private var selectedLessonID = "resizability"

    private let guideTopics = lessonGroups
        .flatMap(\.lessons)
        .filter { ["resizability", "safe-area", "single-experience", "vertical-controls"].contains($0.id) }

    private var selectedLesson: Lesson {
        guideTopics.first(where: { $0.id == selectedLessonID }) ?? guideTopics[0]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            DemoSectionHeader(
                title: "内屏双栏阅读器",
                subtitle: "宽空间同时显示章节和内容，窄空间仍然保留同一套导航层级。"
            )

            NavigationSplitView {
                List {
                    Section("Design Guide") {
                        ForEach(guideTopics) { lesson in
                            Button {
                                selectedLessonID = lesson.id
                            } label: {
                                Label(lesson.title, systemImage: lesson.systemImage)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .buttonStyle(.plain)
                            .listRowBackground(
                                selectedLessonID == lesson.id
                                    ? Color.accentColor.opacity(0.15)
                                    : Color.clear
                            )
                        }
                    }
                }
                .navigationTitle("章节")
            } detail: {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Label(selectedLesson.title, systemImage: selectedLesson.systemImage)
                            .font(.title2.bold())
                        Text(selectedLesson.subtitle)
                            .foregroundStyle(.secondary)
                        GuideSectionView(entry: selectedLesson.guideEntry)
                    }
                    .frame(maxWidth: 520, alignment: .leading)
                    .padding()
                }
                .navigationTitle("指南内容")
            }
            .navigationSplitViewStyle(.balanced)
            .frame(minHeight: 360)
            .clipShape(.rect(cornerRadius: 16))

            Label(
                "内屏不是拉伸后的外屏：额外宽度应该用来展示更多层级。",
                systemImage: "rectangle.split.2x1"
            )
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(.blue.opacity(0.09), in: .rect(cornerRadius: 20))
    }
}

#Preview("Inner Display") {
    InnerDisplayDemo()
        .padding()
}
