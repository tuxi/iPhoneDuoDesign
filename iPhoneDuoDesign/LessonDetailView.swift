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
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Label(lesson.title, systemImage: lesson.systemImage)
                    .font(.largeTitle.bold())
                    .foregroundStyle(.tint)
                
                Text(lesson.subtitle)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                
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
        .navigationTitle(lesson.title)
        .navigationBarTitleDisplayMode(.inline)
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
