# Next.js Proxy (Middleware) Pro

คู่มือฉบับ production-grade สำหรับเข้าใจและใช้งาน **Proxy** ใน Next.js App Router  
โฟกัสที่ mental model, matcher, redirect/rewrite, auth gate, headers, cookies, i18n, CSP, และข้อควรระวังด้าน performance

> หมายเหตุสำคัญ: ในเอกสารล่าสุดของ Next.js file convention เดิมชื่อ `middleware.ts` ถูก **deprecated** และเปลี่ยนชื่อเป็น `proxy.ts` แล้ว

---

# 1) Proxy คืออะไร

Proxy คือไฟล์ `proxy.ts` หรือ `proxy.js` ที่รันบนเซิร์ฟเวอร์ **ก่อนที่ request จะเสร็จสมบูรณ์**  
แล้วเราสามารถ:

- rewrite path
- redirect
- modify request headers
- modify response headers
- set/read cookies
- block / allow request
- respond directly

Mental model:

```text
Proxy = request gate / traffic controller ของแอป
```

หรืออีกแบบ:

```text
Page = render UI
Route Handler = endpoint
Proxy = ด่านหน้าก่อนเข้า route
```

---

# 2) ทำไม Next.js เปลี่ยนชื่อจาก Middleware เป็น Proxy

Next.js ระบุชัดว่า `middleware` ถูก rename เป็น `proxy`  
เพราะคำว่า middleware ทำให้หลายคนเข้าใจผิดไปทาง Express-style middleware และมักใช้เกินขอบเขตที่เหมาะสม

แนวคิดใหม่คือ:

```text
Proxy ควรใช้เมื่อเราต้อง intercept request ก่อนถึง route
```

ไม่ใช่ยัด business logic ทุกอย่างไว้ที่นี่

---

# 3) Proxy อยู่ตรงไหน

วางไฟล์ไว้ที่ root ของโปรเจกต์:

```text
proxy.ts
```

ในหนึ่งโปรเจกต์รองรับ **ได้ไฟล์เดียว**  
แต่สามารถแยก logic ไปไฟล์อื่นแล้ว import เข้ามารวมใน `proxy.ts` ได้

ตัวอย่างโครงสร้าง:

```text
src/
  proxy/
    auth.ts
    locale.ts
    security.ts

proxy.ts
```

---

# 4) โครงสร้างพื้นฐาน

```tsx
import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

export function proxy(request: NextRequest) {
  return NextResponse.next()
}
```

Mental model:

```text
request เข้า proxy
-> ตัดสินใจ
-> next / redirect / rewrite / response
```

---

# 5) `NextResponse.next()` คืออะไร

หมายถึง:

```text
อนุญาตให้ request ไปต่อ
```

ใช้เมื่อเราแค่ inspect request แล้วไม่ต้องเปลี่ยน flow

```tsx
return NextResponse.next()
```

---

# 6) Redirect vs Rewrite

## Redirect
เปลี่ยนปลายทางและ browser จะเห็น URL ใหม่

```tsx
return NextResponse.redirect(new URL('/login', request.url))
```

## Rewrite
เปลี่ยนปลายทางภายใน แต่ URL ที่ user เห็นอาจคงเดิม

```tsx
return NextResponse.rewrite(new URL('/maintenance', request.url))
```

สูตรจำง่าย:

```text
redirect = ย้ายจริง
rewrite = แอบเปลี่ยนทาง
```

---

# 7) Matcher คืออะไร

โดย default, Proxy จะรันกับทุก request  
แต่สามารถจำกัด path ที่ต้องการได้ด้วย `matcher`

```tsx
export const config = {
  matcher: ['/dashboard/:path*', '/settings/:path*'],
}
```

ใช้เมื่อ:
- รัน auth guard เฉพาะ private routes
- ใส่ locale redirect บาง path
- ใส่ CSP เฉพาะหน้า app

เอกสาร Next.js แนะนำว่า Proxy ควรถูกกรองด้วย matcher ตามความเหมาะสม  
แต่ในกรณี auth docs ก็ระบุว่า auth อาจเลือกให้ Proxy ทำงานกับทุก route ได้

---

# 8) ตัวอย่าง Auth Gate

```tsx
import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

export function proxy(request: NextRequest) {
  const session = request.cookies.get('session')?.value
  const isProtected = request.nextUrl.pathname.startsWith('/dashboard')

  if (isProtected && !session) {
    return NextResponse.redirect(new URL('/login', request.url))
  }

  return NextResponse.next()
}

export const config = {
  matcher: ['/dashboard/:path*'],
}
```

Mental model:

```text
request เข้า private route
-> เช็ก cookie/session
-> ไม่มี -> redirect login
-> มี -> allow
```

---

# 9) Read Cookies ใน Proxy

สามารถอ่าน cookies ได้จาก request

```tsx
const session = request.cookies.get('session')?.value
```

เหมาะกับ:
- session gate
- locale
- theme
- A/B bucket
- onboarding state

---

# 10) Set Cookies / Headers

สามารถแก้ response ได้เช่นกัน

```tsx
const response = NextResponse.next()
response.cookies.set('visited', 'true')
response.headers.set('x-app-version', '1')
return response
```

ใช้กับ:
- tracking cookie
- security header
- experiment assignment
- region marker

---

# 11) Auth Mental Model ใน Proxy

Proxy เหมาะกับงาน auth gate ระดับ routing เช่น:
- private route guard
- redirect logged-out users
- redirect logged-in users ออกจาก `/login`
- role pre-check แบบเบื้องต้น

แต่ไม่ควรยัด authorization logic ลึกทั้งหมดไว้ใน Proxy  
เพราะ source of truth ควรยังอยู่ใน:
- server component
- route handler
- server action
- service layer

สูตรจำง่าย:

```text
Proxy = gate เบื้องต้น
Server layer = truth
```

---

# 12) Proxy กับ Authentication ตาม docs ล่าสุด

เอกสาร authentication ของ Next.js ระบุว่า:
- Proxy ใช้ `matcher` เพื่อกำหนด path ที่รันได้
- สำหรับ auth มีกรณีที่แนะนำให้ Proxy รันกับทุก route
- ใน Proxy สามารถอ่าน cookie ได้ด้วย `req.cookies.get('session').value`
- Proxy ใช้ Node.js runtime ใน docs ล่าสุด และอาจกระทบความเข้ากันได้ของ auth library ที่รองรับเฉพาะ Edge runtime

ดังนั้นเวลาเลือก auth stack ต้องเช็ก compatibility ของ library ที่ใช้ด้วย

---

# 13) Locale / i18n Redirect Pattern

Proxy เหมาะมากกับงาน locale detection

ตัวอย่าง flow:

```text
request /
-> ดู Accept-Language หรือ cookie
-> redirect ไป /en หรือ /th
```

ตัวอย่าง skeleton:

```tsx
export function proxy(request: NextRequest) {
  const pathname = request.nextUrl.pathname

  if (pathname === '/') {
    return NextResponse.redirect(new URL('/en', request.url))
  }

  return NextResponse.next()
}
```

เหมาะกับ:
- locale prefix
- market routing
- region-based entry

---

# 14) CSP / Security Headers Pattern

Next.js docs ยกตัวอย่างการใช้ Proxy เพื่อใส่ CSP header ได้  
โดยเฉพาะเมื่ออยากควบคุม request-level behavior และ filter paths ด้วย matcher

ตัวอย่างแนวคิด:

```tsx
const response = NextResponse.next()
response.headers.set(
  'Content-Security-Policy',
  "default-src 'self'; script-src 'self'"
)
return response
```

ใช้กับ:
- CSP
- custom security headers
- feature-policy style headers
- anti-clickjacking headers

---

# 15) Ignore Static Assets / Prefetch

เอกสาร CSP ของ Next.js แนะนำว่าเวลาใช้ matcher กับ Proxy  
ควรพิจารณา **ignore prefetch** และ static assets ที่ไม่จำเป็นต้องโดน Proxy

ทำไม:
- ลด overhead
- ลดการแตะ request ที่ไม่จำเป็น
- ลดโอกาสทำให้ behavior ของ static asset แปลก

Mental model:

```text
Proxy เฉพาะ request ที่มี business value
```

---

# 16) Rewrites ใช้เมื่อไร

Proxy rewrite เหมาะกับ:
- vanity URL
- maintenance page
- geo/market rewrite
- internal route masking
- experiment branch

ตัวอย่าง:

```tsx
if (request.nextUrl.pathname === '/promo') {
  return NextResponse.rewrite(new URL('/campaigns/summer-sale', request.url))
}
```

user เห็น `/promo`  
แต่ระบบเสิร์ฟ `/campaigns/summer-sale`

---

# 17) Redirects ใช้เมื่อไร

Proxy redirect เหมาะกับ:
- auth redirect
- legacy URL migration
- locale root redirect
- onboarding flow gate

ตัวอย่าง:

```tsx
if (request.nextUrl.pathname === '/old-dashboard') {
  return NextResponse.redirect(new URL('/dashboard', request.url))
}
```

---

# 18) Proxy vs next.config redirects/rewrites

ทั้งสองอย่างทำ redirect/rewrite ได้  
แต่ mindset ต่างกัน

## ใช้ `next.config.js` เมื่อ:
- กฎคงที่
- ไม่ขึ้นกับ request data มาก
- เป็น static redirect table

## ใช้ Proxy เมื่อ:
- logic ขึ้นกับ cookie/header/session/path
- dynamic decision
- auth/locale/experiment/security

สูตรจำง่าย:

```text
static rule = next.config
dynamic rule = proxy
```

---

# 19) Proxy กับ A/B Testing / Experiment

สามารถใช้ Proxy ในการ:
- assign bucket
- set cookie
- rewrite ไป variant route

ตัวอย่าง mental model:

```text
request เข้า
-> เช็ก bucket cookie
-> ถ้าไม่มี สุ่ม bucket
-> set cookie
-> rewrite ไป variant
```

จุดระวัง:
- consistency
- analytics tagging
- cache interaction
- prefetch behavior

---

# 20) Proxy กับ Maintenance Mode

Proxy เหมาะกับ maintenance gating มาก

```tsx
if (isMaintenance && !request.nextUrl.pathname.startsWith('/admin')) {
  return NextResponse.rewrite(new URL('/maintenance', request.url))
}
```

เหมาะกับ:
- เปิด/ปิดทั้งระบบชั่วคราว
- allow admin route
- allow health checks

---

# 21) Body Handling ข้อควรระวัง

เอกสาร config `proxyClientMaxBodySize` ระบุว่าเมื่อใช้ Proxy  
Next.js จะ clone request body และ buffer ไว้ใน memory เพื่อให้ทั้ง Proxy และ route ข้างล่างอ่านได้

ดังนั้น:
- body ใหญ่ = memory pressure
- config นี้ยัง experimental และไม่แนะนำ production สำหรับการพึ่งพาเต็มตัว

สูตรจำง่าย:

```text
อย่าใช้ Proxy แตะ body ใหญ่โดยไม่จำเป็น
```

---

# 22) Performance Mindset

Proxy รันก่อน route  
ดังนั้นทุก logic ที่ใส่ลงไปมีต้นทุนกับ request path ที่ match

ข้อแนะนำ:
- matcher ให้แคบเท่าที่ทำได้
- อย่า query DB หนักใน Proxy ถ้าไม่จำเป็น
- อย่าใส่ business logic หนัก
- อย่าทำ network call ข้ามระบบถ้าเลี่ยงได้
- ใช้เป็น gate ไม่ใช่ app server ทั้งตัว

---

# 23) สิ่งที่ไม่ควรยัดลง Proxy

ไม่ควรใช้ Proxy เป็นที่รวมของ:
- business logic หลัก
- DB-heavy authorization ทุกชั้น
- complex orchestration
- data fetching เพื่อ render page
- mutation logic

กรณีเหล่านี้ควรอยู่ใน:
- server components
- route handlers
- server actions
- services

---

# 24) ตัวอย่าง Proxy แบบ production-ish

```tsx
import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

export function proxy(request: NextRequest) {
  const pathname = request.nextUrl.pathname
  const session = request.cookies.get('session')?.value

  const isProtected =
    pathname.startsWith('/dashboard') ||
    pathname.startsWith('/settings')

  const isAuthPage =
    pathname.startsWith('/login') ||
    pathname.startsWith('/register')

  if (isProtected && !session) {
    return NextResponse.redirect(new URL('/login', request.url))
  }

  if (isAuthPage && session) {
    return NextResponse.redirect(new URL('/dashboard', request.url))
  }

  const response = NextResponse.next()
  response.headers.set('x-pathname', pathname)

  return response
}

export const config = {
  matcher: ['/dashboard/:path*', '/settings/:path*', '/login', '/register'],
}
```

---

# 25) Architecture Recommendation

```text
proxy.ts                  -> orchestration entry
src/proxy/auth.ts         -> auth helpers
src/proxy/locale.ts       -> locale logic
src/proxy/security.ts     -> headers/csp
src/lib/auth/             -> shared auth utilities
```

แนวคิด:
- `proxy.ts` บาง
- แยก concern
- test logic เป็น unit ได้

---

# 26) Common Mistakes

1. ยังใช้ mental model แบบ Express middleware
2. ย้าย business logic ทุกอย่างมาไว้ Proxy
3. ไม่ใช้ matcher ทำให้รันทุก request เกินจำเป็น
4. อ่าน/จัดการ body ใหญ่ใน Proxy
5. auth check ซ้ำลึกโดยไม่มี source of truth ที่ server layer
6. ใช้ redirect ทั้งที่ rewrite เหมาะกว่า หรือกลับกัน
7. ไม่แยก static rule ออกไป `next.config.js`

---

# 27) Best Practices

1. ใช้ `proxy.ts` แทน `middleware.ts` สำหรับโปรเจกต์ใหม่
2. ใช้ Proxy เฉพาะงาน intercept request จริง ๆ
3. ให้ matcher แคบ
4. ใช้กับ auth gate, locale, CSP, maintenance, redirect/rewrite
5. เก็บ source of truth ของ authorization ไว้ server layer อื่นด้วย
6. อย่าให้ Proxy กลายเป็น business layer
7. ระวัง performance และ body buffering
8. แยก logic เป็นโมดูลแล้ว import กลับมาใน `proxy.ts`

---

# 28) Final Mental Model

```text
Proxy
= request interception layer
= gate ก่อนถึง route
= redirect / rewrite / cookie / header / guard
```

สูตรจำง่ายที่สุด:

```text
next.config = static traffic rules
proxy.ts    = dynamic request gate
page        = UI
route.ts    = endpoint
server action = internal mutation
```

---

# 29) สรุปสุดท้าย

Proxy ใน Next.js เวอร์ชันล่าสุดคือชื่อใหม่ของสิ่งที่เคยเรียก middleware  
แต่วิธีคิดที่ถูกต้องคือใช้มันเป็น “ด่านหน้า” สำหรับ request

เหมาะกับ:
- auth gate
- locale routing
- maintenance
- CSP / security headers
- A/B bucket
- dynamic redirects / rewrites

ไม่เหมาะกับ:
- business logic หนัก
- data rendering flow
- mutation หลัก
- DB orchestration ขนาดใหญ่

ถ้าใช้ถูกที่ มันทรงพลังมาก  
ถ้าใช้เกินขอบเขต มันจะกลายเป็นคอขวดของทั้งแอป
