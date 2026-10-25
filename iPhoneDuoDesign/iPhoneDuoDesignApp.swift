//
//  iPhoneDuoDesignApp.swift
//  iPhoneDuoDesign
//
//  Created by xiaoyuan on 2026/10/24.
//

import SwiftUI

@main
struct iPhoneDuoDesignApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        WindowGroup(id: AppWindowID.lessonNote) {
            LessonNoteWindowView()
        }
    }
}
