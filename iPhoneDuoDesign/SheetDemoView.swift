//
//  SheetDemoView.swift
//  iPhoneDuoDesign
//
//  Created by xiaoyuan on 2026/10/24.
//

import SwiftUI

struct SheetDemoView: View {

    @State private var isShowingSheet = false

    @State private var note = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            DemoSectionHeader(
                title: "Sheet 实现",
                subtitle: "使用系统 Sheet 和 Toolbar，让系统根据不同空间自动适配。"
            )

            Text("当前笔记：\(note.isEmpty ? "暂无内容" : note)")
                .foregroundStyle(.secondary)

            Button {
                isShowingSheet = true
            } label: {
                Label("打开编辑 Sheet", systemImage: "square.and.pencil")
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.orange.opacity(0.1), in: .rect(cornerRadius: 20))
        .sheet(isPresented: $isShowingSheet) {
            NoteSheet(note: $note)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

private struct NoteSheet: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var note: String

    var body: some View {
        NavigationStack {
            Form {
                Section("指南笔记") {
                    TextEditor(text: $note)
                        .frame(minHeight: 180)
                }

                Section("学习提示") {
                    Label(
                        "Sheet 内容应该能够适应不同的可用空间。",
                        systemImage: "rectangle.resize"
                    )

                    Label(
                        "交互元素应该使用系统 Toolbar。",
                        systemImage: "checkmark.circle"
                    )
                }
            }
            .navigationTitle("编辑笔记")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Label("取消", systemImage: "xmark")
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Label("完成", systemImage: "checkmark")
                    }
                }
            }
        }
    }
}

#Preview {
    SheetDemoView()
        .padding()
}
