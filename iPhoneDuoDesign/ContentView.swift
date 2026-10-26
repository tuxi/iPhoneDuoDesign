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
        TabView {
            Tab("指南", systemImage: "book.pages") {
                guideNavigation
            }

            Tab("压缩实验", systemImage: "arrow.up.and.down.text.horizontal") {
                ToolbarCompressionTab()
            }

            Tab("剪辑器", systemImage: "film") {
                VideoEditorTab()
            }
        }
    }

    private var guideNavigation: some View {
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

    private struct ToolbarCompressionTab: View {
        var body: some View {
            NavigationStack {
                Group {
                    if #available(iOS 27.1, *) {
                        ToolbarCompressionDemo()
                    } else {
                        ContentUnavailableView(
                            "需要 iOS 27.1",
                            systemImage: "arrow.up.and.down.text.horizontal",
                            description: Text("Toolbar 压缩实验需要 iOS 27.1 或更高版本。")
                        )
                    }
                }
                .navigationTitle("Bar 压缩")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }

    private struct VideoEditorTab: View {
        var body: some View {
            NavigationStack {
                Group {
                    if #available(iOS 27.1, *) {
                        VideoEditorDemoView()
                    } else {
                        ContentUnavailableView(
                            "需要 iOS 27.1",
                            systemImage: "film",
                            description: Text("剪辑器实验需要 iOS 27.1 或更高版本。")
                        )
                    }
                }
                .navigationTitle("剪辑器")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
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
