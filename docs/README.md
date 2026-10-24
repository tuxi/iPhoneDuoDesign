# iPhone Duo Design 学习路线

这里是项目的学习资料入口。根目录的 Xcode App 负责运行实验，`docs/` 负责解释设计原则、记录实验结论和维护官方参考资料。

## 学习顺序

1. [项目结构与学习方法](lessons/00-project-structure.md)
2. [Resizability：让布局自由缩放](lessons/01-resizability.md)
3. [Safe Area：让内容避开系统区域](lessons/02-safe-area.md)
4. 阅读根目录的[中文设计指南](../iPhone-Duo-设计指南.md)或[英文设计指南](../README.md)

后续案例会覆盖侧边控件、内屏双栏、Sheet、折叠避让和多任务。

## 文档与代码的关系

每个案例都应该同时具备：

- 设计原则：为什么这样设计；
- 错误示例：常见但不适合可折叠设备的实现；
- 推荐示例：使用系统容器、尺寸等级和安全区；
- 验证清单：在不同尺寸、方向和姿态下检查什么。

## 官方资料

- [Designing for iPhone Duo](https://developer.apple.com/design/human-interface-guidelines/designing-for-iphone-duo)
- [Preparing your app for iPhone Duo](https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo)
- [Design for iPhone Duo · Tech Talk 111466](https://developer.apple.com/videos/play/tech-talks/111466/)
