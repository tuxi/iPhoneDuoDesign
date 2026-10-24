# 项目结构与学习方法

这个项目由两部分组成：

- `iPhoneDuoDesign/`：可运行的 SwiftUI 学习 App；
- `docs/`：设计原则、实验说明和参考资料。

## 为什么使用一个 Xcode Project

所有案例共用一个 App，方便在 Device Hub 中观察不同尺寸和姿态，也方便比较错误实现与推荐实现。每个案例最终都应该成为一个可以独立运行和验证的 Lesson，而不是只停留在文字说明中。

## 每个 Lesson 的完成标准

一个案例完成时，应当能够回答：

1. Apple 推荐的设计原则是什么？
2. 常见的错误实现是什么？
3. SwiftUI 中应该使用哪些系统容器或环境值？
4. 如何在外屏、内屏、横竖屏和半折状态下验证？

## 当前阶段

第一阶段先建立学习目录和文档索引。现在已经加入 `Resizability`、`Safe Area`、`Single Experience`、`Vertical Controls` 和 `Inner Display` 五个可运行实验，后续继续把指南中的设计原则逐步变成可验证的案例。
