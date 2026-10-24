//
//  ContentView.swift
//  iPhoneDuoDesign
//
//  Created by xiaoyuan on 2026/10/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedLesson: Lesson?

    var body: some View {
        NavigationSplitView {
            List(lessonGroups) { group in
                Section(group.title) {
                    ForEach(group.lessons) { lesson in
                        NavigationLink(value: lesson) {
                            LessonRow(lesson: lesson)
                        }
                    }
                }
            }
            .navigationTitle("Duo Design Lab")
            .navigationDestination(for: Lesson.self) { lesson in
                LessonDetailView(lesson: lesson)
            }
        } detail: {
            if let selectedLesson {
                LessonDetailView(lesson: selectedLesson)
            } else {
                WelcomeView()
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}

private struct WelcomeView: View {
    var body: some View {
        ContentUnavailableView {
            Label("Duo Design Lab", systemImage: "rectangle.2.swap")
        } description: {
            Text("从左侧选择一个学习案例，边阅读边运行示例。")
        }
    }
}


#Preview {
    ContentView()
}
