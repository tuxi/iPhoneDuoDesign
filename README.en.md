# iPhone Duo Design Guide (English)

> 中文版：[iPhone-Duo-设计指南.md](./iPhone-Duo-设计指南.md) · 项目入口：[README.md](./README.md)

A practical adaptation guide for building iOS apps that feel great on **iPhone Duo** — the first folding iPhone.

> Compiled from Apple's official material (2026-09-09):
>
> - **Apple HIG — [Designing for iPhone Duo](https://developer.apple.com/design/human-interface-guidelines/designing-for-iphone-duo)** — the **primary and most comprehensive official design guide**
> - **Apple Developer Docs — [Preparing your app for iPhone Duo](https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo)** — implementation guide with API-level details
> - **Tech Talk 111466 — [Design for iPhone Duo](https://developer.apple.com/videos/play/tech-talks/111466/)** — companion video, 10-minute quick start (Marcos & Vince, Apple Design team)
>
> One-sentence summary: **Make your app feel like a single experience that adapts freely to any display size and pose.**

> 🇨🇳 中文版见 [iPhone-Duo-设计指南.md](./iPhone-Duo-设计指南.md)（Chinese version available here）

---

## Project Overview

This repository is a **hands-on demo + reference kit for adapting iOS apps to iPhone Duo**, Apple's first folding iPhone. It pairs the official design guidance (Tech Talk + HIG) with a minimal SwiftUI project you can run and modify to test the adaptation patterns in practice.

**Official reference**
- HIG — [Designing for iPhone Duo](https://developer.apple.com/design/human-interface-guidelines/designing-for-iphone-duo)（**primary design guide, most comprehensive**）
- Developer Docs — [Preparing your app for iPhone Duo](https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo)（implementation guide, API-level details）
- Video — [Design for iPhone Duo · Tech Talk 111466](https://developer.apple.com/videos/play/tech-talks/111466/)（companion quick start）

**What's inside**

| Path | Description |
|---|---|
| `iPhoneDuoDesign.xcodeproj` / `iPhoneDuoDesign/` | **SwiftUI learning app** — tabs for the guide, bar compression experiment, and a fold-aware video editor demo; covers size classes, safe areas, vertical controls, toolbars, arrangements, multiple scenes, and occlusion regions |
| `README.md` | Project landing page and language navigation |
| `README.en.md` | English adaptation guide (this file) |
| `iPhone-Duo-设计指南.md` | 中文版适配指南 (Chinese adaptation guide) |
| `docs/` | Lesson docs and learning path |

**How to use this repo**
1. Read this guide (or the [Chinese version](./iPhone-Duo-设计指南.md)) to learn the rules and the P0/P1/P2 priorities.
2. Open `iPhoneDuoDesign.xcodeproj` in Xcode and use **Device Hub** to preview the app across iPhone Duo poses.
3. Extend the demo to apply each pattern — start with the P0 checklist.

---

## Table of Contents

- [Why adapt](#why-adapt)
- [Device anatomy & poses](#device-anatomy--poses)
- [Four core design principles](#four-core-design-principles)
- [Dynamic layouts: size classes, safe areas & reserved regions](#dynamic-layouts-size-classes-safe-areas--reserved-regions)
- [Vertical controls](#vertical-controls)
- [Content offset & full-screen centering](#content-offset--full-screen-centering)
- [The inner display: make the most of the width](#the-inner-display-make-the-most-of-the-width)
- [Component behaviors: sheets & fold avoidance](#component-behaviors-sheets--fold-avoidance)
- [Multitasking: Split View & picture-in-picture](#multitasking-split-view--picture-in-picture)
- [Games](#games)
- [Developer checklist](#developer-checklist)
- [Engineering implementation notes & API reference](#engineering-implementation-notes--api-reference)
- [Adaptation priorities (P0 / P1 / P2)](#adaptation-priorities-p0--p1--p2)
- [Common mistakes](#common-mistakes)
- [Resources & related videos](#resources--related-videos)
- [Appendix: video chapter index](#appendix-video-chapter-index)

---

## Why adapt

iPhone Duo is Apple's first folding iPhone and brings a reimagined iOS:

- **Two displays**: when closed, you use the **outer display** (wider and shorter than a traditional iPhone); when open, the **inner display** — the largest, most immersive display ever on an iPhone, still pocketable.
- **Center hinge**: supports a wide range of ways to hold and set the device down — book mode, seated on a table like a laptop, standing on its edges.
- **New system capabilities**: Split View multitasking, pinned picture-in-picture, and a new vertical control layout.

Your app can run at many sizes and in many poses, so **resizability is the #1 principle**. The good news: if you already use standard system components + size classes + safe areas, most of the adaptation is automatic.

---

## Device anatomy & poses

### Anatomy

| Component | Notes |
|---|---|
| **Outer display** | Used when closed; wider and shorter; controls move to the side to maximize vertical space |
| **Inner display** | Used when open; the largest canvas; suited for showing more hierarchy |
| **Hinge** | Center folding axis; when partially folded it creates a "folding region" content must avoid |
| **Outer front camera** | Always visible, in the corner, vertically aligned with the side controls; expands vertically with the Dynamic Island for Live Activities |
| **Inner front camera** | Hidden behind the display; only visible when the camera is active (UI moves aside to reveal it) |

### Six typical poses

| # | Pose | Size class | Key adaptation |
|---|---|---|---|
| 1 | Closed (outer display) | compact width | Controls on the right edge; content inset |
| 2 | Fully open · landscape | regular width | Controls stay on the side for a consistent experience |
| 3 | Fully open · portrait | regular width | **The only pose that keeps horizontal bars** (plenty of vertical space) |
| 4 | Partially folded (book mode) | regular width | Content moves away from the center curve; interactive elements move to the sides |
| 5 | Seated on a table | regular width | Optional: media on top, tappable controls on a stable base (hands-free) |
| 6 | Standing on its edges | regular width | System adapts automatically; avoid the fold |

> Key insight: **don't design a custom layout for each pose.** Two size classes + adaptive containers cover every pose. A pose-specific layout is an optional enhancement — and it must preserve the same functionality and general hierarchy as other poses.

---

## Four core design principles

### 1. Build your app to resize
- Avoid **fixed widths, breakpoints, or any metrics tied to a specific screen**.
- Always target **size classes**.
- Build with **layout margins** and **horizontal safe area insets**.
- Let your existing layout **expand naturally** with available space — don't swap in a new design.

### 2. Only two size classes
- Outer display = **compact width**; inner display = **regular width**.
- Don't write a custom layout per pose — one adaptive layout covers all poses.

### 3. Single experience
- Keep **functionality, hierarchy, and state consistent** between displays.
- **Don't tie functionality to a specific pose**: people open and close the device frequently; behavior must be predictable and consistent inside and out.

### 4. Prefer system components
- System components automatically get iPhone Duo's new behaviors: side placement, overflow menu, **fold avoidance**, and more.
- Custom components don't get these behaviors for free — handle them manually.

---

## Dynamic layouts: size classes, safe areas & reserved regions

### Layout fundamentals
- Use **size classes + layout margins + safe area insets**.
- No fixed widths or display-specific dependencies.
- Preview poses with **Device Hub** in Xcode.

### Reserved regions

Reserved regions are areas within the display that content avoids covering (or that components adapt to accommodate) — similar to avoiding window controls on iPad. iPhone Duo has three:

| Reserved region | When present | Handling |
|---|---|---|
| **Outer camera region** | Always | System handles it automatically in side-control mode; expands with the Dynamic Island for Live Activities |
| **Inner camera region** | Only when the camera is active | UI moves aside to indicate the camera's presence |
| **Folding region** | When the device is partially open | Divides the inner display into multiple usable regions; the center is excluded |

Custom components: SwiftUI `ReservedRegion` / UIKit `UIView.ReservedRegion`. Larger system components (e.g., split views) adapt automatically — their columns' width and margins adjust to match the inner display's symmetry.

### Adapting when the device folds
- Prefer layout containers that adapt automatically (e.g., Notes' Split View adjusts each pane's width to stay clearly visible as the device folds).
- In grid layouts, prefer an **even number of columns** so content divides cleanly at the fold.
- System components (alerts, menus, sheets, etc.) automatically avoid the fold.
- **Avoid extreme layout changes**: move only what's necessary to keep elements visible and tappable; favor small adjustments over rearrangement.

### Split views
- Expand on the inner display, collapse to a single pane on the outer display — same behavior as regular/compact environments on other iPhones.
- Built with standard components, they adapt to reserved regions automatically.
- APIs: SwiftUI `NavigationSplitView` / UIKit `UISplitViewController`.

### Arrangement views (new container)

A layout container holding a primary and a secondary view, dynamically organized by display size, orientation, and reserved regions:

| Type | Behavior |
|---|---|
| **Split arrangement** | Splits horizontally when wider than tall; splits vertically when taller than wide |
| **Overlay arrangement** | Views stack by default (primary above secondary); when partially folded, each view moves to occupy one side |

- Migration: a layout that is already `HStack`/`VStack` → use **split**; a `ZStack` → use **overlay**.
- **Keep navigation outside arrangement views** — they lay out content but don't handle navigation.
- You can limit which axes a split arrangement uses, and collapse the secondary view in an overlay arrangement when you don't want it to appear.
- APIs: SwiftUI `ArrangementView` / UIKit `UIArrangementViewController`.

---

## Vertical controls

### Basic rules
- **Outer display & inner landscape**: toolbars, tab bars, and navigation controls move to the **side of the device** (easy reach for the right thumb), maximizing vertical space for content.
- **The only exception: inner portrait** keeps standard horizontal bars — there's plenty of vertical space.
- The vertical strip contains: **Dynamic Island, status bar, toolbar (incl. navigation buttons), tab bar**.
- In Split View with two apps: the **left app's controls sit on the left edge**, the right app's on the right edge (thumb-reachable, away from the center).
- Right-to-left languages: controls stay aligned with the hardware (same side).

### Placement order
- Reserve the **top** of the vertical axis for primary navigation (Back / Close), followed by prominent actions (Done) — preserving familiar navigation patterns.
- Keep remaining items in their original groupings; the system inserts vertical space between items from the top and bottom bars to keep them distinct.

### When space runs out: overflow & compression

| Mechanism | Behavior | API |
|---|---|---|
| **Overflow menu** | Items automatically collapse into the system overflow menu; overflows **bottom-to-top** by default | `ToolbarOverflowMenu` (SwiftUI) / `additionalOverflowItems` (UIKit) |
| **Visibility priority** | Change overflow order — whole groups first, then individual items | `ToolbarItemVisibilityPriority` / `UIBarButtonItemVisibilityPriority` |
| **Compression (navigation-focused)** | Compress the toolbar to preserve the tab bar and primary destinations (default) | `ToolbarVerticalCompressionBehavior` / `UIVerticalBarCompressionBehavior` |
| **Compression (task-focused)** | Minimize the tab bar to preserve task-critical toolbar actions | Same as above |

- Preserve frequently used actions first (Mail's Compose, Notes' new note) and keep status-bearing items (badges) visible longer.
- **Use the system overflow menu** — don't build your own. Reserve the ellipsis for overflow; give other menus a distinct symbol.

### Exceptions: what does NOT move to the side
- **Controls too wide for the vertical strip stay in the horizontal nav bar**: text buttons, segmented controls, and the like.

### Details & best practices
- **Group, don't hand-space**: use `ToolbarItemGroup` (SwiftUI) / `UIBarButtonItemGroup` (UIKit) to get automatic spacing; avoid adding fixed spacing yourself.
- Provide **both a title and a symbol** for every non-text toolbar item (`Label` / `UIBarButtonItem`) — the system uses the title in overflow menus and expanded forms.
- **Prefer symbols over text buttons** (text-based labels stay in a horizontal bar).
- Keep controls **near the content they affect**: e.g., Mail's list controls stay above the leading pane rather than being collected on the side.
- In general, **don't override the default bar placement** — the vertical axis is a core iPhone Duo pattern.
- **Keep controls consistent across device poses**: relative positions should stay as similar as possible so people don't have to relearn where actions live as they change poses.

---

## Content offset & full-screen centering

Side controls make your layout **asymmetrical** — centering everything is no longer the right default:

| Content type | Recommended approach |
|---|---|
| **Most content** | Align to **horizontal safe area insets** — the offset happens automatically, keeping content clear of the side controls |
| **Immersive, highly visual, non-scrolling UI** | Can **center on the full display** (e.g., Calculator) — as long as interactive elements aren't blocked by the controls on the right |
| **Mixed approach** | **Full-width background image/header** + scrollable foreground content that's inset; every interactive element must live inside the scrollable area |

> In Split View, both apps' controls sit on their own **outer edges** — use safe areas so content isn't covered by either side.

---

## The inner display: make the most of the width

Don't ship a "stretched iPhone app." Three recommended approaches:

| Approach | Best for | Example | Notes |
|---|---|---|---|
| **A. Split View** | Hierarchical content | Mail | Outer: list or detail; inner: both side by side. Keep hierarchy and functionality consistent inside and out |
| **B. Two-column layout** | Content that can reflow | Music | A vertically stacked layout rearranges into two columns when horizontal space allows |
| **C. Tab Bar → Sidebar** | Information-dense apps | Health | Present the tab bar as a sidebar on the inner display; not for every app |

Keep hierarchy and functionality consistent between displays — users may fold/unfold mid-task, so the experience must be predictable.

---

## Component behaviors: sheets & fold avoidance

### Sheets adapt by pose

| Pose | Sheet behavior |
|---|---|
| **Outer display** | Controls move to the side (**vertical**); you can disable the vertical bar (great for sheets with a single toolbar button) → the sheet stops just short of the front camera and the status bar repositions |
| **Inner display (landscape & portrait)** | Standard **horizontal bars** |
| **Partially folded** | The sheet **slides over to avoid the fold** |

### Fold avoidance

Buttons are hard to tap when they land in the fold, so the system nudges interactive elements aside whenever the device is partially folded:

- Built into system components: **sheets, alerts, menus, toolbar buttons**, and more.
- **Use these components whenever possible** to get fold avoidance for free.
- For custom elements: use the `ReservedRegion` API or handle it manually.
- **Scrollable content does NOT need to avoid the center region.**
- Partially folded · landscape: text/images move off the curve; buttons and interactive elements move to the sides — the curve becomes a natural divider.
- Partially folded · portrait: interactive elements move to the **bottom half** — easier to reach and keeps the device stable on a surface.

---

## Multitasking: Split View & picture-in-picture

- **50/50 Split View**: two apps run independently; controls sit along each app's **outer edge** (left app → left edge), away from the center.
- **Pinned PiP**: a video can be pinned to the top; your app **resizes vertically** to fit the remaining space.
- **Partially folded**: the video extends to fill half the screen; your app adjusts in real time.
- Takeaway: your app must work at **any aspect ratio** — that's resizability in practice.

---

## Games

- You may lock to portrait or landscape, but **fill the screen as the pose changes**.
- Keep text and control sizes as consistent as possible when resizing.
- **Prefer changing the aspect ratio** over letterboxing/pillarboxing; if you can't avoid it, add artwork to the padding so the experience feels full screen.

---

## Developer checklist

**Layout**
- [ ] Size classes only — no fixed widths, breakpoints, or screen-bound metrics
- [ ] Layout margins + safe area insets
- [ ] Verify layout against all three reserved regions (outer camera / inner camera / fold)
- [ ] Grid layouts use an even number of columns

**Controls**
- [ ] Use system bar/toolbar components (automatic side layout & overflow)
- [ ] Every non-text toolbar item has both a title and a symbol
- [ ] Group with `ToolbarItemGroup` — no manual fixed spacing
- [ ] Use the system overflow menu; ellipsis reserved for overflow
- [ ] Don't override default bar placement; wide controls (text buttons/segmented controls) stay in the horizontal bar
- [ ] Control positions stay consistent across poses

**Experience consistency**
- [ ] Functionality, hierarchy, and state consistent across displays
- [ ] No functionality tied to a specific pose
- [ ] Interactive elements avoid the center when partially folded (system components or `ReservedRegion`)
- [ ] All interactive elements live inside a scrollable area

**Verification**
- [ ] Preview every pose with Device Hub
- [ ] Verify resizability under Split View / PiP
- [ ] Check sheets in all three poses (outer: vertical / inner: horizontal / folded: slides away)
- [ ] Games: fill the screen on every pose, no unexpected letterboxing

**Engineering**
- [ ] Build with the latest Xcode (Xcode 26 and earlier don't extend under the status bar and camera)
- [ ] Use automatic trait tracking for size classes; don't use `userInterfaceIdiom` / `UIInterfaceOrientation` for layout decisions
- [ ] Size views relative to containers; base layout on scene bounds; adopt Auto Layout in UIKit
- [ ] Walk every view, sheet, and popover through open/close/rotate and all poses; find elements stuck in the fold
- [ ] If bars aren't vertical, check navigation-container bar support (`toolbar(content:)` in SwiftUI / navigation controller in UIKit)
- [ ] Custom views use the `reservedRegions` API for divisions and occlusions
- [ ] Don't nest ArrangementView inside NavigationSplitView / List / ScrollView
- [ ] (Camera apps) choose cameras by the direction they face; handle display switches

---

## Engineering implementation notes & API reference

> This section is based on the Apple developer guide [Preparing your app for iPhone Duo](https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo). The HIG says *how it should look*; this says *how to build it*.

### Resizing & layout engineering
- Prefer system-provided layouts and containers: **split views, tab bars, arrangement views, navigation stacks** — they handle resizing automatically, including the outer display, the fully-open or folded inner display, and camera occlusions.
- **Size views relative to their container**, not to fixed iPhone dimensions; base layout calculations on **scene / containing view bounds**, not screen dimensions.
- Adopt **Auto Layout** in UIKit to make views resizable.
- Use **automatic trait tracking** to observe `horizontalSizeClass` / `verticalSizeClass` changes; **don't use `userInterfaceIdiom` or `UIInterfaceOrientation` for layout decisions**.
- Build with the **latest Xcode** to use all available screen space: with **Xcode 26 and earlier**, your app doesn't extend under the status bar and camera.

### Controlling vertical bar presentation
- The system presents bars vertically on the **outer display (closed)** and for **some views in leading/trailing positions on the inner display (open)**.
- If bars don't go vertical, check that you're using navigation-container bar support:
  - SwiftUI: add `toolbar(content:)` to a `NavigationStack` or `NavigationSplitView`
  - UIKit: set toolbar items on a view controller added to a navigation controller — **don't** build a custom bar from `UIToolbar` / `UINavigationBar` / `UITabBar`
- How the system picks horizontal vs vertical in different contexts:

| Context | Behavior |
|---|---|
| Inspectors | Horizontal |
| Split views | Sidebar / content view → horizontal; detail view → vertical |
| Sheets (outer display) | Vertical by default; disable with `toolbarVerticalBehavior(_:)` (SwiftUI) / `preferredVerticalBarBehavior` (UIKit) |
| Sheets (inner display) | Centered / leading placement → horizontal; trailing placement → vertical; set with `presentationPlacement(_:)` (SwiftUI) / `preferredPlacement` (UIKit) |

- In a custom view, detect vertical presentation with the `toolbarVerticalEdge` environment value (SwiftUI) or the `verticalBarEdge` trait (UIKit).
- Extend a hero / background image under a vertical bar with `backgroundExtensionEffect()` (SwiftUI) / `UIBackgroundExtensionView` (UIKit).

### Organizing bar items
- Reserve the top for primary navigation (Back / Close), then prominent actions (Done); a navigation controller adds Back automatically.
- Use semantic placements to organize items:
  - Grouping: `ToolbarItemPlacement` (SwiftUI)
  - Prominent actions (e.g., Done): `topBarPinnedTrailing` (SwiftUI) / `pinnedTrailingGroup` (UIKit)
  - Custom Back / Close: `ToolbarItem` with `cancellationAction` (SwiftUI) / `leadingItemGroups` (UIKit)
- Control inclusion in vertical layouts: `axisBehavior(_:)` (SwiftUI) / `axisBehavior` (UIKit)
- Control overflow order: `visibilityPriority(_:)` (SwiftUI) / `visibilityPriority` (UIKit)
- Put items directly in the overflow menu: `ToolbarOverflowMenu` (SwiftUI) / `additionalOverflowItems` (UIKit)
- **Icon / title rules** (decide whether an item can go vertical):

| Presentation | What the system uses |
|---|---|
| Vertical | Icon only |
| Horizontal | Icon or title (prefers icon) |
| Overflow menu | Icon **and** title |
| Title only, no icon | **Not presented vertically** |
| Custom view (no title/icon) | **Not presented vertically** |

### ArrangementView in practice
- Split arrangement: side-by-side when the container is **wider than tall**; primary above secondary when **taller than wide**; auto-adapts to the folding region.
- Overlay arrangement: primary over secondary when there are no active division regions (closed or fully open); **when partially open**, primary goes in the trailing/bottom part and secondary in the leading/top part relative to the fold.
- Limit axes:
  - SwiftUI: `.arrangementViewStyle(.split.axes(.horizontal))`
  - UIKit: `arrangementVC.updateArrangement(.split.axes(.horizontal))`
- **Avoid placing an arrangement view inside a NavigationSplitView, List, ScrollView, or other container** that could make part of your view inaccessible.

### Reserved regions & camera occlusion APIs
- Custom views must identify two kinds of reserved regions:
  - **Division**: the folding region splits a large view into smaller views
  - **Occlusion**: hardware (a camera) covers content; the outer camera always occludes, the inner camera occludes when active
- Get the regions:
  - SwiftUI: `GeometryReader` → `GeometryProxy` → `reservedRegions(kind:options:layoutDirectionBehavior:)` returns an array of `ReservedRegion`
  - UIKit: `reservedRegions(kind:options:)` returns an array of `UIView.ReservedRegion`
- Inspect the frames and adjust your views accordingly.
- **Reserved regions can be active or inactive**: e.g., the fold region is active when partially open and inactive when fully open.

### Camera apps
- With AVKit / AVFoundation you can capture from the **outer display camera, inner display camera, and rear camera**.
- Opening, closing, and rotating can move your app to a different display, and the camera may face the opposite direction — choose cameras by **the direction they face** (*Choosing a camera by the direction it faces*).
- When fully open and capturing with the rear camera, you can show content on the outer display as well (*Registering a camera capture accessory on iPhone Duo*).

### SwiftUI / UIKit API reference

| Capability | SwiftUI | UIKit |
|---|---|---|
| Safe areas | `safeAreaInsets` | `safeAreaInsets` |
| Reserved regions (fold avoidance) | `ReservedRegion` | `UIView.ReservedRegion` |
| Query reserved regions | `GeometryProxy.reservedRegions(kind:options:layoutDirectionBehavior:)` | `UIView.reservedRegions(kind:options:)` |
| Split layout | `NavigationSplitView` | `UISplitViewController` |
| Arrangement container (split/overlay) | `ArrangementView` | `UIArrangementViewController` |
| Toolbar item visibility priority | `ToolbarItemVisibilityPriority` | `UIBarButtonItemVisibilityPriority` |
| Toolbar grouping | `ToolbarItemGroup` | `UIBarButtonItemGroup` |
| Vertical compression behavior | `ToolbarVerticalCompressionBehavior` | `UIVerticalBarCompressionBehavior` |
| System overflow menu | `ToolbarOverflowMenu` | `additionalOverflowItems` |
| Titled icon item | `Label` | `UIBarButtonItem` |
| Vertical bar behavior | `toolbarVerticalBehavior(_:)` | `preferredVerticalBarBehavior` |
| Sheet placement | `presentationPlacement(_:)` | `preferredPlacement` |
| Detect vertical bars | `toolbarVerticalEdge` (environment value) | `verticalBarEdge` (trait) |
| Background extension | `backgroundExtensionEffect()` | `UIBackgroundExtensionView` |
| Semantic placement / nav items | `ToolbarItemPlacement` · `cancellationAction` · `topBarPinnedTrailing` | `pinnedTrailingGroup` · `leadingItemGroups` |
| Axis behavior | `axisBehavior(_:)` | `axisBehavior` |
| Size-class tracking | `horizontalSizeClass` / `verticalSizeClass` (automatic trait tracking) | Same |

---

## Adaptation priorities (P0 / P1 / P2)

### P0 — Required before release (does it *work*?)
1. **Resizability**: size classes replace fixed widths/breakpoints; usable at any aspect ratio
2. **Layout margins + safe area insets** (content isn't hidden behind side controls)
3. **System components** (automatic side layout, overflow menu, fold avoidance)
4. **Consistent functionality/hierarchy/state** across displays (no pose-bound features)
5. **Fold avoidance**: interactive elements clear of the center when partially folded (system components or `ReservedRegion`)

### P1 — Important (is it *pleasant*?)
1. Inner-display strategy: Split View or two-column layout (don't just stretch)
2. Sheet behavior in all three poses (outer vertical / inner horizontal / folded slides away)
3. Overflow & compression: set visibility priorities to preserve high-frequency actions
4. Audit text buttons/segmented controls (wide controls stay in the horizontal bar)

### P2 — Enhancement (nice to have)
1. Tab Bar → Sidebar (information-dense apps)
2. Pose-specific layout for tabletop (media up, controls down, hands-free)
3. Full-screen centered immersive UI (e.g., Calculator)
4. Games: fill every pose + artwork padding

---

## Common mistakes

1. ❌ **A custom layout for each pose** → ✅ Target only compact / regular size classes
2. ❌ **Fixed widths / breakpoints** → ✅ Adaptive containers that expand naturally
3. ❌ **Functionality bound to a pose** → ✅ Users fold/unfold frequently; behavior must be consistent and predictable
4. ❌ **A custom overflow menu** → ✅ Use the system overflow menu; ellipsis reserved for overflow
5. ❌ **Manual fixed spacing** → ✅ Use `ToolbarItemGroup` for automatic spacing
6. ❌ **Moving everything away from the center when folded** → ✅ Scrollable content doesn't need to avoid it
7. ❌ **Moving text buttons to the side** → ✅ Wide controls stay in the horizontal nav bar
8. ❌ **Forcing side bars on inner portrait** → ✅ It's the only pose that keeps horizontal bars
9. ❌ **Inner display = stretched outer display** → ✅ Use Split View / two columns / sidebar
10. ❌ **Ignoring RTL** → ✅ Side controls align with hardware and stay on the same side
11. ❌ **Using `userInterfaceIdiom` / `UIInterfaceOrientation` for layout decisions** → ✅ Use size classes (automatic trait tracking)
12. ❌ **Building custom bars from UIToolbar / UINavigationBar / UITabBar** → ✅ Use navigation-container bar support
13. ❌ **Toolbar items with a title but no icon** → ✅ Provide icon + title, or the item can't go vertical
14. ❌ **Nesting ArrangementView inside NavigationSplitView / List / ScrollView** → ✅ Keep it outside those containers

---

## Resources & related videos

**Official docs**
- HIG — [Designing for iPhone Duo](https://developer.apple.com/design/human-interface-guidelines/designing-for-iphone-duo) (design guide, most comprehensive)
- Developer Docs — [Preparing your app for iPhone Duo](https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo) (implementation guide)
- [Apple Design Resources](https://developer.apple.com/design/resources/)
- Screenshot specifications (see HIG "Related")

**Related developer docs**
- TN3210 — Optimizing your app for iPhone Mirroring
- Automatic trait tracking
- Adopting Liquid Glass

**Tech Talks**
- [Design for iPhone Duo — Tech Talk 111466](https://developer.apple.com/videos/play/tech-talks/111466/)
- [Tech Talk 111462](https://developer.apple.com/videos/play/tech-talks/111462)
- [Tech Talk 111463](https://developer.apple.com/videos/play/tech-talks/111463)
- Raise the bar with iPhone Duo
- Strike a pose with adaptive layouts on iPhone Duo
- Prepare your app for iPhone Duo
- Leverage multiple displays and scenes on iPhone Duo
- Build a great camera experience for iPhone Duo
- Modernize your UIKit app
- Make your UIKit app more flexible

---

## Appendix: video chapter index

| Time | Chapter | Key points |
|---|---|---|
| 0:00 | Intro | Design principles behind the device |
| 0:28 | Poses & controls | Many poses; controls move to the side to maximize vertical space; content auto-moves away from the center when folded; Split View & PiP → support resizability |
| 3:42 | Size classes | Don't design per pose; target compact/regular; use layout margins & safe areas; pose-specific layouts must preserve functionality and hierarchy |
| 5:07 | Side controls | Toolbars/tab bars/controls on the side; share vertical space with Dynamic Island & status bar; collapse into overflow menu; wide controls are the exception |
| 6:33 | Content offset | Most content needs an offset (safe areas handle it); immersive non-scrolling UI can center full-screen; mix approaches (full-width background + inset content) |
| 7:34 | Inner display | Use the width: Split Views surface more hierarchy; rearrange into two-column layouts |
| 8:36 | Sheets | Outer: vertical controls; inner: horizontal bars; folded: slide over to avoid the fold |
| 9:28 | Fold avoidance | System components nudge interactive elements away from the center; scrollable content excepted |
| 10:01 | Wrap-up | Single experience across sizes and poses; side controls + resizability = at home on iPhone Duo |

---

*Sources: Apple Tech Talk 111466 transcript & Apple HIG "Designing for iPhone Duo" (September 2026). Chinese version: [iPhone-Duo-设计指南.md](./iPhone-Duo-设计指南.md).*
