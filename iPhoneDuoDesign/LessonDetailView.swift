//
//  LessonDetailView.swift
//  iPhoneDuoDesign
//
//  Created by xiaoyuan on 2026/10/24.
//

import SwiftUI

struct LessonDetailView: View {
    
    let lesson: Lesson
    
    var body: some View {
        Group {
            if lesson.id == "adaptive-arrangements" {
                ArrangementDemoView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if lesson.id == "toolbar-overflow" {
                if #available(iOS 27.1, *) {
                    ToolbarOverflowDemo()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ContentUnavailableView(
                        "需要 iOS 27.1",
                        systemImage: "ellipsis.circle",
                        description: Text("Toolbar Overflow 从 iOS 27.1 开始提供。")
                    )
                }
            } else if lesson.id == "occlusion-region" {
                if #available(iOS 27.1, *) {
                    OcclusionRegionDemoView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ContentUnavailableView(
                        "需要 iOS 27.1",
                        systemImage: "camera",
                        description: Text("Occlusion Region 从 iOS 27.1 开始提供。")
                    )
                }
            } else {
                standardContent
            }
        }
        .navigationTitle(lesson.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var standardContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Label(lesson.title, systemImage: lesson.systemImage)
                    .font(.largeTitle.bold())
                    .foregroundStyle(.tint)
                
                Text(lesson.subtitle)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                
                GuideSectionView(entry: lesson.guideEntry)
                DemoPlaceholder(title: "设计原则", text: lesson.principle)
                DemoPlaceholder(title: "动手实验", text: lesson.experiment)

                LessonDemoView(lessonID: lesson.id)

                VStack(alignment: .leading, spacing: 8) {
                    Text("学习状态")
                        .font(.headline)
                    Label(lesson.status.rawValue, systemImage: "checkmark.circle")
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: 760, alignment: .leading)
            .padding(24)
        }
    }
}

private struct DemoPlaceholder: View {
    let title: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(text)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial, in: .rect(cornerRadius: 16))
    }
}


#Preview {
    LessonDetailView(lesson: testLesson)
}
