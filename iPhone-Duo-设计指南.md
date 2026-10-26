# iPhone Duo 设计指南（中文）

> English version: [README.en.md](./README.en.md) · 项目入口: [README.md](./README.md)

> 面向 iOS 开发者与设计师的中文适配指南，内容基于 Apple 官方资料整理：
>
> - **Apple HIG《Designing for iPhone Duo》**（**主要参考，内容最完整的官方设计指南**）：<https://developer.apple.com/design/human-interface-guidelines/designing-for-iphone-duo>
> - **Apple 开发者文档《Preparing your app for iPhone Duo》**（工程实现指南，API 级细节）：<https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo>
> - **Tech Talk 111466《Design for iPhone Duo》**（配套视频，10 分钟快速入门）：<https://developer.apple.com/videos/play/tech-talks/111466/>
>
> 整理日期：2026-10-24 ｜ 一句话总结：**让 App 像"单一体验"一样，在任何尺寸、任何姿态下都能自由适配。**

---

## 目录

1. [为什么需要适配](#1-为什么需要适配)
2. [设备结构与姿态](#2-设备结构与姿态)
3. [四大核心设计原则](#3-四大核心设计原则)
4. [动态布局：尺寸等级、安全区与保留区域](#4-动态布局尺寸等级安全区与保留区域)
5. [侧边纵向控件（Vertical Controls）](#5-侧边纵向控件vertical-controls)
6. [内容偏移与全屏居中](#6-内容偏移与全屏居中)
7. [内屏：充分利用宽屏](#7-内屏充分利用宽屏)
8. [组件行为：Sheet 与折叠避让](#8-组件行为sheet-与折叠避让)
9. [多任务：Split View 与画中画](#9-多任务split-view-与画中画)
10. [游戏 App 专项](#10-游戏-app-专项)
11. [开发者适配清单（Checklist）](#11-开发者适配清单checklist)
12. [工程实现要点与 API 速查](#12-工程实现要点与-api-速查)
13. [适配优先级建议（P0 / P1 / P2）](#13-适配优先级建议p0--p1--p2)
14. [常见误区](#14-常见误区)
15. [资源与相关视频](#15-资源与相关视频)
16. [附录：视频章节索引](#附录视频章节索引)

---

## 1. 为什么需要适配

iPhone Duo 是苹果首款折叠 iPhone，带来全新的交互形态：

- **双显示屏**：闭合时使用**外屏**（比传统 iPhone 更宽、更短）；打开后呈现**内屏**（iPhone 迄今最大、最沉浸的显示面积），折叠后依然可放进口袋。
- **中央铰链**：支持多种握持与摆放方式——书本式半折、桌面支架式、竖立边缘式等。
- **系统级新能力**：Split View 分屏多任务、画中画置顶、新式纵向控件布局。

App 可能在任何尺寸、任何姿态下运行，因此**可自由缩放（resizability）**是适配的第一原则。好消息是：**如果你已经在用标准系统组件 + 尺寸等级 + 安全区，你的 App 大部分适配是自动完成的。**

---

## 2. 设备结构与姿态

### 2.1 双屏与关键部件

| 部件 | 说明 |
|---|---|
| **外屏** | 闭合时使用；宽而短，控件移到侧边以最大化纵向空间 |
| **内屏** | 打开后使用；面积最大，适合展示更多层级与内容 |
| **铰链（Hinge）** | 中央折叠轴；半折时形成"折叠区域"，内容需避让 |
| **外侧前置摄像头** | 常驻可见，位于角落，与侧边控件垂直对齐；Live Activities 时随灵动岛垂直展开 |
| **内侧前置摄像头** | 屏下隐藏，**仅激活时显示**；激活时 UI 自动让位以标示其存在 |

### 2.2 六种典型姿态

| # | 姿态 | 尺寸等级 | 关键适配点 |
|---|---|---|---|
| 1 | 闭合（外屏使用） | compact width | 控件在右侧边，内容避让 |
| 2 | 完全展开 · 横屏 | regular width | 控件仍在侧边，保持与外屏一致的体验 |
| 3 | 完全展开 · 竖屏 | regular width | **唯一保留横向 bar 的姿态**（纵向空间充足） |
| 4 | 书本式半折 | regular width | 内容移开中央曲线，交互元素移到两侧 |
| 5 | 桌面支架式 | regular width | 可选：媒体在上、可点控件在下（免手持） |
| 6 | 竖立边缘式 | regular width | 系统自动适配；内容避开折痕 |

> 关键认知：**不必为每种姿态设计专属布局**。用两种尺寸等级 + 自适应容器即可覆盖全部姿态。姿态专属布局是"可选加分项"，且必须保持与其他姿态相同的功能与层级。

---

## 3. 四大核心设计原则

### ① 可自由缩放（Resizability）
- 避免**固定宽度、断点、任何绑定特定屏幕的度量值**。
- 永远面向**尺寸等级（size classes）**设计。
- 用**布局边距（layout margins）**与**水平安全区 insets** 构建界面。
- 让布局随可用空间**自然扩展**，而不是换一套设计。

### ② 只有两个尺寸等级
- 外屏 = **compact width**；内屏 = **regular width**。
- 不要为每个姿态写定制布局——控制复杂度，用一套布局自适应全部姿态。

### ③ 单一体验（Single Experience）
- 内外屏**功能一致、层级一致、状态一致**。
- **不把功能绑定到特定姿态**：用户会在使用过程中频繁开合设备，行为必须可预测、内外一致。

### ④ 优先使用系统组件
- 系统组件自动获得 iPhone Duo 的新行为：侧边布局、溢出菜单、**折叠避让**等。
- 自定义组件无法免费获得这些行为，需要手动处理。

---

## 4. 动态布局：尺寸等级、安全区与保留区域

### 4.1 布局基础
- 使用 **size classes + layout margins + safe area insets**。
- 禁用固定宽度与显示尺寸相关依赖。
- 用 Xcode 的 **Device Hub** 预览 iPhone Duo 各姿态下的表现。

### 4.2 保留区域（Reserved Regions）

保留区域 = 显示区内**内容应避让**或**组件应适配**的区域，类似 iPad 上避让窗口控件的逻辑。iPhone Duo 共三类：

| 保留区域 | 出现条件 | 处理方式 |
|---|---|---|
| **外侧摄像头区域** | 常驻 | 侧边控件模式下系统自动处理；Live Activities 时随灵动岛垂直展开 |
| **内侧摄像头区域** | 仅摄像头激活时 | 激活时 UI 自动让位，标示摄像头存在 |
| **折叠区域** | 设备半开时 | 内屏被折痕分为多个可用区域，中央区域让出 |

自定义组件 API：SwiftUI `ReservedRegion` / UIKit `UIView.ReservedRegion`。大型系统组件（如 Split Views）会自动适配保留区域——随内屏对称性自动调整各栏宽度与边距。

### 4.3 折叠时的布局适配
- 优先选择**能自动适配的布局容器**（如 Notes 的 Split View 会随折叠自动调整每栏宽度，保持内容清晰可见）。
- 网格布局优先用**偶数栏**，内容可被折痕干净地均分。
- 系统组件（alerts、菜单、sheets 等）自动避让折叠。
- **避免剧烈布局变化**：折叠时只移动必要元素，保持元素可发现、易追踪；倾向**小幅调整**而非整体重排。

### 4.4 Split Views
- 内屏展开为多栏，外屏收起为单栏——与 iPad compact/regular 环境的行为一致。
- 用标准组件构建时自动适配保留区域（自动调整栏宽与边距以匹配内屏对称性）。
- API：SwiftUI `NavigationSplitView` / UIKit `UISplitViewController`。

### 4.5 Arrangement Views（新布局容器）

一个容器内放两个视图（primary + secondary），根据**显示尺寸、方向、保留区域**动态组织：

| 类型 | 行为 |
|---|---|
| **Split 排列** | 宽 > 高时水平分割，高 > 宽时垂直分割 |
| **Overlay 排列** | 默认叠放（primary 在上）；半折时两视图**各占一侧** |

- 迁移建议：布局本来就是 `HStack`/`VStack` → 用 **split**；本来就是 `ZStack` → 用 **overlay**。
- **导航容器放在 Arrangement View 外层**——它只负责内容排布，不处理导航。
- 可限制 Split 排列使用的轴向（只横切或只纵切）；Overlay 排列可折叠 secondary view，不需要时不显示。
- API：SwiftUI `ArrangementView` / UIKit `UIArrangementViewController`。

---

## 5. 侧边纵向控件（Vertical Controls）

### 5.1 基本规则

- **外屏、内屏横屏**：工具栏、标签栏、导航控件移到**设备侧边**（右拇指易达），把纵向空间全部留给内容。
- **唯一例外：内屏竖屏**保留标准横向 bar——因为此时纵向空间充足。
- 侧边纵向栏包含：**灵动岛、状态栏、工具栏（含导航按钮）、标签栏**。
- Split View 双 App 时：**左 App 控件在左边缘，右 App 控件在右边缘**（各自拇指可达、远离中央）。
- RTL 语言：控件保持与硬件方向一致（仍在对侧同一边）。

### 5.2 布局顺序
- 顶部放**主导航**（Back / Close），随后是**主要操作**（如 Done）——保持熟悉的导航模式。
- 其余条目保持**原有分组**；系统自动在"源自顶部 bar"与"源自底部 bar"的条目之间留出空隙。

### 5.3 空间不足：溢出与压缩

| 机制 | 说明 | API |
|---|---|---|
| **溢出菜单** | 空间不足时控件自动收进系统 overflow menu，默认**自下而上**溢出 | `ToolbarOverflowMenu`（SwiftUI）/ `additionalOverflowItems`（UIKit） |
| **可见性优先级** | 改变溢出顺序：先按整组、再按组内单项 | `ToolbarItemVisibilityPriority` / `UIBarButtonItemVisibilityPriority` |
| **压缩行为（导航型）** | 压缩工具栏、保留标签栏与主要目的地（默认） | `ToolbarVerticalCompressionBehavior` / `UIVerticalBarCompressionBehavior` |
| **压缩行为（任务型）** | 最小化标签栏、保留任务核心的工具栏操作 | 同上 |

- 优先保留高频操作（如 Mail 的 Compose、Notes 的新建）与带角标的状态信息。
- **用系统溢出菜单**，别自建；省略号（ellipsis）只留给溢出，其他菜单用不同符号。

### 5.4 例外：不迁移到侧边的控件
- **过宽的控件留在横向导航栏**：文字按钮、分段控件（segmented control）等放不进右侧纵向空间的东西。

### 5.5 细节建议
- **分组而非手工间距**：用 `ToolbarItemGroup`（SwiftUI）/ `UIBarButtonItemGroup`（UIKit）自动管理组间空隙，别自己加固定间距。
- 每个非纯文字条目**同时提供 title + symbol**（`Label` / `UIBarButtonItem`）——系统在溢出菜单和展开态使用 title。
- **尽量用图标按钮**，减少文字按钮（文字按钮留在横向 bar）。
- 控件放在**其影响的内容附近**：如 Mail 中作用于邮件列表的控件，放在 leading pane 上方而非统一收进侧边。
- 默认**不要覆盖 bar 位置**——侧边纵向布局是 iPhone Duo 的核心模式。
- **跨姿态保持控件相对位置稳定**：不同姿态下控件位置尽量相似，用户不应因切换姿态而重新学习操作位置。

---

## 6. 内容偏移与全屏居中

侧边控件让布局**不对称**——你不再适合把所有内容居中。三种做法：

| 内容类型 | 推荐做法 |
|---|---|
| **大多数内容** | 对齐**水平安全区 insets**，偏移自动发生，避免被右侧控件遮挡 |
| **沉浸式、高视觉、不滚动界面** | 可**全屏居中**（如计算器），但必须确认右侧控件不会遮挡交互元素 |
| **混合式** | **全宽背景图/头部** + 可滚动前景内容 inset；所有交互元素必须位于可滚动区域内，保证不被覆盖 |

> 分屏（Split View）时还要注意：左右两个 App 的控件都在**各自的外边缘**，用安全区确保内容不被本侧或对侧控件遮挡。

---

## 7. 内屏：充分利用宽屏

内屏不是"拉伸版的 iPhone App"。三种推荐方案：

| 方案 | 适用 | 示例 | 说明 |
|---|---|---|---|
| **A. Split View** | 层级型内容 | Mail | 外屏：列表或详情；内屏：两者并排。注意内外层级一致、功能不因姿态增减 |
| **B. 双栏布局** | 内容可在宽屏下重排 | Music | 竖向堆叠布局在横向空间充足时重排为双栏 |
| **C. Tab Bar → Sidebar** | 信息密集型 App | Health | 内屏把标签栏变成侧边栏，展示更多导航层级；并非所有 App 都适合 |

要点：**保持层级与功能在内外屏一致**——用户可能边开边合，体验必须可预测。

---

## 8. 组件行为：Sheet 与折叠避让

### 8.1 Sheets 按姿态自适应

| 姿态 | Sheet 行为 |
|---|---|
| **外屏** | 控件默认移到侧边（**纵向**）；可禁用 vertical bar（适合只有单个工具栏按钮的 sheet）→ sheet 停在摄像头下方、状态栏重新定位 |
| **内屏（横/竖）** | 使用标准**横向 bar** |
| **半折时** | Sheet **滑开避开折痕** |

### 8.2 折叠避让（Fold Avoidance）

按钮落在折痕（曲线区域）上很难点按，因此系统内置了"把交互元素推出中央区域"的行为：

- 已内置该行为的系统组件：**sheets、alerts、菜单、工具栏按钮**等。
- **尽量使用系统组件**，免费获得折叠避让。
- 自定义交互元素：用 `ReservedRegion` API 或手动避让。
- **可滚动内容不需要避让中央区域**。
- 半折·横屏：文本/图片移开曲线区域，按钮与交互元素移到两侧——曲线成为布局的自然分界。
- 半折·竖屏：交互元素移到**下半屏**——更易够到，且让设备在桌面上保持稳定。

---

## 9. 多任务：Split View 与画中画

- **50/50 分屏**：两个 App 各占一半、独立工作；控件位于各自外边缘（左 App 在左、右 App 在右），远离中央。
- **画中画置顶**：视频可钉在屏幕顶部，当前 App **自动垂直缩放**适配剩余空间。
- **半折时**：视频扩展为半屏，App 实时调整布局。
- 结论：App 必须在**任意宽高比**下都能工作——这就是"可自由缩放"的实战场景。

---

## 10. 游戏 App 专项

- 可锁定横屏或竖屏，但**姿态变化时要填满屏幕**。
- 缩放时尽量保持文字与控件尺寸一致。
- **优先改变宽高比**，而不是 letterboxing / pillarboxing；若无法避免留黑边，用**艺术图填充**让体验保持全屏感。

---

## 11. 开发者适配清单（Checklist）

**布局**
- [ ] 只用 size classes，无固定宽度、断点、屏幕绑定度量值
- [ ] 使用 layout margins + safe area insets
- [ ] 检查三块保留区域（外摄像头 / 内摄像头 / 折叠区）下的布局
- [ ] 网格布局用偶数栏（半折时可干净均分）

**控件**
- [ ] 使用系统 bar/工具栏组件（自动获得侧边布局与溢出）
- [ ] 所有非文字工具栏项提供 title + symbol
- [ ] 用 ToolbarItemGroup 分组，不手工加固定间距
- [ ] 用系统溢出菜单；省略号只留给溢出
- [ ] 不覆盖默认 bar 位置；过宽控件（文字按钮/分段控件）留在横向 bar
- [ ] 跨姿态保持控件相对位置稳定

**体验一致性**
- [ ] 内外屏功能、层级、状态一致
- [ ] 不把功能绑定到特定姿态
- [ ] 半折时交互元素避开中央（系统组件或 ReservedRegion）
- [ ] 所有交互元素位于可滚动区域内

**验证**
- [ ] Device Hub 预览全部姿态
- [ ] Split View / 画中画下验证可缩放
- [ ] 检查 Sheet 三种姿态行为（外屏纵向 / 内屏横向 / 半折滑开）
- [ ] 游戏：姿态变化填满屏幕、无意外 letterbox

**工程实现**
- [ ] 用最新版 Xcode 构建（Xcode 26 及更早不会延伸到状态栏/摄像头之下）
- [ ] 用自动 trait 追踪观察 size class；不用 `userInterfaceIdiom` / `UIInterfaceOrientation` 做布局决策
- [ ] 视图尺寸相对容器、布局基于 scene bounds；UIKit 用 Auto Layout
- [ ] 逐个检查 view / sheet / popover 在开合、旋转、各姿态下的表现；识别落在折痕里的元素
- [ ] bar 未纵向化时检查导航容器 bar 支持（SwiftUI `toolbar(content:)` / UIKit navigation controller）
- [ ] 自定义视图用 `reservedRegions` API 处理 division / occlusion
- [ ] ArrangementView 不嵌套在 navigation split view / list / scroll view 内
- [ ] （相机 App）按摄像头朝向选相机，处理内外屏切换

---

## 12. 工程实现要点与 API 速查

> 本节主要来自 Apple 开发者文档《Preparing your app for iPhone Duo》（工程实现指南）：<https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo>。HIG 讲"应该怎么设计"，本节讲"具体怎么实现"。

### 12.1 缩放与布局的工程准则
- 优先使用系统提供的布局与容器：**Split Views、Tab Bars、Arrangement Views、Navigation Stacks**——它们自动处理缩放、外屏/内屏（展开或折叠）与摄像头遮挡。
- **视图尺寸相对容器而定**，不要写死 iPhone 尺寸；布局计算基于 **scene 或容器的 bounds**，不要用屏幕尺寸。
- UIKit 使用 **Auto Layout** 保证可缩放。
- 用**自动 trait 追踪**观察 `horizontalSizeClass` / `verticalSizeClass` 的变化来适配；**不要用 `userInterfaceIdiom` 或 `UIInterfaceOrientation` 做布局决策**。
- 用**最新版 Xcode** 构建以使用全部屏幕空间：用 **Xcode 26 及更早版本**构建时，App 不会延伸到状态栏和摄像头之下。

### 12.2 Bar 纵向展示的工程控制
- 系统在**外屏（闭合时）**以及**内屏展开后某些 leading / trailing 位置的视图**中纵向展示 bar。
- 若 bar 没有自动纵向化，检查是否用了导航容器的 bar 支持：
  - SwiftUI：把 `toolbar(content:)` 加在 `NavigationStack` 或 `NavigationSplitView` 上
  - UIKit：把工具栏项设置到**加入 navigation controller 的 view controller** 上；不要基于 `UIToolbar` / `UINavigationBar` / `UITabBar` 自建 bar
- 系统在不同上下文中的横/纵选择：

| 上下文 | 行为 |
|---|---|
| Inspector | 横向 |
| Split View | sidebar / 内容视图 → 横向；detail 视图 → 纵向 |
| Sheet（外屏） | 默认纵向；用 `toolbarVerticalBehavior(_:)`（SwiftUI）/ `preferredVerticalBarBehavior`（UIKit）禁用 |
| Sheet（内屏） | centered / leading 放置 → 横向；trailing 放置 → 纵向；用 `presentationPlacement(_:)`（SwiftUI）/ `preferredPlacement`（UIKit）指定 |

- 自定义视图判断 bar 是否纵向：`toolbarVerticalEdge`（SwiftUI 环境值）/ `verticalBarEdge`（UIKit trait）
- Hero / 背景图延伸到纵向 bar 之下：`backgroundExtensionEffect()`（SwiftUI）/ `UIBackgroundExtensionView`（UIKit）

### 12.3 Bar 条目组织与溢出
- 顶部放主导航（Back / Close）→ 主要操作（Done）；使用 navigation controller 时系统自动添加 Back。
- 用语义化放置组织条目：
  - 分组：`ToolbarItemPlacement`（SwiftUI）
  - 主要操作（如 Done）：`topBarPinnedTrailing`（SwiftUI）/ `pinnedTrailingGroup`（UIKit）
  - 自定义 Back / Close：`ToolbarItem` + `cancellationAction`（SwiftUI）/ `leadingItemGroups`（UIKit）
- 控制条目是否进入纵向布局：`axisBehavior(_:)`（SwiftUI）/ `axisBehavior`（UIKit）
- 控制溢出顺序：`visibilityPriority(_:)`（SwiftUI）/ `visibilityPriority`（UIKit）
- 直接放入溢出菜单：`ToolbarOverflowMenu`（SwiftUI）/ `additionalOverflowItems`（UIKit）
- **图标 / 标题规则**（决定条目能否纵向展示）：

| 展示形式 | 系统使用 |
|---|---|
| 纵向 | 只用图标 |
| 横向 | 图标或标题（优先图标） |
| 溢出菜单 | 图标 + 标题 |
| 只有标题、无图标 | **不纵向展示** |
| 自定义视图（无标题 / 图标） | **不纵向展示** |

### 12.4 ArrangementView 工程用法
- Split 排列：容器**宽 > 高**时主次视图并排；**高 > 宽**时主上副下；自动适配折叠区域。
- Overlay 排列：无分割型保留区域时主视图叠在副视图之上（闭合或完全展开）；**半折时主视图在 trailing / 底部、副视图在 leading / 顶部**（相对折痕）。
- 限制轴向：
  - SwiftUI：`.arrangementViewStyle(.split.axes(.horizontal))`
  - UIKit：`arrangementVC.updateArrangement(.split.axes(.horizontal))`
- **不要把 ArrangementView 放在 NavigationSplitView、List、ScrollView 或其他容器内**，否则部分视图可能不可达。

### 12.5 保留区域与摄像头遮挡 API
- 自定义视图需要识别两类保留区域：
  - **division（分割）**：折叠区域把大视图分成若干小视图
  - **occlusion（遮挡）**：硬件（摄像头）盖住内容；外屏摄像头常驻遮挡，内屏摄像头激活时遮挡
- 获取保留区域：
  - SwiftUI：`GeometryReader` → `GeometryProxy` → `reservedRegions(kind:options:layoutDirectionBehavior:)` 返回 `ReservedRegion` 数组
  - UIKit：`reservedRegions(kind:options:)` 返回 `UIView.ReservedRegion` 数组
- 检查各区域 frame 后相应调整布局。
- **保留区域有 active / inactive 状态**：如折叠区域在半开时 active，完全展开时 inactive。

### 12.6 相机 App 专项
- 用 AVKit / AVFoundation 可调用**外屏摄像头、内屏摄像头、后置摄像头**。
- 开合、旋转时 App 可能切换所在屏幕，摄像头可能朝向相反方向——按"摄像头朝向"选相机（*Choosing a camera by the direction it faces*）。
- 完全展开 + 后置拍摄时，可在**外屏同步显示内容**（*Registering a camera capture accessory on iPhone Duo*）。

### 12.7 SwiftUI / UIKit API 速查表

| 能力 | SwiftUI | UIKit |
|---|---|---|
| 安全区 | `safeAreaInsets` | `safeAreaInsets` |
| 保留区域（折叠避让） | `ReservedRegion` | `UIView.ReservedRegion` |
| 获取保留区域 | `GeometryProxy.reservedRegions(kind:options:layoutDirectionBehavior:)` | `UIView.reservedRegions(kind:options:)` |
| 分栏布局 | `NavigationSplitView` | `UISplitViewController` |
| 排列容器（Split/Overlay） | `ArrangementView` | `UIArrangementViewController` |
| 工具栏项可见性优先级 | `ToolbarItemVisibilityPriority` | `UIBarButtonItemVisibilityPriority` |
| 工具栏分组 | `ToolbarItemGroup` | `UIBarButtonItemGroup` |
| 纵向压缩行为 | `ToolbarVerticalCompressionBehavior` | `UIVerticalBarCompressionBehavior` |
| 系统溢出菜单 | `ToolbarOverflowMenu` | `additionalOverflowItems` |
| 带标题的图标条目 | `Label` | `UIBarButtonItem` |
| 纵向 bar 行为 | `toolbarVerticalBehavior(_:)` | `preferredVerticalBarBehavior` |
| Sheet 放置 | `presentationPlacement(_:)` | `preferredPlacement` |
| 判断 bar 是否纵向 | `toolbarVerticalEdge`（环境值） | `verticalBarEdge`（trait） |
| 背景延伸 | `backgroundExtensionEffect()` | `UIBackgroundExtensionView` |
| 语义化放置 / 导航项 | `ToolbarItemPlacement` · `cancellationAction` · `topBarPinnedTrailing` | `pinnedTrailingGroup` · `leadingItemGroups` |
| 轴向行为 | `axisBehavior(_:)` | `axisBehavior` |
| size class 追踪 | `horizontalSizeClass` / `verticalSizeClass`（自动 trait 追踪） | 同左 |

---

## 13. 适配优先级建议（P0 / P1 / P2）

### P0 —— 上线前必须（决定"能不能用"）
1. **可自由缩放**：size classes 替代固定宽度/断点，任意宽高比可用
2. **布局边距 + 安全区 insets**（内容不被侧边控件遮挡）
3. **使用系统组件**（自动获得侧边布局、溢出菜单、折叠避让）
4. **内外屏功能/层级/状态一致**（不把功能绑定到姿态）
5. **折叠避让**：半折时交互元素避开中央（系统组件或 ReservedRegion）

### P1 —— 重要（决定"好不好用"）
1. 内屏布局策略：Split View 或双栏布局（别做成拉伸版）
2. Sheet 三姿态行为检查（外屏纵向 / 内屏横向 / 半折滑开）
3. 溢出与压缩行为：设置可见性优先级，保高频操作
4. 文字按钮/分段控件迁移检查（过宽控件留横向 bar）

### P2 —— 增强（锦上添花）
1. Tab Bar → Sidebar（信息密集类 App）
2. 桌面支架式专属布局（媒体上、控件下，免手持）
3. 沉浸式全屏居中界面（如计算器）
4. 游戏：全姿态填屏 + 艺术图填充

---

## 14. 常见误区

1. ❌ **为每个姿态做一套布局** → ✅ 只面向 compact / regular 两种尺寸等级
2. ❌ **固定宽度/断点** → ✅ 自适应容器，让布局自然扩展
3. ❌ **把功能绑定到某个姿态** → ✅ 用户会频繁开合，行为必须内外一致、可预测
4. ❌ **自建溢出菜单** → ✅ 用系统 overflow menu，省略号只留给溢出
5. ❌ **手工加固定间距** → ✅ 用 ToolbarItemGroup 自动管理
6. ❌ **半折时把一切移开中央** → ✅ 可滚动内容无需避让
7. ❌ **文字按钮也迁移到侧边** → ✅ 过宽控件留在横向导航栏
8. ❌ **内屏竖屏也强制侧边栏** → ✅ 那是唯一保留横向 bar 的姿态
9. ❌ **内屏=拉伸版外屏** → ✅ 用 Split View / 双栏 / Sidebar 充分利用宽度
10. ❌ **忽略 RTL** → ✅ 侧边控件与硬件对齐，RTL 下保持同侧
11. ❌ **用 `userInterfaceIdiom` / `UIInterfaceOrientation` 做布局决策** → ✅ 用 size class（自动 trait 追踪）
12. ❌ **自建 bar（基于 UIToolbar / UINavigationBar / UITabBar）** → ✅ 用导航容器提供的 bar 支持
13. ❌ **工具栏项只有标题没有图标** → ✅ 提供图标 + 标题，否则无法纵向展示
14. ❌ **把 ArrangementView 放进 NavigationSplitView / List / ScrollView** → ✅ 放在这些容器外层

---

## 15. 资源与相关视频

**官方文档**
- HIG《Designing for iPhone Duo》（设计指南，最完整）：<https://developer.apple.com/design/human-interface-guidelines/designing-for-iphone-duo>
- 开发者文档《Preparing your app for iPhone Duo》（工程实现指南）：<https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo>
- Apple Design Resources：<https://developer.apple.com/design/resources/>
- 截图规范（Screenshot specifications）：HIG 内 "Related" 链接

**开发文档（相关）**
- TN3210《Optimizing your app for iPhone Mirroring》
- Automatic trait tracking
- Adopting Liquid Glass

**视频（Tech Talks）**
- 《Design for iPhone Duo》Tech Talk 111466：<https://developer.apple.com/videos/play/tech-talks/111466/>
- Tech Talk 111462：<https://developer.apple.com/videos/play/tech-talks/111462>
- Tech Talk 111463：<https://developer.apple.com/videos/play/tech-talks/111463>
- 《Raise the bar with iPhone Duo》
- 《Strike a pose with adaptive layouts on iPhone Duo》
- 《Prepare your app for iPhone Duo》
- 《Leverage multiple displays and scenes on iPhone Duo》
- 《Build a great camera experience for iPhone Duo》
- 《Modernize your UIKit app》
- 《Make your UIKit app more flexible》

---

## 附录：视频章节索引

| 时间 | 章节 | 核心要点 |
|---|---|---|
| 0:00 | 开场 | 设计团队介绍设备背后的设计原则 |
| 0:28 | 姿态与控件 | 多种姿态；控件移到侧边最大化纵向空间；半折时内容自动离开中央；Split View 与画中画 → 支持可缩放 |
| 3:42 | 尺寸等级 | 不要按姿态定制布局；只用 compact/regular 两种尺寸等级；用布局边距与安全区；姿态专属布局须保留功能与层级 |
| 5:07 | 侧边控件 | 工具栏/标签栏/控件放侧边；与灵动岛、状态栏共享纵向空间；空间不足收进溢出菜单；过宽控件为例外 |
| 6:33 | 内容偏移 | 多数内容需偏移避开控件，安全区自动处理；沉浸式不滚动界面可全屏居中；可混合（全宽背景 + 内缩内容） |
| 7:34 | 内屏布局 | 利用宽屏：Split View 展示更多层级；或重排为双栏布局 |
| 8:36 | Sheets | 外屏纵向控件；内屏横向 bar；半折时滑开避开折痕 |
| 9:28 | 折叠避让 | 系统组件自动把交互元素推出中央；可滚动内容除外 |
| 10:01 | 总结 | 单一体验适配所有尺寸与姿态；支持可缩放 + 侧边控件 = 真正融入 iPhone Duo |
