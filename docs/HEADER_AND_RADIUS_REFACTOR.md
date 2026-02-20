# Header 完整插画场景 + 全局圆角优化

## 一、Header 结构说明

### 层级（自底向上）

1. **背景层**  
   - AI 插画全屏 **cover** 铺满，无渐变、无小 icon。  
   - 数据源：`kHomeHeaderSceneUrl` 优先，为空则用 `kHomeHeaderCartoonUrl`；都为空则红橙渐变占位。  
   - 支持：网络 URL、本地 `assets/` 路径。

2. **底部轻微渐变**  
   - 高度约 Header 的 45%，自下而上：透明 → 半透明黑。  
   - 仅用于保证标题可读，不覆盖插画主体。

3. **前景：标题**  
   - 位置：左侧偏中（`Alignment.centerLeft` + 底部 padding 24）。  
   - 主标题：两行，36sp / 40sp，黄色 `#FFE066`，站酷酷黑 w900，深色描边/阴影（`_kHeaderShadowDark`）。  
   - 副标题：14sp，浅米白 `#FFFBF0`，小一号，位于主标题下方。

4. **最上层：搜索栏**  
   - 白色悬浮胶囊，顶部 SafeArea + 8dp padding，圆角 24dp。

### 尺寸与常量

- **Header 高度**：固定 **260dp**（`_kHeaderHeightDp`），约 240–280dp 范围内。  
- **搜索栏圆角**：`_kSearchRadius = 24`。  
- **标题颜色**：`_kHeaderTitleYellow`、`_kHeaderSubtitleWhite`、`_kHeaderShadowDark`。

### 使用插画

在 `lib/features/home/data/home_mock_data.dart` 中设置：

- `kHomeHeaderSceneUrl = 'https://...'` 或 `kHomeHeaderSceneUrl = 'assets/images/header_scene.png'`  
- 或 `kHomeHeaderCartoonUrl = '...'`（当 Scene 为空时使用）

图片会以 **BoxFit.cover** 铺满 Header，不拉伸、不简单渐变覆盖、不额外裁剪。

---

## 二、修改后的全局样式系统说明

### 圆角（AppRadius）

- **卡片 / 内容块**：12–14dp（`AppRadius.card = 12`，`r24 = 14`）。  
- **按钮**：10–12dp（`large = 10`，大按钮用 12）。  
- **标签**：保持胶囊型（`full`），padding 可略缩小。  
- **搜索栏**：14dp（设计系统）/ 首页 24dp（`_kSearchRadius`）。  
- **底部导航**：InkWell 圆角 6dp，减少厚重感。

### 卡片统一规则

- 圆角：首页 `_kCardRadius = 12`，海报卡 `_kPosterCardRadius = 14`。  
- 阴影：沿用 `AppShadow.light` / `card`。  
- 图片：**cover**，不拉伸。  
- 图片下方：轻微渐变遮罩（已有海报卡实现）。

### 视觉目标

- 更精致、更现代、更商业。  
- 减少“demo UI”感，统一卡片圆角与阴影。

---

## 三、更新后的样式变量（摘录）

| 变量 | 位置 | 值 |
|------|------|-----|
| `_kHeaderHeightDp` | home_shell_page | 260 |
| `_kCardRadius` | home_shell_page | 12 |
| `_kPosterCardRadius` | home_shell_page | 14 |
| `_kSearchRadius` | home_shell_page | 24 |
| `_kHeaderTitleYellow` | home_shell_page | 0xFFFFE066 |
| `_kHeaderSubtitleWhite` | home_shell_page | 0xFFFFFBF0 |
| `_kHeaderShadowDark` | home_shell_page | 0xFF4A0000 |
| `AppRadius.card` | app_radius | 12 |
| `AppRadius.large` | app_radius | 10 |
| `AppRadius.r16`–`r32` | app_radius | 12–14 |
| 底部导航 InkWell | app_shell | 6 |

---

## 四、可替换代码位置

- **Header 主体**：`lib/features/home/presentation/pages/home_shell_page.dart`  
  - `_HomeHeader`、`_HeaderBackgroundImage`、`_headerTitleStyle`、`_headerSubtitleStyle`、`_HomeSearchBarCapsule`。  
- **Header 数据**：`lib/features/home/data/home_mock_data.dart`  
  - `kHomeHeaderSceneUrl`、`kHomeHeaderCartoonUrl`、标题/副标题文案。  
- **全局圆角**：`lib/shared/design_system/app_radius.dart`。  
- **底部导航圆角**：`lib/core/router/app_shell.dart`（InkWell 6）。  
- **列表页海报圆角**：`child_activity_list_page.dart`、`nearby_activity_list_page.dart`（_kPosterRadius = 14）；`seed_list_page.dart`（_kCardRadius = 12）。
