# 凌行天下旅行 · 中国旅行 App

Flutter 中国旅行类应用，支持精选线路、酒店预订、订单、旅游社区、结伴、消息与个人中心等模块，采用功能模块化架构与统一设计系统（中国旅行风）。

---

## 技术栈

| 类别     | 技术 |
|----------|------|
| 框架     | Flutter 3.x，Dart 3.x |
| 状态管理 | flutter_riverpod |
| 路由     | go_router（含 StatefulShell 底部 5 Tab） |
| 网络     | dio |
| 本地存储 | shared_preferences、flutter_secure_storage（Token） |
| UI 适配  | flutter_screenutil |
| 国际化   | Flutter l10n（中/英） |
| 其他     | cached_network_image、shimmer、easy_refresh、logger |

---

## 项目架构说明

### 目录结构

```
lib/
├── main.dart                 # 入口，ProviderScope + AppInitializer
├── app.dart                  # MaterialApp.router、主题、国际化、ScreenUtil
├── core/                     # 核心层：主题、路由、网络、国际化与常量
│   ├── constants/            # 应用常量
│   ├── locale/               # 语言 Provider
│   ├── network/              # Dio 客户端
│   ├── router/               # go_router 配置、壳页、转场
│   └── theme/                # AppTheme
├── features/                 # 功能模块（按业务垂直拆分）
│   ├── auth/                 # 登录、注册、验证码、忘记密码、实名
│   ├── chat/                 # 消息列表、会话
│   ├── companions/           # 结伴游（详情、下单）
│   ├── content/              # 旅游社区（论坛列表、文章）
│   ├── home/                 # 首页入口
│   ├── hotels/               # 酒店列表、详情、预订
│   ├── orders/               # 订单列表、详情、支付
│   ├── profile/              # 个人中心、设置
│   └── tours/                # 旅行团列表、详情、下单
├── l10n/                     # 生成与手写的中英文案
└── shared/                   # 跨模块共享
    ├── design_system/         # 色彩、字体、阴影、卡片、按钮、渐变等
    └── widgets/              # 通用组件：加载、空态、错误、网络图等
```

### 分层与数据流

- **展示层（presentation）**：Page、Widget，通过 Riverpod 消费状态或直接调用 Repository/数据层。
- **数据层（data）**：Repository（如 `AuthRepository`）、Mock 数据（如 `tour_list_mock.dart`、`forum_list_mock.dart`）。对接后端时在此层将 Mock 替换为 Dio 请求。
- **领域层（domain）**：实体与值对象（如 `TourItem`、`OrderItem`、`ForumPost`），与 UI 和接口解耦。

数据流简要：**UI → Provider / 直接调用 → Repository → (Dio) → 后端**；Token 由 `TokenStorage` 持久化，`AuthRepository` 负责登录/登出与持久化。

### 路由与壳页

- **根路由**：`go_router`，`initialLocation: '/home'`，支持未登录重定向到 `/auth/login`。
- **底部 5 Tab**：通过 `StatefulShellRoute.indexedStack` 实现，分支对应 home、joinUs、planner、messages、profile。
- **子路由**：如 `/tours`、`/tours/:id`、`/tours/:id/order`、`/hotels`、`/orders`、`/article/:id`、`/payment`、`/companions/:id`、`/verify-name` 等；错误页 `/error`、`/network-error` 用于统一错误展示。

---

## 模块说明

| 模块        | 路径 | 说明 |
|-------------|------|------|
| **core**    | `lib/core/` | 主题、路由、Dio、语言 Provider、常量；与具体业务无强耦合。 |
| **shared**  | `lib/shared/` | 设计系统（颜色、字体、阴影、圆角、间距、卡片、按钮、标签、渐变背景、骨架屏等）与通用 UI（加载、空态、错误页、网络图）。 |
| **auth**    | `lib/features/auth/` | 登录（密码/验证码）、注册、忘记密码、用户协议、实名认证；`AuthRepository` + `TokenStorage`，Provider 驱动登录态与重定向。 |
| **home**    | `lib/features/home/` | 首页壳页，入口卡片跳转旅行团、酒店、订单；使用统一渐变背景与卡片样式。 |
| **tours**   | `lib/features/tours/` | 旅行团列表（筛选）、详情、下单；domain：`TourItem`/`TourDetail`；data：mock 列表与详情。 |
| **hotels**  | `lib/features/hotels/` | 酒店列表（筛选）、详情、预订；domain：`HotelItem`/`HotelDetail`；data：mock。 |
| **orders**  | `lib/features/orders/` | 订单列表（Tab：全部/待付款/待出行/已完成/退款）、订单详情、支付页；data：mock 列表与详情。 |
| **content** | `lib/features/content/` | 旅游社区：论坛列表、文章详情；domain：`ForumPost`/`ForumPostDetail`；data：mock。 |
| **companions** | `lib/features/companions/` | 结伴游：详情、套餐、下单；domain：`CompanionDetail`/`CompanionOrder`；data：mock。 |
| **chat**    | `lib/features/chat/` | 消息列表、会话页；domain：`ChatListItem`/`ChatMessage`；data：mock。 |
| **profile** | `lib/features/profile/` | 个人中心（头像、实名状态、订单/收藏/钱包/优惠券/消息/设置）、设置（语言切换）、实名认证页。 |

---

## 如何接入后端

### 1. 配置基础 URL 与 Dio 拦截器

- 在 **`lib/core/constants/app_constants.dart`** 中增加例如：
  - `static const String apiBaseUrl = 'https://your-api.com';`
- 在 **`lib/core/network/dio_client.dart`** 中：
  - 使用 `BaseOptions(baseUrl: AppConstants.apiBaseUrl)`。
  - 在拦截器中从 `TokenStorage` 或 AuthProvider 读取 Token，写入 Header：`Authorization: Bearer <token>`。
  - 统一处理 401（清除 Token、跳转登录）和业务错误码（可转成异常或 Result 类型）。

### 2. 认证接口对接

- **`lib/features/auth/data/auth_repository.dart`** 中：
  - `loginByPassword` / `loginByCode` / `register` / `sendCode` / `resetPassword` 改为使用 `Dio` 调用后端接口。
  - 接口返回的 token、expiry 通过现有 `persistAuth` 写入 `TokenStorage`。
  - 登出可增加“调用后端登出接口”再执行 `_tokenStorage.clear()`。

### 3. 业务接口对接（以旅行团为例）

- 定义 API 路径常量（可放在 `core/constants` 或各 feature 的 `data` 下）。
- 在 **`lib/features/tours/data/`** 中：
  - 新增或改造为 `tour_repository.dart`，注入 `Dio`，提供如 `getTourList(TourFilters filters)`、`getTourDetail(String id)`。
  - 将接口返回的 JSON 映射为已有的 **domain** 模型（`TourItem`、`TourDetail`）。
- 列表/详情页改为通过 **Provider** 调用 Repository（例如 `FutureProvider`、`StateNotifierProvider`），不再直接引用 `tour_list_mock.dart`。

其他模块（酒店、订单、论坛、结伴、消息）同理：在对应 `data` 层增加或改造 Repository，用 Dio 请求替换 Mock，保持 **domain** 不变，UI 仅依赖 domain 与 Provider。

### 4. 错误与加载态

- 网络/业务错误可统一在 Dio 拦截器中处理，必要时跳转 `AppNetworkErrorPage` 或 `AppErrorPage`（路由已配置）。
- 列表页已有空态与加载态（如论坛骨架屏）；接入后端后可在 Provider 中区分 loading / data / error，页面按状态渲染。

---

## 如何扩展功能

### 新增功能模块（Feature）

1. 在 **`lib/features/`** 下新建目录，如 `lib/features/activity/`。
2. 按需建立子目录：
   - **domain/**：实体、值对象（如 `ActivityItem`）。
   - **data/**：Repository、Mock 或 API 实现。
   - **presentation/pages/**：页面；**presentation/widgets/**：该模块专用组件。
   - 若需全局状态，可加 **providers/**。
3. 在 **`lib/core/router/app_router.dart`** 中注册路由（如 `/activity`、`/activity/:id`），并在首页或壳页中增加入口（如卡片、Tab）。

### 新增页面或子路由

- 在 **`app_router.dart`** 的 `routes` 中增加 `GoRoute`，指定 `path`、`name`、`pageBuilder`；若需转场，使用已有的 `slideTransitionPage` / `fadeTransitionPage`。
- 需要底部 Tab 时，在 `StatefulShellRoute.indexedStack` 的 `branches` 中增加一栏并在 **`app_shell.dart`** 的 `destinations` 与 `_onTap` 的 `paths` 中同步增加一项。

### 设计系统与 UI 规范

- **颜色**：在 **`lib/shared/design_system/app_colors.dart`** 中扩展；页面与卡片尽量使用语义化常量（如 `AppColors.primary`、`AppColors.background`）。
- **字体**：**`app_text_styles.dart`** 中增加或复用 `headlineMedium`、`bodyLarge` 等。
- **阴影 / 圆角 / 间距**：**`app_shadow.dart`**、**`app_radius.dart`**、**`app_spacing.dart`**；卡片统一用 **`AppCard`**，需要渐变背景时用 **`AppGradientBackground`**（如 `pageGradient`）。
- **新通用组件**：放在 **`lib/shared/widgets/`**，必要时在 **`lib/shared/shared.dart`** 中 export。

### 国际化

- 在 **`lib/l10n/`** 的 arb 或手写文案中增加 key，运行 Flutter 的 l10n 生成（若使用生成）；在页面中通过 `AppLocalizations.of(context)?.key` 使用。

---

## 运行与构建

```bash
# 安装依赖
flutter pub get

# 运行（调试）
flutter run

# 性能分析（Profile 模式，用于测试滚动、动画、无 Jank）
flutter run --profile

# 构建 Release
flutter build apk
flutter build ios
flutter build web
```

当前数据以 Mock 为主，登录为本地模拟；接入真实后端后，按上文「如何接入后端」替换各模块的 data 层即可。
