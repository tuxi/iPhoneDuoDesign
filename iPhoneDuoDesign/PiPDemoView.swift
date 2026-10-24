//
//  PiPDemoView.swift
//  iPhoneDuoDesign
//
//  Created by xiaoyuan on 2026/10/24.
//

import SwiftUI
import AVKit

struct PiPDemoView: View {
    private static let videoURL = URL(
        string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8"
    )!

    @State private var player = AVPlayer(url: videoURL)

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            DemoSectionHeader(
                title: "PiP 与空间变化",
                subtitle: "使用系统播放器开启画中画，观察应用可用空间如何改变。"
            )

            StandardVideoPlayer(player: player)
                .frame(height: 240)
                .clipShape(.rect(cornerRadius: 14))

            Label(
                "播放视频后，使用播放器里的 PiP 控件；再把 PiP 固定到顶部，观察下方内容。",
                systemImage: "rectangle.inset.filled"
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.purple.opacity(0.08), in: .rect(cornerRadius: 20))
    }
}

private struct StandardVideoPlayer: UIViewControllerRepresentable {
    let player: AVPlayer

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.allowsPictureInPicturePlayback = true
        controller.canStartPictureInPictureAutomaticallyFromInline = true
        return controller
    }

    func updateUIViewController(
        _ controller: AVPlayerViewController,
        context: Context
    ) {
        controller.player = player
    }
}

#Preview {
    PiPDemoView()
}
