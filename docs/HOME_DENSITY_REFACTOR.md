# 首页高密度中国商业风收紧重构 · 问题分析与修改策略

## 1️⃣ 问题分析

| 问题 | 表现 | 原因 |
|------|------|------|
| 顶部无卡通字体大标题 | Header 仅一句 22sp 标题，无副标题层级 | 未按示例做「主标题明显大于副标题」的层级 |
| 页面过于松散 | Section 上下 24px、Grid 行距 12、卡片间距 16 | 间距体系偏欧洲留白，未收紧 |
| 圆角过多过大 | Section 顶部 r32、卡片 14、搜索 30 | 中国商业风多用 12/14 卡片、无大块圆角容器 |
| Section 大圆角容器 | 绿/黄/蓝区顶部 32px 圆角 | 与「不要大圆角」冲突，分割感弱 |
| 边框和分割感弱 | 几乎无边框，仅靠色块区分 | 需要细分割线或浅灰底强化层级 |
| RenderFlex overflow | 横向 Row 内文字或芯片过长 | 未用 Flexible/Expanded + maxLines + ellipsis |
| 底部导航非卡通风 | 线型 outline/filled 混用、icon 26 | 需统一圆润图标、22-24、label 略粗 |
| 视觉密度不够 | 整体呼吸感强、信息密度低 | 间距、字号、padding 未整体收紧 |

---

## 2️⃣ 修改策略

### 第一部分：顶部标题
- Header 高度由 30% 改为 **25%-28%**（取 26%）。
- **主标题**：「新春首站之旅」→ 26sp、w800、letterSpacing 0.8、白字+阴影，maxLines 1 + ellipsis。
- **副标题**：「和享梦游一起出发」→ 12sp、白色 0.8 透明度、w400，弱化。
- 标题在插画左侧、不居中；Header padding 收紧为 12/6。

### 第二部分：整体间距收紧
- Section 上下间距约减 30%：使用常量 `_kSectionPadV=10`、`_kSectionGap=10`（原约 24）。
- Section 内 padding 水平/上：12、10。
- Grid 行间距：`_kGridRowGap=4`（原 12），icon 与 label 间距 4。
- 卡片间距：`_kCardGap=8`（原 16）。
- 去掉底部大留白：Sliver 底部 20。

### 第三部分：圆角
- Section 容器：**取消大圆角**，改为直角 + 顶部 0.5px 分割线。
- 卡片：统一 **12**（`_kCardRadius`）。
- 小标签/胶囊：保持 `BorderRadius.circular(999)`。
- 搜索框：**20**（`_kSearchRadius`），不再 30。
- Header 无圆角容器。

### 第四部分：分割感
- 每个 Section 顶部增加 `Border(top: BorderSide(color: AppColors.border, width: 0.5))`。
- 卡片增加轻微边框：`Border.all(color: AppColors.border.withValues(alpha: 0.6))`。
- 搜索框增加 0.5 边框。
- 底部导航顶部 0.5 分割线。

### 第五部分：Overflow 修复
- 所有可能超长的 **Text**：`maxLines: 1` + `overflow: TextOverflow.ellipsis`。
- 横向 **Row** 中占满剩余空间或可能被压缩的文案：包一层 **Expanded** 或 **Flexible**。
- 具体：推荐区标题「享梦游种草官」→ Expanded；周边活动标题行「查看全部>」→ Flexible；人物卡姓名 → Expanded；周边卡底部「 · 城市 · 星期」→ Expanded + ellipsis。
- 列表/横滑使用固定高度（如 118.h、176.h），内部卡片不写死会撑开的高度，用 AspectRatio 或固定图高。

### 第六部分：底部导航卡通风
- 图标统一为 **rounded**：home_rounded, groups_rounded, travel_explore_rounded, chat_bubble_rounded, person_rounded。
- 选中/未选同一 icon，用颜色区分：选中 **绿色**（primary），未选 **灰色**（textTertiary）。
- icon **24.sp**，栏高 **56**，label **10.sp**、选中 w700、未选 w500，maxLines 1 + ellipsis。
- 顶部细分割线、轻阴影。

### 第七部分：图标风格
- 首页 Grid 保持**扁平 + 颜色块背景**（已有），icon 22.sp，块圆角 10。
- 不做 3D、不改成欧美线型。

### 第八部分：密度目标
- 最终：更密、更实、更多内容感、少呼吸感，接近中国商业 App 示例。

---

## 3️⃣ 关键代码改动摘要

- **home_shell_page.dart**
  - 常量：`_kSectionPadH=12`, `_kSectionPadV=10`, `_kSectionGap=10`, `_kCardGap=8`, `_kGridRowGap=4`, `_kCardRadius=12`, `_kSearchRadius=20`, `_kHeaderHeightRatio=0.26`。
  - Header：heroHeight = screenHeight * 0.26；主标题 26.sp + letterSpacing；副标题 12.sp 弱化；padding 12/6。
  - Section：无 borderRadius，改为 `border: Border(top: ...)`；padding 12/10/12/10。
  - 所有标题 Row：Expanded/Flexible 包文字，避免 overflow。
  - 人物卡姓名、周边卡底部副文：Expanded + ellipsis。
  - 搜索框高度 44、圆角 20、细边框。
  - Grid icon 40.w、间距 4、label 10.sp。
  - 亲子/周边列表高度略减（118、176），卡片间距 8。
- **app_shell.dart**
  - 底部导航：Icons.*_rounded，24.sp，选中 primary、未选 textTertiary，高度 56，label 10.sp、w700/w500，顶部 border。

---

## 4️⃣ 执行结果

- 已完成：完整替换 `home_shell_page.dart`，并更新 `app_shell.dart` 底部导航。
- 业务逻辑与功能未删未改；仅做 UI 精修与 overflow 修复。
