# Header 图片加载与层级说明（工程级）

**禁止使用**：风景摄影、山脉照片、Unsplash 随机图、真实场景照片。  
**仅允许**：Q 版插画（AI 生成 URL / 本地 asset）或代码绘制的春节旅行 Q 版占位。

## 一、Header 结构说明（纯插画 + 可交互搜索栏）

**约定**：插画内已含标题和搜索框视觉，代码不再渲染标题，仅保留真实可点击搜索栏并精准覆盖插画中的搜索栏位置。

```
HeaderContainer (relative, height: 260dp)
└── Stack (fit: expand)
    ├── zIndex 1  BackgroundImage  Positioned(top/left/right/bottom: 0), BoxFit.cover，图片铺满 Header
    └── zIndex 3  RealSearchBar    Positioned(left: 16, right: 16, top: SafeArea + 52)，完全覆盖插画中的假搜索栏
```

- **禁止**：再创建 Text 标题、副标题或任何叠加文字。
- **BackgroundImage**：absolute fill，resizeMode: cover，高度 260dp 左右，不裁切异常。
- **RealSearchBar**：absolute，left/right 16dp，top 根据插画微调（例如 48–60dp），zIndex 高于图片，让用户只看到真实搜索栏。

## 二、删除说明（结构修正时已做）

- 已删除：Header 内所有 **Text 标题组件**（kHomeHeaderTitleLine1、kHomeHeaderTitleLine2）。
- 已删除：**副标题组件**（kHomeHeaderSubtitle）。
- 已删除：底部渐变 overlay（标题可读用），Header 现为纯插画 + 搜索栏。
- 已删除：`_headerTitleStyle`、`_headerSubtitleStyle` 及仅用于标题的颜色常量。

## 三、z-index 层级（Flutter Stack 绘制顺序）

| 顺序 | 组件 | 说明 |
|------|------|------|
| 1 | BackgroundImage | 最先绘制，zIndex 1 |
| 2 | RealSearchBar | 最后绘制，zIndex 3，完全覆盖插画中的搜索栏区域 |

## 四、搜索栏定位参数（可按插画微调）

| 常量 | 值 | 说明 |
|------|------|------|
| `_kHeaderSearchBarInsetTop` | 52 | 距 SafeArea 顶部的距离（建议 48–60dp） |
| `_kHeaderSearchBarInsetLeft` | 16 | 左边距 dp |
| `_kHeaderSearchBarInsetRight` | 16 | 右边距 dp |

位置：`Positioned(left: 16, right: 16, top: MediaQuery.paddingOf(context).top + 52)`，使真实搜索栏完全覆盖插画中的搜索栏。

## 五、插画加载逻辑（禁止摄影图）

- **数据源**（优先级从高到低）：
  1. `kHomeHeaderSceneUrl`（不为空时）
  2. `kHomeHeaderCartoonUrl`（scene 为空时）
  3. `kHomeHeaderBackgroundUrl`（前两者都为空时）

- **_HeaderBackgroundImage**（仅插画，禁止风景照片）：
  - 入参：上述逻辑得到的 `effectiveUrl`。
  - **若最终 URL 为空**：显示 **`_HeaderCartoonPlaceholder()`**（代码绘制的 Q 版春节旅行占位：红橙暖色、小人背背包、塔、路径、烟花），**不再使用任何照片或纯渐变**。
  - `url.startsWith('assets/')` → `Image.asset(url, fit: BoxFit.cover, ...)`，错误时 `_HeaderCartoonPlaceholder()`。
  - 否则 → `AppNetworkImage(imageUrl: url, fit: BoxFit.cover, ...)`，错误时 `_HeaderCartoonPlaceholder()`。

## 六、插画生成与接入方式

- **方式一（推荐）**：使用 **AI 图像生成 API**（如 DALL·E、Midjourney、Stable Diffusion 等）生成「Q 版、中国春节旅行、可爱人物、骑马/背包、塔/地图/烟花、暖色红橙、商业海报级」插画，将返回的 **URL** 赋给 `kHomeHeaderSceneUrl` 或 `kHomeHeaderCartoonUrl`（或通过后端接口下发）。
- **方式二**：提前生成插画并保存为 **本地 asset**（如 `assets/images/header_cartoon.png`），在 `home_mock_data.dart` 中设置 `kHomeHeaderSceneUrl = 'assets/images/header_cartoon.png'`。
- **留空时**：不显示照片；显示代码绘制的 **Q 版占位**（`_HeaderCartoonPlaceholder`），保证界面始终为插画风格。

## 七、子卡片图片逻辑（亲子 / 周边活动）

- **亲子活动**（`_FamilyMiniPosterCard`）：
  - 结构：Card(Stack) → Image(cover) → Positioned 底部 → Container(渐变 + 标题 + 城市 tag) → Positioned 角标(推荐/HOT)。
  - 图片：`AppNetworkImage(item.imageUrl, fit: BoxFit.cover)`，数据来自 `kHomeFamilyActivities`，为真实可加载 URL。
- **周边活动**（`_CardTypeC`）：
  - 结构：Card(Stack) → Image(cover) → 可选 HOT Positioned → Positioned 底部 → Container(渐变 + 标题 + 日期·城市)。
  - 图片：`AppNetworkImage(item.imageUrl, fit: BoxFit.cover)`，数据来自 `kHomeAroundActivities`。
- 所有卡片：图片铺满、cover、底部渐变遮罩、标题叠加在遮罩上；亲子带 Badge，周边带热门标签。

## 八、可替换代码位置（最终可替换代码）

- **Header 整体**：`lib/features/home/presentation/pages/home_shell_page.dart`  
  - `_HomeHeader`：Stack 仅两层 — z1 `_HeaderBackgroundImage`（Positioned fill, cover）、z3 `_HomeSearchBarCapsule`（Positioned 覆盖插画搜索栏）。无标题、无 overlay。  
  - `_HeaderBackgroundImage`、`_HeaderCartoonPlaceholder` / `_HeaderCartoonPlaceholderPainter`。
- **Header 数据与默认 URL**：`lib/features/home/data/home_mock_data.dart`  
  - `kHomeHeaderSceneUrl`、`kHomeHeaderCartoonUrl`、`kHomeHeaderBackgroundUrl`（留空则使用代码绘制的 Q 版占位；若配置则为插画 URL 或 asset，禁止摄影图）。
- **亲子/周边卡片**：同文件内 `_FamilyMiniPosterCard`、`_CardTypeC`；图片数据同上 mock 文件。
