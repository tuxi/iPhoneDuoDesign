# iPhone Duo Design Lab

一个开源的 iPhone Duo 适配学习项目：用文档解释设计原则，用 SwiftUI App 把每条原则变成可以运行和验证的实验。

An open-source learning lab for adapting iOS apps to iPhone Duo: the docs explain the design principles, and the SwiftUI app turns each principle into a runnable experiment.

## 语言 / Languages

- [中文设计指南](iPhone-Duo-设计指南.md) — 完整中文版
- [English design guide](README.en.md) — full English guide
- [学习路线与文档入口](docs/README.md) — 课程顺序和每节文档

## 项目概览 / Project overview

这个仓库把 Apple 官方的 iPhone Duo 设计指导和可以运行的 SwiftUI 实验放在一起。App 本身也是一份示例：阅读器的导航、工具栏、标签栏和各个实验，都在实践正在讲解的原则。

The repository pairs Apple's official iPhone Duo guidance with runnable SwiftUI experiments. The app is itself a reference implementation: its navigation, bars, and labs follow the principles they teach.

**目录 / Contents**

| 路径 | 说明 |
|---|---|
| `iPhoneDuoDesign.xcodeproj` / `iPhoneDuoDesign/` | SwiftUI 学习 App：指南、压缩实验、剪辑器三个 Tab；覆盖尺寸等级、安全区、纵向控件、工具栏溢出与压缩、ArrangementView、多 Scene、Occlusion Region、折叠感知布局 |
| `iPhone-Duo-设计指南.md` | 中文完整指南 |
| `README.en.md` | English full guide |
| `docs/` | 课程文档、实验结论和验证清单 |
| `README.md` | 项目入口与语言导航（本文件） |

## 开始学习 / Get started

1. 先读[中文设计指南](iPhone-Duo-设计指南.md)或[英文指南](README.en.md)，了解 P0 / P1 / P2 优先级。
2. 打开 `iPhoneDuoDesign.xcodeproj`，运行 `iPhoneDuoDesign` scheme。
3. 在 Device Hub 中切换合盖、展开、横竖屏和半折叠姿态，对照 [`docs/lessons/`](docs/lessons/) 的验证清单观察 App。
4. 从 P0 开始修改实验，再进入 P1 / P2。

## 官方资料 / Official references

- HIG — [Designing for iPhone Duo](https://developer.apple.com/design/human-interface-guidelines/designing-for-iphone-duo)
- Developer Docs — [Preparing your app for iPhone Duo](https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo)
- Tech Talk — [Design for iPhone Duo · 111466](https://developer.apple.com/videos/play/tech-talks/111466/)

## 为什么分成三个文件 / Why three files

`README.md` 只做项目入口和语言导航；完整指南分别在 `iPhone-Duo-设计指南.md`（中文）和 `README.en.md`（English）。这样中英文不再混排，更新某一种语言时也不会影响另一种。
