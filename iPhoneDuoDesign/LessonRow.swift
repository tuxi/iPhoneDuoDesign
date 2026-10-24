//
//  LessonRow.swift
//  iPhoneDuoDesign
//
//  Created by xiaoyuan on 2026/10/24.
//

import SwiftUI

struct LessonRow: View {
    
    let lesson: Lesson
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: lesson.systemImage)
                .frame(width: 24)
                .foregroundStyle(.tint)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(lesson.title)
                    .font(.headline)
                Text(lesson.subtitle)
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(lesson.status.rawValue)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    LessonRow(
        lesson: testLesson
    )
    .padding(.horizontal, 15)
}

