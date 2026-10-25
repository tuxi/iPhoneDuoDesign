//
//  ArrangementDemoView.swift
//  iPhoneDuoDesign
//
//  Created by xiaoyuan on 2026/10/25.
//

import SwiftUI

struct ArrangementDemoView: View {
    @State private var selectedStyle: ArrangementDemoStyle = .split
    @State private var currentTrack = "iPhone Duo 设计原则"
    @State private var isPlaying = false

    private let tracks = [
        "iPhone Duo 设计原则",
        "Fold Avoidance",
        "Split View 多任务"
    ]

    var body: some View {
        if #available(iOS 27.1, *) {
            arrangementContent
        } else {
            ContentUnavailableView(
                "需要 iOS 27.1",
                systemImage: "rectangle.2.swap",
                description: Text("ArrangementView 从 iOS 27.1 开始提供。")
            )
        }
    }

    @available(iOS 27.1, *)
    private var arrangementContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            Picker("编排方式", selection: $selectedStyle) {
                Text("Split").tag(ArrangementDemoStyle.split)
                Text("Overlay").tag(ArrangementDemoStyle.overlay)
            }
            .pickerStyle(.segmented)
            .accessibilityLabel("Arrangement 编排方式")

            Text(selectedStyle.explanation)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            selectedArrangement
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(16)
    }

    @available(iOS 27.1, *)
    @ViewBuilder
    private var selectedArrangement: some View {
        switch selectedStyle {
        case .split:
            ArrangementSplitDemo(
                tracks: tracks,
                currentTrack: $currentTrack,
                isPlaying: $isPlaying
            )
        case .overlay:
            ArrangementOverlayDemo(
                tracks: tracks,
                currentTrack: $currentTrack,
                isPlaying: $isPlaying
            )
        }
    }
}

private enum ArrangementDemoStyle: Hashable {
    case split
    case overlay

    var explanation: String {
        switch self {
        case .split:
            "主内容和相关队列同时保持可见，适合主次内容关系。"
        case .overlay:
            "队列作为前景覆盖播放器；重叠时收起，分开时展开。"
        }
    }
}

@available(iOS 27.1, *)
private struct ArrangementSplitDemo: View {
    let tracks: [String]
    @Binding var currentTrack: String
    @Binding var isPlaying: Bool

    var body: some View {
        ArrangementView {
            NowPlayingPane(
                currentTrack: currentTrack,
                isPlaying: $isPlaying
            )
        } secondary: {
            UpNextPane(
                tracks: tracks,
                currentTrack: $currentTrack,
                isCollapsed: false
            )
        }
        .arrangementViewStyle(.split)
    }
}

@available(iOS 27.1, *)
private struct ArrangementOverlayDemo: View {
    let tracks: [String]
    @Binding var currentTrack: String
    @Binding var isPlaying: Bool

    var body: some View {
        ArrangementView {
            OverlayUpNextPane(
                tracks: tracks,
                currentTrack: $currentTrack
            )
        } secondary: {
            NowPlayingPane(
                currentTrack: currentTrack,
                isPlaying: $isPlaying
            )
        }
        .arrangementViewStyle(.overlay)
    }
}

@available(iOS 27.1, *)
private struct NowPlayingPane: View {
    let currentTrack: String
    @Binding var isPlaying: Bool

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "waveform")
                .font(.system(size: 48))
                .foregroundStyle(.tint)

            Text("正在播放")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(currentTrack)
                .font(.title2.bold())
                .multilineTextAlignment(.center)

            Button {
                isPlaying.toggle()
            } label: {
                Label(
                    isPlaying ? "暂停" : "播放",
                    systemImage: isPlaying ? "pause.fill" : "play.fill"
                )
            }
            .buttonStyle(.borderedProminent)

            Text("主视图：核心内容")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(24)
        .background(.blue.opacity(0.10))
    }
}

@available(iOS 27.1, *)
private struct OverlayUpNextPane: View {
    let tracks: [String]
    @Binding var currentTrack: String

    @Environment(\.overlayArrangementZIndex)
    private var zIndex

    var body: some View {
        UpNextPane(
            tracks: tracks,
            currentTrack: $currentTrack,
            isCollapsed: zIndex > 0,
            overlayZIndex: zIndex
        )
    }
}

@available(iOS 27.1, *)
private struct UpNextPane: View {
    let tracks: [String]
    @Binding var currentTrack: String
    let isCollapsed: Bool
    var overlayZIndex: Int? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Label("接下来播放", systemImage: "list.bullet")
                    .font(.headline)

                Spacer(minLength: 8)

                if isCollapsed {
                    Text("\(tracks.count) 项")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            if isCollapsed {
                Text("队列已收起，播放器仍在背景中。")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(tracks, id: \.self) { track in
                    Button {
                        currentTrack = track
                    } label: {
                        HStack {
                            Text(track)
                                .multilineTextAlignment(.leading)

                            Spacer(minLength: 8)

                            if currentTrack == track {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.tint)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(.background, in: .rect(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
                }
            }

            if let overlayZIndex {
                Text("overlay zIndex：\(overlayZIndex)")
                    .font(.caption.monospaced())
                    .foregroundStyle(.tertiary)
            }

            Spacer(minLength: 0)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: isCollapsed ? nil : .infinity,
            alignment: .topLeading
        )
        .padding(20)
        .background(
            isCollapsed ? AnyShapeStyle(.regularMaterial) : AnyShapeStyle(.orange.opacity(0.10)),
            in: .rect(cornerRadius: 20)
        )
    }
}

#Preview {
    ArrangementDemoView()
}
