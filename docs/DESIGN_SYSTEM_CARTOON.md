# 中国卡通商业风 · 设计系统

全应用 UI 升级为**中国卡通风格商业旅行 App** 的单一事实来源。  
实现见：`lib/shared/design_system/` 与 `lib/core/theme/app_theme.dart`。

---

## 设计方向

- **Colorful** — 色彩丰富
- **Image-rich** — 图片丰富
- **Dense but organized** — 信息密度高但结构清晰
- **Layered cards** — 分层卡片
- **Soft shadows** — 软阴影
- **Large rounded corners** — 大圆角
- **Gradient backgrounds** — 渐变背景
- **Emotion-driven** — 情感化设计
- **Not minimal** — 非极简
- **Not Apple / western SaaS** — 非苹果/西方 SaaS 风格

---

## 1️⃣ 全局圆角规则 (AppRadius)

| 用途 | 数值 | Token |
|------|------|--------|
| 主卡片、内容块 | 24–28 | `AppRadius.card` (26) |
| 头部底部曲线 | 32–40 | `AppRadius.headerBottom` (36) |
| 胶囊/标签/Pill | 20–24 | `AppRadius.pill` (22) |
| 主按钮、CTA | 24–28 | `AppRadius.button` (26) |
| 头像、图标按钮 | 全圆 | `AppRadius.avatar` (9999) |
| Sheet 顶部 | 28 | `AppRadius.sheetTop` |
| 输入框 | 20 | `AppRadius.input` |

使用方式：`BorderRadius: AppRadius.cardRadius`, `AppRadius.pillRadius`, `AppRadius.buttonRadius`, `AppRadius.headerBottomRadius` 等。

---

## 2️⃣ 阴影系统 (AppShadow)

- **仅软阴影**，无硬边框
- 阴影色**略带主题色 tint**
- **Blur**: 20–30
- **Y offset**: 8–12

| Token | 用途 |
|-------|------|
| `AppShadow.light` / `card` | 默认卡片、列表项 |
| `AppShadow.cardElevated` | 卡片立体感 |
| `AppShadow.medium` / `cardHover` / `floating` | 悬浮卡片、按钮、选中态 |
| `AppShadow.heavy` | 弹窗、Sheet |

禁止：大面积硬边框、纯黑重阴影。

---

## 3️⃣ 间距系统 (AppSpacing)

紧凑间距：

| Token | 数值 | 用途 |
|-------|------|------|
| `sectionGap` | 20 | 区块/模块间 |
| `cardPadding` / `paddingCard` | 16 | 卡片内边距、页面水平边距 |
| `pillGap` | 10 | 胶囊/标签之间 (8–12) |
| `pageHorizontal` | 16 | 页面左右边距 |

基础阶梯：`xs` 4 / `sm` 8 / `md` 12 / `lg` 16 / `xl` 20 / `xxl` 24。

---

## 4️⃣ 字体系统 (Typography) · 毛笔风格

- **标题字体** — Ma Shan Zheng（马善政毛笔体），毛笔书法风格，独特醒目
- **正文** — Noto Sans SC，保证长文可读性
- **标题层级**：Display 32px / H2 24px / H3 20px / H4 18px / H5 16px / H6 15px
- **使用**：`AppTextStyles.display`、`headlineLarge`、`headlineMedium`、`headlineSmall`、`TravelTypography.title`、`sectionTitle`

---

## 5️⃣ 渐变使用 (AppGradients)

渐变用于：

- **Headers** — `AppGradients.brand`, `hotelHeaderWarm`, `companionHeader` 等
- **CTA 按钮** — `AppGradients.ctaButton` / `brand`
- **Active tabs** — `AppGradients.activeTab`
- **价格文案** — `AppGradients.price`
- **选中底部导航** — `AppGradients.selectedNav`

---

## 6️⃣ 避免

- 纯白扁平布局
- 到处细边框
- 过多留白

---

## 文件索引

| 文件 | 职责 |
|------|------|
| `app_radius.dart` | 圆角常量与 BorderRadius getters |
| `app_shadow.dart` | 软阴影、主题色 tint |
| `app_spacing.dart` | 间距与 padding |
| `app_gradients.dart` | 渐变色列表与 stops |
| `app_text_styles.dart` | 标题/正文字体（ZCOOL KuaiLe 卡通风格） |
| `travel_typography.dart` | Travel 模块字体 |
| `app_colors.dart` | 颜色系统 |
| `app_theme.dart` | ThemeData（Card/Button/Input/Nav 等） |
| `app_card.dart` | 统一卡片（cardRadius + cardElevated/cardHover） |
| `app_button.dart` | 主/次按钮（buttonRadius + floating shadow） |
| `app_tag.dart` / `tag_pill.dart` | 标签、胶囊（pillRadius） |
| `travel_design_tokens.dart` | Travel 组件用 token（对齐本系统） |

新页面与组件应优先使用上述 token，保证全应用风格统一。
