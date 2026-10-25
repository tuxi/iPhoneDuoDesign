//
//  MultiSceneDemoView.swift
//  iPhoneDuoDesign
//
//  Created by xiaoyuan on 2026/10/25.
//

import SwiftUI

enum AppWindowID {
    static let lessonNote = "lesson-note"
}

struct MultiSceneDemoView: View {
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.supportsMultipleWindows) private var supportsMultipleWindows
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            DemoSectionHeader(
                title: "多窗口与 Scene",
                subtitle: "每个 WindowGroup 实例都是同一 App 的一个独立窗口。"
            )
            
            Button {
                openWindow(id: AppWindowID.lessonNote)
            } label: {
                Label("打开学习便签窗口", systemImage: "macwindow.badge.plus")
            }
            .buttonStyle(.borderedProminent)
            .disabled(!supportsMultipleWindows)
            
            Label(
                supportsMultipleWindows
                ? "当前显示区域支持新建窗口。"
                : "当前显示区域不支持新建窗口；请在 iPhone Duo 内屏尝试。",
                systemImage: supportsMultipleWindows
                ? "checkmark.circle"
                : "info.circle"
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
            
            Text("打开两个便签窗口，在各自输入不同文字，观察窗口状态是否独立。")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.tint.opacity(0.08), in: .rect(cornerRadius: 20))
    }
}

struct LessonNoteWindowView: View {
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.supportsMultipleWindows) private var supportsMultipleWindows
    
    @State private var note = ""
    @State private var instanceID = UUID()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("当前窗口实例") {
                    Text("实例 ID: \(instanceID.uuidString.prefix(6))")
                    
                    TextEditor(text: $note)
                        .frame(minHeight: 140)
                }
                
                Section("继续试验") {
                    Button {
                        openWindow(id: AppWindowID.lessonNote)
                    } label: {
                        Label("再打开一个便签窗口", systemImage: "plus.square.on.square")
                    }
                    .disabled(!supportsMultipleWindows)
                    
                    Text("在新窗口输入另一段内容，比较两个窗口的独立状态。")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("学习便签")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MultiSceneDemoView()
}
