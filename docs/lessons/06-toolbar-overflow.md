# Toolbar Overflow & Compression：让系统收起次要操作

## 核心原则

iPhone Duo 的纵向栏同时承载状态栏、工具栏和标签栏，可用高度比横向 bar 更紧张。空间不足时，不要自己删按钮或再做一个“更多”菜单；给系统语义化的分组和优先级，让它在任何姿态下按同一套规则收起操作。

## 溢出顺序

- 系统先比较 `ToolbarItemGroup`，再比较组内单项。
- 默认从底部向上溢出；优先级高的操作留得更久。
- `ToolbarItemVisibilityPriority` 提供 `.high`、`.low`、`.automatic`，也可以用 `init(lowerThan:)` / `init(higherThan:)` 建立相对顺序。
- 一定要进入 overflow 的操作，放进 `ToolbarOverflowMenu`，不要占用可见栏位。

## 压缩行为

纵向空间不足时，工具栏和标签栏会互相竞争。`ToolbarVerticalCompressionBehavior` 决定谁先让步：

| 取值 | 行为 |
|---|---|
| `.automatic` | 交给系统按当前上下文决定 |
| `.prefersTabBar` | 保留标签栏与主要目的地，压缩工具栏（导航型） |
| `.prefersToolbarItems` | 保留任务核心操作，最小化标签栏（任务型） |

## 横向例外

文字按钮、分段控件等过宽控件放不进纵向栏，应留在横向 bar。需要显式表达时使用 `.axisBehavior(.horizontalOnly)`；相反，`.verticalPreferred` 可以让图标操作优先进入纵向布局。

## 本项目中的实验

项目使用根级 `TabView` 承载“指南”和“压缩实验”两个标签。Overflow 实验的工具栏挂在指南标签中的导航容器上；压缩实验则在另一个根级 Tab 中比较 Tab Bar 与 toolbar。不要把 `TabView`、`NavigationStack` 放进 `ScrollView` 或固定高度的卡片里：系统不会把内嵌视图当作真正的 bar，工具栏不会纵向化，标签栏也可能落到安全区外。

实验使用：

- 8 个带 `Label` 的操作，分成 leading、trailing 和单项；
- “收藏 / 标记”标为 `.high`，“刷新 / 删除”标为 `.low`；
- “重命名 / 移至文件夹”放进 `ToolbarOverflowMenu`；
- “筛选”菜单使用 `.axisBehavior(.horizontalOnly)`；
- 一个开关对比“有优先级”和“全部 automatic”。

在 iPhone Duo 外屏横屏观察溢出顺序，再切到内屏横屏和竖屏对比。外屏横屏的纵向空间更少，因此更容易触发 overflow；键盘或 PiP 等系统界面出现时，也可能进一步压缩工具栏空间。普通 iPhone 只有横向 bar，看不出纵向溢出优先级的差异。

“筛选”被标记为 `.horizontalOnly`，它表达的是轴向限制，不是低优先级：如果当前上下文没有横向 bar，它可能不显示，而不是移入 overflow。观察时要把这种情况与普通工具项溢出区分开。

## Toolbar 与 Tab Bar 的压缩实验

切换 App 的“压缩实验”标签页，对比 `.automatic`、`.prefersTabBar` 和 `.prefersToolbarItems`。只有当**根级 Tab Bar**和导航工具栏在纵向栏中共同竞争空间时，这些偏好才会显现；这控制的是两种 bar 之间谁先压缩，不是工具栏内部哪些按钮进入 overflow。

## 为什么必须由导航容器承载

Apple 的工程文档明确要求：如果 bar 没有纵向展示，先检查是否使用了 tab view、navigation stack 这类导航容器提供的 bar support。bar 的纵向布局和安全区处理都建立在这个前提上。

把 `TabView` 塞进 `ScrollView` 或固定高度的卡片后：

- 标签栏会被当作窗口底部的浮层，可能压到安全区外；
- 内层 `NavigationStack` 的 toolbar 不再参与系统纵向栏的编排，合盖时仍留在横向位置。

纵向栏在哪一侧也由系统决定，与外侧摄像头对齐。不要写死 left / right，也不要用固定宽度模拟侧栏。

## 验证清单

- 合上盖子后，工具栏是否进入侧边纵向栏？
- 控件是否与摄像头同侧，而不是固定在某一边？
- 外屏横屏纵向栏空间收紧时，low 优先级操作是否先进入 overflow？
- 键盘或 PiP 出现时，是否会因为可用空间减少而触发更多 overflow？
- 关闭优先级后，溢出顺序是否回到默认的自下而上？
- `ToolbarOverflowMenu` 中的操作是否不占用可见栏位？
- “筛选”的 `.horizontalOnly` 轴向限制是否生效？当前没有横向 bar 时，它是否与 overflow 项目区分开？
- 每次收起或展开后，已触发操作的状态是否保持一致？
