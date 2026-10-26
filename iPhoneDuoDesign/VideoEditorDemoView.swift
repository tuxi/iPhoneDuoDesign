//
//  VideoEditorDemoView.swift
//  iPhoneDuoDesign
//
//  Created by xiaoyuan on 2026/10/25.
//

import SwiftUI
import Combine
import Foundation

@available(iOS 27.1, *)
struct VideoEditorDemoView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @State private var clips = EditorClip.samples
    @State private var selectedClipID: String? = EditorClip.samples.first?.id
    @State private var currentTime: Double = 4
    @State private var isPlaying = false
    @State private var isInspectorPresented = false
    @State private var isAlertPresented = false
    @State private var alertMessage = ""
    @State private var undoSnapshot: EditorSnapshot?

    private let pixelsPerSecond: CGFloat = 16
    private let playbackTimer = Timer.publish(
        every: 0.05,
        on: .main,
        in: .common
    ).autoconnect()

    var body: some View {
        ZStack {
            Color(white: 0.06).ignoresSafeArea()

            GeometryReader { proxy in
                let activeFold = activeFold(in: proxy)
                let layoutFold = usableFold(activeFold, in: proxy)
                let pose = poseSummary(size: proxy.size, fold: activeFold)

                Group {
                    if let layoutFold {
                        foldLayout(fold: layoutFold, size: proxy.size, pose: pose)
                    } else {
                        stackedLayout(size: proxy.size, pose: pose)
                    }
                }
            }
        }
        .toolbar {
            toolbarContent
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Color(white: 0.06), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .tabBar)
        .toolbarBackground(Color(white: 0.06), for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .sheet(isPresented: $isInspectorPresented) {
            EditorInspectorView(
                clips: $clips,
                selectedClipID: selectedClipID
            )
            .presentationDetents([.medium, .large])
        }
        .alert("剪辑器", isPresented: $isAlertPresented) {
            Button("好", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
        .onReceive(playbackTimer) { _ in
            advancePlayback()
        }
        .onDisappear {
            isPlaying = false
        }
    }

    // MARK: - Fold-aware layout

    private func activeFold(in proxy: GeometryProxy) -> ReservedRegion? {
        proxy.reservedRegions(
            kind: .division,
            options: .includeInactive
        )
        .first { $0.isActive }
    }

    private func usableFold(
        _ fold: ReservedRegion?,
        in proxy: GeometryProxy
    ) -> ReservedRegion? {
        guard let fold, fold.isActive else { return nil }

        let frame = fold.frame
        if frame.height > frame.width {
            let leading = frame.minX
            let trailing = proxy.size.width - frame.maxX
            return leading >= 140 && trailing >= 140 ? fold : nil
        } else {
            let top = frame.minY
            let bottom = proxy.size.height - frame.maxY
            return top >= 140 && bottom >= 140 ? fold : nil
        }
    }

    private func stackedLayout(size: CGSize, pose: String) -> some View {
        let previewHeight = min(
            max(size.height * 0.55, 120),
            max(size.height - 100, 100)
        )

        return VStack(spacing: 0) {
            previewPane(pose: pose)
                .frame(height: max(previewHeight, 1))

            Rectangle()
                .fill(Color.white.opacity(0.12))
                .frame(height: 1)

            timelinePane
        }
    }

    private func foldLayout(
        fold: ReservedRegion,
        size: CGSize,
        pose: String
    ) -> some View {
        let frame = fold.frame
        let isVertical = frame.height > frame.width

        return Group {
            if isVertical {
                HStack(spacing: 0) {
                    previewPane(pose: pose)
                        .frame(width: max(frame.minX, 1))

                    foldGap(vertical: true, size: frame.size)

                    timelinePane
                        .frame(width: max(size.width - frame.maxX, 1))
                }
            } else {
                VStack(spacing: 0) {
                    previewPane(pose: pose)
                        .frame(height: max(frame.minY, 1))

                    foldGap(vertical: false, size: frame.size)

                    timelinePane
                        .frame(height: max(size.height - frame.maxY, 1))
                }
            }
        }
    }

    private func foldGap(vertical: Bool, size: CGSize) -> some View {
        Group {
            if vertical {
                ZStack {
                    Color.black
                    Rectangle()
                        .fill(Color.orange.opacity(0.9))
                        .frame(width: 1)
                }
                .frame(width: max(size.width, 1))
            } else {
                ZStack {
                    Color.black
                    Rectangle()
                        .fill(Color.orange.opacity(0.9))
                        .frame(height: 1)
                }
                .frame(height: max(size.height, 1))
            }
        }
        .allowsHitTesting(false)
    }

    private func poseSummary(
        size: CGSize,
        fold: ReservedRegion?
    ) -> String {
        let widthClass = horizontalSizeClass == .regular ? "regular" : "compact"
        let orientation = size.width >= size.height ? "landscape" : "portrait"
        let foldText: String

        if let fold {
            foldText = fold.frame.height > fold.frame.width
                ? "vertical fold"
                : "horizontal fold"
        } else {
            foldText = "no fold"
        }

        return "\(widthClass) · \(orientation)\n\(Int(size.width))×\(Int(size.height)) · \(foldText)"
    }

    // MARK: - Preview

    private func previewPane(pose: String) -> some View {
        GeometryReader { proxy in
            let padding: CGFloat = 14
            let infoHeight: CGFloat = 40
            let available = CGSize(
                width: max(proxy.size.width - padding * 2, 1),
                height: max(proxy.size.height - padding * 2 - infoHeight, 1)
            )
            let videoSize = fittedSize(aspect: 16 / 9, in: available)

            ZStack {
                Color.black

                VStack(spacing: 10) {
                    Spacer(minLength: 0)
                    videoCanvas(size: videoSize)
                    Spacer(minLength: 0)
                    previewInfo
                }
                .padding(padding)
            }
            .overlay(alignment: .topTrailing) {
                poseBadge(text: pose)
                    .padding(10)
            }
        }
        .background(Color.black)
    }

    private func videoCanvas(size: CGSize) -> some View {
        let color = currentClip?.color ?? .gray

        return ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [color.opacity(0.9), .black],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Image(systemName: "film")
                .font(.system(size: max(24, min(size.width, size.height) * 0.18)))
                .foregroundStyle(.white.opacity(0.7))

            VStack {
                Spacer(minLength: 0)
                HStack {
                    Text(currentClip?.title ?? "时间线为空")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    Spacer(minLength: 0)
                }
                .padding(12)
            }

            Button {
                togglePlayback()
            } label: {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 54, height: 54)
                    .background(.ultraThinMaterial, in: Circle())
            }
            .accessibilityLabel(isPlaying ? "暂停" : "播放")
        }
        .frame(width: max(size.width, 1), height: max(size.height, 1))
        .clipShape(.rect(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        }
    }

    private var previewInfo: some View {
        HStack(spacing: 10) {
            Text("\(editorTimecode(currentTime)) / \(editorTimecode(totalDuration))")
                .font(.caption.monospaced())
                .foregroundStyle(.white.opacity(0.85))

            Spacer(minLength: 8)

            Text(selectedClip?.title ?? "未选择片段")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.65))
                .lineLimit(1)
        }
    }

    private func poseBadge(text: String) -> some View {
        Text(text)
            .font(.caption2.monospaced())
            .foregroundStyle(.white)
            .multilineTextAlignment(.trailing)
            .lineLimit(2)
            .minimumScaleFactor(0.6)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.black.opacity(0.55), in: .capsule)
    }

    // MARK: - Timeline

    private var timelinePane: some View {
        GeometryReader { proxy in
            let isCompact = proxy.size.height < 200
            let isNarrow = proxy.size.width < 260
            let headerHeight: CGFloat = isCompact ? 22 : 30
            let transportHeight: CGFloat = isCompact ? 38 : 44
            let scrollHeight = max(
                min(isCompact ? 56 : 110, proxy.size.height - headerHeight - transportHeight - 2),
                24
            )

            VStack(spacing: 0) {
                timelineHeader(compact: isCompact || isNarrow)
                    .frame(height: headerHeight)

                Rectangle()
                    .fill(Color.white.opacity(0.10))
                    .frame(height: 1)

                timelineScroll(compact: isCompact, height: scrollHeight)

                Spacer(minLength: 0)

                Rectangle()
                    .fill(Color.white.opacity(0.10))
                    .frame(height: 1)

                transportBar(compact: isCompact || isNarrow)
                    .frame(height: transportHeight)
            }
        }
        .background(Color(white: 0.10))
    }

    private func timelineHeader(compact: Bool) -> some View {
        HStack(spacing: 8) {
            if !compact {
                Label("Duo Cut", systemImage: "film")
                    .font(.caption.bold())
            }

            Spacer(minLength: 8)

            if !compact, let selectedClip {
                Text(selectedClip.title)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.55))
                    .lineLimit(1)
            }

            Text("\(editorTimecode(currentTime)) / \(editorTimecode(totalDuration))")
                .font(.caption2.monospaced())
                .foregroundStyle(.white.opacity(0.8))
        }
        .foregroundStyle(.white.opacity(0.9))
        .padding(.horizontal, 12)
    }

    private func timelineScroll(compact: Bool, height: CGFloat) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ZStack(alignment: .topLeading) {
                if !compact {
                    ruler
                }

                clipsRow(compact: compact)
                playhead(contentHeight: height)
            }
            .frame(width: timelineWidth, height: height)
            .padding(.horizontal, 12)
        }
        .frame(height: height)
    }

    private var ruler: some View {
        ZStack(alignment: .topLeading) {
            ForEach(0...Int(totalDuration), id: \.self) { second in
                let x = CGFloat(second) * pixelsPerSecond

                Rectangle()
                    .fill(Color.white.opacity(second % 5 == 0 ? 0.5 : 0.2))
                    .frame(width: 1, height: second % 5 == 0 ? 12 : 6)
                    .position(x: x, y: 8)

                if second % 5 == 0 {
                    Text("\(second)s")
                        .font(.caption2.monospaced())
                        .foregroundStyle(.white.opacity(0.55))
                        .position(x: x + 10, y: 20)
                }
            }
        }
        .frame(width: timelineWidth, height: 26)
        .contentShape(Rectangle())
        .highPriorityGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    isPlaying = false
                    currentTime = min(
                        max(value.location.x / pixelsPerSecond, 0),
                        totalDuration
                    )
                }
        )
        .accessibilityLabel("时间线标尺，拖动定位播放头")
    }

    private func clipsRow(compact: Bool) -> some View {
        let top: CGFloat = compact ? 4 : 30
        let clipHeight: CGFloat = compact ? 44 : 64

        return ForEach(clipPlacements) { placement in
            let clip = placement.clip
            let width = max(CGFloat(clip.duration) * pixelsPerSecond - 2, 26)
            let centerX = CGFloat(placement.start) * pixelsPerSecond + width / 2

            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        colors: [clip.color, clip.color.opacity(0.55)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(clip.title)
                            .font(.caption.bold())
                            .lineLimit(1)

                        if width > 64 {
                            Text(editorTimecode(clip.duration))
                                .font(.caption2.monospaced())
                                .foregroundStyle(.white.opacity(0.7))
                        }
                    }
                    .foregroundStyle(.white)
                    .padding(6)
                }
                .overlay {
                    if clip.id == selectedClipID {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: 2)
                    }
                }
                .frame(width: width, height: clipHeight)
                .clipShape(.rect(cornerRadius: 8))
                .position(
                    x: centerX,
                    y: top + clipHeight / 2
                )
                .onTapGesture {
                    selectedClipID = clip.id
                }
        }
    }

    private func playhead(contentHeight: CGFloat) -> some View {
        let x = CGFloat(currentTime) * pixelsPerSecond

        return ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(Color.red)
                .frame(width: 2, height: contentHeight)
                .position(x: x, y: contentHeight / 2)

            Circle()
                .fill(Color.red)
                .frame(width: 8, height: 8)
                .position(x: x, y: 1)
        }
        .allowsHitTesting(false)
    }

    private func transportBar(compact: Bool) -> some View {
        HStack(spacing: compact ? 14 : 22) {
            Button {
                togglePlayback()
            } label: {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
            }
            .accessibilityLabel(isPlaying ? "暂停" : "播放")

            Button {
                splitSelectedClip()
            } label: {
                Image(systemName: "scissors")
            }
            .accessibilityLabel("分割")

            Button {
                addClip()
            } label: {
                Image(systemName: "plus")
            }
            .accessibilityLabel("添加片段")

            Spacer(minLength: 4)
        }
        .font(.title3)
        .foregroundStyle(.white)
        .padding(.horizontal, 14)
    }

    // MARK: - Actions

    private func togglePlayback() {
        if currentTime >= totalDuration {
            currentTime = 0
        }
        isPlaying.toggle()
    }

    private func advancePlayback() {
        guard isPlaying else { return }

        let next = currentTime + 0.05
        if next >= totalDuration {
            currentTime = totalDuration
            isPlaying = false
        } else {
            currentTime = next
        }
    }

    private func splitSelectedClip() {
        guard let index = clips.firstIndex(where: { $0.id == selectedClipID }) else {
            showAlert("先选中一个片段。")
            return
        }

        let clip = clips[index]
        let start = clips.prefix(index).reduce(0) { $0 + $1.duration }
        let localTime = currentTime - start

        guard localTime > 0.4, localTime < clip.duration - 0.4 else {
            showAlert("把播放头放到选中片段内部再分割。")
            return
        }

        snapshot()

        let left = EditorClip(
            title: "\(clip.title) A",
            duration: localTime,
            color: clip.color,
            speed: clip.speed,
            volume: clip.volume
        )
        let right = EditorClip(
            title: "\(clip.title) B",
            duration: clip.duration - localTime,
            color: clip.color,
            speed: clip.speed,
            volume: clip.volume
        )

        clips.replaceSubrange(index..<index + 1, with: [left, right])
        selectedClipID = right.id
    }

    private func addClip() {
        snapshot()

        let palette: [Color] = [.orange, .teal, .purple, .blue, .pink, .green]
        let clip = EditorClip(
            title: "新片段 \(clips.count + 1)",
            duration: 6,
            color: palette[clips.count % palette.count]
        )

        let start = totalDuration
        clips.append(clip)
        selectedClipID = clip.id
        currentTime = start
    }

    private func undo() {
        guard let snapshot = undoSnapshot else { return }

        clips = snapshot.clips
        selectedClipID = snapshot.selectedClipID
        currentTime = min(currentTime, totalDuration)
        undoSnapshot = nil
    }

    private func snapshot() {
        undoSnapshot = EditorSnapshot(
            clips: clips,
            selectedClipID: selectedClipID
        )
    }

    private func exportProject() {
        showAlert(
            "导出完成：\(clips.count) 个片段，总时长 \(editorTimecode(totalDuration))。"
        )
    }

    private func showAlert(_ message: String) {
        alertMessage = message
        isAlertPresented = true
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button {
                addClip()
            } label: {
                Label("导入", systemImage: "plus.rectangle.on.rectangle")
            }

            Button {
                undo()
            } label: {
                Label("撤销", systemImage: "arrow.uturn.backward")
            }
            .disabled(undoSnapshot == nil)

            Button {
                isInspectorPresented = true
            } label: {
                Label("检查器", systemImage: "slider.horizontal.3")
            }

            Button {
                exportProject()
            } label: {
                Label("导出", systemImage: "square.and.arrow.up")
            }
        }
    }

    // MARK: - Derived state

    private var totalDuration: Double {
        max(clips.reduce(0) { $0 + $1.duration }, 0.1)
    }

    private var timelineWidth: CGFloat {
        max(CGFloat(totalDuration) * pixelsPerSecond, 320)
    }

    private var currentClip: EditorClip? {
        var start = 0.0

        for clip in clips {
            if currentTime < start + clip.duration {
                return clip
            }
            start += clip.duration
        }

        return clips.last
    }

    private var selectedClip: EditorClip? {
        clips.first { $0.id == selectedClipID }
    }

    private var clipPlacements: [ClipPlacement] {
        var result: [ClipPlacement] = []
        var start = 0.0

        for clip in clips {
            result.append(ClipPlacement(clip: clip, start: start))
            start += clip.duration
        }

        return result
    }

    private func fittedSize(aspect: CGFloat, in container: CGSize) -> CGSize {
        guard container.width > 0, container.height > 0 else {
            return CGSize(width: 1, height: 1)
        }

        let width = min(container.width, container.height * aspect)
        return CGSize(width: max(width, 1), height: max(width / aspect, 1))
    }
}

// MARK: - Models

private struct EditorClip: Identifiable {
    let id: String
    var title: String
    var duration: Double
    var color: Color
    var speed: Double
    var volume: Double

    init(
        id: String = UUID().uuidString,
        title: String,
        duration: Double,
        color: Color,
        speed: Double = 1,
        volume: Double = 80
    ) {
        self.id = id
        self.title = title
        self.duration = duration
        self.color = color
        self.speed = speed
        self.volume = volume
    }

    static let samples: [EditorClip] = [
        EditorClip(id: "clip-1", title: "开场", duration: 8, color: .orange),
        EditorClip(id: "clip-2", title: "城市街道", duration: 12, color: .teal),
        EditorClip(id: "clip-3", title: "人物特写", duration: 6, color: .purple),
        EditorClip(id: "clip-4", title: "收尾", duration: 9, color: .blue)
    ]
}

private struct EditorSnapshot {
    let clips: [EditorClip]
    let selectedClipID: String?
}

private struct ClipPlacement: Identifiable {
    let clip: EditorClip
    let start: Double

    var id: String {
        clip.id
    }
}

private func editorTimecode(_ seconds: Double) -> String {
    let total = max(Int(seconds.rounded()), 0)
    return String(format: "%d:%02d", total / 60, total % 60)
}

// MARK: - Inspector

@available(iOS 27.1, *)
private struct EditorInspectorView: View {
    @Binding var clips: [EditorClip]
    let selectedClipID: String?

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                if let index = clips.firstIndex(where: { $0.id == selectedClipID }) {
                    Section("片段") {
                        LabeledContent("名称", value: clips[index].title)
                        LabeledContent("时长", value: editorTimecode(clips[index].duration))
                    }

                    Section("速度") {
                        Slider(
                            value: speedBinding(index: index),
                            in: 0.5...2,
                            step: 0.1
                        )

                        HStack {
                            Text("0.5x")
                            Spacer()
                            Text(String(format: "%.1fx", clips[index].speed))
                                .monospaced()
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }

                    Section("音量") {
                        Slider(
                            value: volumeBinding(index: index),
                            in: 0...100,
                            step: 1
                        )

                        HStack {
                            Text("0")
                            Spacer()
                            Text("\(Int(clips[index].volume))")
                                .monospaced()
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                } else {
                    Section("片段") {
                        Text("未选择片段。先回到时间线选择一个片段。")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("检查器")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func speedBinding(index: Int) -> Binding<Double> {
        Binding(
            get: { clips[index].speed },
            set: { clips[index].speed = $0 }
        )
    }

    private func volumeBinding(index: Int) -> Binding<Double> {
        Binding(
            get: { clips[index].volume },
            set: { clips[index].volume = $0 }
        )
    }
}

#Preview("Video Editor") {
    if #available(iOS 27.1, *) {
        NavigationStack {
            VideoEditorDemoView()
                .navigationTitle("剪辑器")
                .navigationBarTitleDisplayMode(.inline)
        }
    } else {
        Text("Video Editor 需要 iOS 27.1 或更高版本。")
    }
}
