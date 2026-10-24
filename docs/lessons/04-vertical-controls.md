# Vertical Controls：让系统管理控件

## 核心原则

在 iPhone Duo 上，工具栏、导航控件和 Tab Bar 可能会根据显示区域被放到设备侧边。应用应该提供语义化的系统 toolbar，而不是使用自建的横向 `HStack` 固定控件位置。

## 本项目中的实验

实验使用：

- `ToolbarItemGroup` 组织相关操作；
- `Label` 同时提供图标和标题；
- `topBarLeading`、`topBarTrailing` 和 `bottomBar` 表达操作语义；
- `Menu` 和 `Picker` 表达筛选操作；
- `NavigationStack` 提供系统导航上下文。

点击“标记”、 “分享”和“筛选”，再改变窗口尺寸，观察功能状态是否仍然保持。

## 验证清单

- 是否使用系统 `.toolbar`，而不是自建控制条？
- 每个图标操作是否同时提供了标题？
- 相关操作是否使用 `ToolbarItemGroup` 分组？
- 高频操作是否容易找到？
- 空间不足时，是否允许系统处理 overflow？
- 控件位置变化时，功能和状态是否保持一致？
