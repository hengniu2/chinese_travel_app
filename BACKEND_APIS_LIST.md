# Backend APIs (travel_china_api) – Full List & How to Verify

These are the **real** APIs implemented in the **travel_china_api** backend project. The Flutter app calls them using the same base URL (e.g. `https://travel-china-api.onrender.com` + path). There is no “test API” – the app either calls these backend endpoints or uses mock data.

**Base URL:** From `lib/core/constants/app_constants.dart`:  
`apiBaseUrl` = `https://travel-china-api.onrender.com` (or override with `--dart-define=API_BASE_URL=...`)  
**Prefix:** `/api`  
So full URL example: `https://travel-china-api.onrender.com/api/auth/login`

**Auth:** For “Auth required” endpoints, send header:  
`Authorization: Bearer <access_token>`  
Get `access_token` from `POST /api/auth/login` (body: `phone_number`, `password`).

---

## 1. Auth (`/api/auth`)

| Method | Path | Auth | Body / Query | Response | How to verify |
|--------|------|------|--------------|----------|----------------|
| POST | `/api/auth/register` | No | `{ "role": "CUSTOMER", "phone_number": "...", "password": "..." }` | 201 `{ message, data: { user, ... } }` | App: Register screen → submit. Or Postman: POST body as above. |
| POST | `/api/auth/send-phone-code` | No | `{ "phone_number": "..." }` | 200 | App: Verify-phone screen → “获取验证码”. Or Postman. |
| POST | `/api/auth/verify-phone` | No | `{ "phone_number": "...", "code": "..." }` | 200 | App: Verify-phone screen → enter code → 验证. Or Postman. |
| POST | `/api/auth/login` | No | `{ "phone_number": "...", "password": "..." }` | 200 `{ data: { access_token, refresh_token, user } }` | App: Login screen → submit. Or Postman → copy `access_token` for other APIs. |
| POST | `/api/auth/refresh` | No | `{ "refresh_token": "..." }` | 200 `{ data: { access_token, refresh_token } }` | App: happens automatically on 401. Or Postman. |
| GET | `/api/auth/me` | Yes | — | 200 `{ data: user }` | Postman: GET with `Authorization: Bearer <token>`. |
| POST | `/api/auth/logout` | Yes | — | 200 | App: Logout. Or Postman with Bearer. |

---

## 2. Catalog (`/api/catalog`) – no auth

| Method | Path | Query (optional) | Response | How to verify |
|--------|------|------------------|----------|----------------|
| GET | `/api/catalog/routes` | `page`, `pageSize` | 200 `{ data: { items, total, page, pageSize } }` | App: Profile → Test APIs → “GET Routes list”. Or Postman: GET. |
| GET | `/api/catalog/routes/:id` | — | 200 `{ data: route }` | Postman: GET with valid route id. |
| GET | `/api/catalog/packages` | `page`, `pageSize`, `route_id`, `min_price`, `max_price`, `min_days`, `max_days`, `region`, `sort` | 200 `{ data: { items, total, page, pageSize } }` | App: **Tours** list screen (real API). Or Postman. |
| GET | `/api/catalog/packages/:id` | — | 200 `{ data: package }` | App: **Tours** list → tap a tour → detail (real API). Or Postman. |
| GET | `/api/catalog/companions` | `page`, `pageSize`, `skills[]`, `languages[]`, `interests[]`, `location`, `min_rate`, `max_rate` | 200 `{ data: { items, total, page, pageSize } }` | App: Profile → Test APIs → “GET Companions list”. Or Postman. |
| GET | `/api/catalog/companions/:id` | — | 200 `{ data: companion }` | Postman: GET with companion user id. |
| GET | `/api/catalog/companions/:id/availability` | `from` (ISO date), `to` (ISO date) | 200 `{ data: slots[] }` | Postman: GET with companion id, optional from/to. |
| GET | `/api/catalog/companions/:id/reviews` | `page`, `pageSize` | 200 `{ data: { items, total, page, pageSize } }` | Postman: GET. |
| GET | `/api/catalog/companions/:id/rating` | — | 200 `{ data: { average, count } }` | Postman: GET. |
| GET | `/api/catalog/hotels` | `page`, `pageSize`, `city`, `min_price`, `max_price`, `min_star`, `sort` | 200 `{ data: { items, total, page, pageSize } }` | App: Profile → Test APIs → “GET Hotels list”. Or Postman. |
| GET | `/api/catalog/hotels/:id` | — | 200 `{ data: hotel }` | Postman: GET. |
| GET | `/api/catalog/tickets` | `page`, `pageSize`, `location`, `min_price`, `max_price`, `ticket_type`, `sort` | 200 `{ data: { items, total, page, pageSize } }` | App: Profile → Test APIs → “GET Tickets list”. Or Postman. |
| GET | `/api/catalog/tickets/:id` | — | 200 `{ data: ticket }` | Postman: GET. |
| GET | `/api/catalog/insurance` | `page`, `pageSize`, `insurance_type`, `min_price`, `max_price`, `sort` | 200 `{ data: { items, total, page, pageSize } }` | App: Profile → Test APIs → “GET Insurance list”. Or Postman. |
| GET | `/api/catalog/insurance/:id` | — | 200 `{ data: insurance }` | Postman: GET. |

---

## 3. Customer profile (`/api/customer`) – auth required (CUSTOMER or ADMIN)

| Method | Path | Auth | Body | Response | How to verify |
|--------|------|------|------|----------|----------------|
| GET | `/api/customer/profile` | Yes | — | 200 `{ data: { user_id, display_name, avatar_url, contact_email, ... } }` | App: Profile → Test APIs → “GET my profile” (after login). Or Postman: GET + Bearer. |
| PATCH | `/api/customer/profile` | Yes (CUSTOMER) | `{ "display_name"?, "avatar_url"?, "contact_email"? }` | 200 `{ data: profile }` | App: Profile → Test APIs → “PATCH profile (name)” (after login). Or Postman: PATCH + Bearer. |

---

## 4. Orders (`/api/orders`) – auth required (CUSTOMER for create/list/update/delete/confirm/agreement)

| Method | Path | Auth | Body / Query | Response | How to verify |
|--------|------|------|--------------|----------|----------------|
| POST | `/api/orders` | Yes (CUSTOMER) | Body: `{ "items": [ { "item_type", "ref_id", "quantity", "unit_price"?, "title"? } ], "payment_method", "companion_id"?, "itinerary_id"?, "notes"? }`  
`item_type`: PACKAGE \| COMPANION \| HOTEL \| TICKET \| INSURANCE  
`payment_method`: WECHAT \| ALIPAY \| CARD \| WALLET | 201 `{ data: order }` | Postman: POST with valid package/hotel/etc. id in items. |
| GET | `/api/orders` | Yes (CUSTOMER) | Query: `page`, `pageSize`, `itinerary_id`? | 200 `{ data: { items, total, page, pageSize } }` | App: Profile → Test APIs → “GET my orders list” (after login). Or Postman: GET + Bearer. |
| GET | `/api/orders/:id` | Yes | — | 200 `{ data: order }` | Postman: GET + Bearer with order id. |
| PATCH | `/api/orders/:id` | Yes (CUSTOMER) | `{ "items"?, "notes"?, "companion_id"? }` | 200 `{ data: order }` | Postman: PATCH + Bearer. |
| DELETE | `/api/orders/:id` | Yes (CUSTOMER) | — | 200 `{ data: order }` | Postman: DELETE + Bearer. |
| POST | `/api/orders/:id/confirm-payment` | Yes (CUSTOMER) | `{ "external_id"?: string }` | 200 `{ data: order }` | Postman: POST + Bearer. |
| POST | `/api/orders/:id/agreement` | Yes (CUSTOMER) | — | 201 `{ data: agreement }` | Postman: POST + Bearer. |
| GET | `/api/orders/:id/agreement` | Yes (CUSTOMER) | — | 200 `{ data: agreement }` or 404 | Postman: GET + Bearer. |

---

## 5. Itineraries (`/api/itineraries`) – auth required (CUSTOMER)

| Method | Path | Auth | Body / Query | Response | How to verify |
|--------|------|------|--------------|----------|----------------|
| POST | `/api/itineraries` | Yes | Body: `{ "name"?, "start_date"?, "end_date"?, "status"? }` (dates ISO string) | 201 `{ data: itinerary }` | App: Profile → Test APIs → “POST create itinerary” (after login). Or Postman: POST + Bearer. |
| GET | `/api/itineraries` | Yes | Query: `page`, `pageSize` | 200 `{ data: { items, total, page, pageSize } }` | App: Profile → Test APIs → “GET my itineraries”. Or Postman: GET + Bearer. |
| GET | `/api/itineraries/:id` | Yes | — | 200 `{ data: itinerary }` | Postman: GET + Bearer. |
| PATCH | `/api/itineraries/:id` | Yes | `{ "name"?, "start_date"?, "end_date"?, "status"? }` | 200 `{ data: itinerary }` | Postman: PATCH + Bearer. |
| DELETE | `/api/itineraries/:id` | Yes | — | 204 | Postman: DELETE + Bearer. |

---

## 6. Reviews (`/api/reviews`) – auth required (CUSTOMER)

| Method | Path | Auth | Body / Query | Response | How to verify |
|--------|------|------|--------------|----------|----------------|
| POST | `/api/reviews` | Yes (CUSTOMER) | Body: `{ "target_type", "target_id", "order_id"?, "rating", "content"? }`  
`target_type`: COMPANION \| MERCHANT \| PACKAGE \| HOTEL \| TICKET | 201 `{ data: review }` | Postman: POST + Bearer with valid target_id. |
| GET | `/api/reviews` | Yes | Query: `page`, `pageSize` (list **my** reviews) | 200 `{ data: { items, total, page, pageSize } }` | App: Profile → Test APIs → “GET my reviews” (after login). Or Postman: GET + Bearer. |

---

## 7. Chat (`/api/chat`) – auth required

| Method | Path | Auth | Body / Query | Response | How to verify |
|--------|------|------|--------------|----------|----------------|
| POST | `/api/chat/conversations` | Yes | Body: `{ "other_user_id", "order_id"? }` | 200 `{ data: conversation }` | Postman: POST + Bearer (other_user_id = another user’s id). |
| GET | `/api/chat/conversations` | Yes | Query: `page`, `pageSize` | 200 `{ data: { items, total, page, pageSize } }` | App: Profile → Test APIs → “GET my conversations” (after login). Or Postman: GET + Bearer. |
| GET | `/api/chat/conversations/:id` | Yes | — | 200 `{ data: conversation }` | Postman: GET + Bearer. |
| GET | `/api/chat/conversations/:id/messages` | Yes | Query: `limit` (default 50), `before` (ISO date) | 200 `{ data: messages[] }` | Postman: GET + Bearer. |
| POST | `/api/chat/conversations/:id/messages` | Yes | Body: `{ "content", "type"? }` (type: TEXT \| IMAGE \| FILE \| SYSTEM) | 201 `{ data: message }` | Postman: POST + Bearer. |

---

## 8. Agreements (`/api/agreements`) – auth required (CUSTOMER)

| Method | Path | Auth | Body / Query | Response | How to verify |
|--------|------|------|--------------|----------|----------------|
| GET | `/api/agreements` | Yes (CUSTOMER) | Query: `page`, `pageSize` | 200 `{ data: { items, total, page, pageSize } }` | Postman: GET + Bearer. |
| PATCH | `/api/agreements/:id/sign` | Yes (CUSTOMER) | — | 200 `{ data: agreement }` | Postman: PATCH + Bearer (agreement id). |

---

## How to check “it works”

1. **Backend running**  
   Deployed: `https://travel-china-api.onrender.com`  
   Local: e.g. `http://localhost:4000` (and in app set base URL to that if needed).

2. **No auth (catalog)**  
   - **From app:** Profile → **Test APIs** → tap “GET Routes list”, “GET Companions list”, “GET Hotels list”, “GET Tickets list”, “GET Insurance list”. Each triggers a **real** HTTP request to the backend. Success = SnackBar with counts; failure = SnackBar with error.  
   - **Tours:** Open **Tours** list and a tour detail – those screens already call `GET /api/catalog/packages` and `GET /api/catalog/packages/:id`.  
   - **From Postman:** Same URLs, no header. Example: `GET https://travel-china-api.onrender.com/api/catalog/routes?page=1&pageSize=10`.

3. **With auth (profile, orders, itineraries, reviews, chat)**  
   - **Login in app** (or Postman: `POST /api/auth/login` → copy `access_token`).  
   - **From app:** Profile → **Test APIs** → tap “GET my profile”, “PATCH profile”, “GET my orders list”, “GET my itineraries”, “POST create itinerary”, “GET my reviews”, “GET my conversations”. Each sends `Authorization: Bearer <token>` and hits the backend. Success = SnackBar with result; 401 = token missing/expired.  
   - **From Postman:** For each endpoint, set header `Authorization: Bearer <access_token>` and call the method/path/body above.

4. **If something fails**  
   - **Connection / timeout:** Check base URL and that backend is up.  
   - **401:** Login again; token may be expired.  
   - **400/404/500:** Check request body/query and backend logs.

The **“Test APIs”** screen in the app is only a **UI that triggers these real backend calls**. It does not use fake or local test APIs.
