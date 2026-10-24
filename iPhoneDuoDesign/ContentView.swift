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
            .navigationTitle("iPhone Duo Guide")
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
            Label("iPhone Duo Guide", systemImage: "book.pages")
        } description: {
            Text("这份设计指南本身就是我们的示例 App，边阅读边观察它如何适配。")
        }
    }
}


#Preview {
    ContentView()
}
