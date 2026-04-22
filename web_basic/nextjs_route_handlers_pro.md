# Next.js Route Handlers Pro

คู่มือฉบับ production-grade สำหรับเข้าใจและใช้งาน **Route Handlers** ใน Next.js App Router  
โฟกัสที่ mental model, HTTP methods, dynamic routes, validation, auth, caching, webhooks, streaming, และ architecture ที่ใช้งานจริง

---

# 1) Route Handlers คืออะไร

Route Handler คือไฟล์ `route.ts` หรือ `route.js` ที่ใช้สร้าง custom request handlers สำหรับ route หนึ่ง ๆ  
โดยใช้ Web `Request` และ `Response` APIs

Mental model:

```text
Route Handler = endpoint ของระบบเราในโลก App Router
```

หรืออีกแบบ:

```text
Page = render UI
Route Handler = รับ/ส่ง HTTP
```

---

# 2) Route Handlers อยู่ตรงไหน

ตัวอย่าง:

```text
app/
  api/
    products/
      route.ts
```

URL ที่ได้:

```text
/api/products
```

ตัวอย่าง dynamic route:

```text
app/
  api/
    products/
      [id]/
        route.ts
```

URL:

```text
/api/products/:id
```

---

# 3) Route Handlers รองรับ method อะไรบ้าง

รองรับได้หลาย HTTP methods เช่น:

- `GET`
- `POST`
- `PUT`
- `PATCH`
- `DELETE`
- `HEAD`
- `OPTIONS`

ตัวอย่าง:

```tsx
export async function GET(request: Request) {
  return Response.json({ ok: true })
}

export async function POST(request: Request) {
  const body = await request.json()
  return Response.json({ created: true, body })
}
```

---

# 4) Route Handler vs Page vs Server Action

## ใช้ Route Handler เมื่อ:
- ต้อง expose API endpoint
- mobile app หรือ external client ต้องเรียก
- webhook
- upload flow
- third-party callback
- streaming endpoint

## ใช้ Page/Server Component เมื่อ:
- จุดประสงค์คือ render UI + fetch data

## ใช้ Server Action เมื่อ:
- เป็น mutation จาก UI ภายในแอป
- form submit ภายในระบบ
- ไม่จำเป็นต้องเปิด public API

สูตรจำง่าย:

```text
UI render = page
internal mutation = server action
public/external endpoint = route handler
```

---

# 5) ตัวอย่างพื้นฐาน

```tsx
// app/api/hello/route.ts
export async function GET() {
  return Response.json({ message: 'Hello from Next.js' })
}
```

---

# 6) อ่าน body, query, params ยังไง

## อ่าน query string

```tsx
export async function GET(request: Request) {
  const { searchParams } = new URL(request.url)
  const q = searchParams.get('q')

  return Response.json({ q })
}
```

## อ่าน body

```tsx
export async function POST(request: Request) {
  const body = await request.json()
  return Response.json({ body })
}
```

## อ่าน dynamic params

```tsx
export async function GET(
  request: Request,
  context: { params: Promise<{ id: string }> }
) {
  const { id } = await context.params
  return Response.json({ id })
}
```

---

# 7) Response ที่ควรใช้

ใช้ `Response` หรือ `NextResponse` ก็ได้ แต่ให้คิดว่ามันเป็น endpoint ที่ต้อง return response ให้ครบ

```tsx
return Response.json({ ok: true })
```

หรือ

```tsx
return new Response('Created', { status: 201 })
```

---

# 8) Status Code Strategy

ใช้ status code ให้ชัด

- `200` = success read
- `201` = created
- `204` = success no content
- `400` = bad request
- `401` = unauthorized
- `403` = forbidden
- `404` = not found
- `409` = conflict
- `422` = validation failed
- `500` = internal error

ตัวอย่าง:

```tsx
return Response.json(
  { error: 'Invalid input' },
  { status: 422 }
)
```

---

# 9) Validation Pattern

อย่าเชื่อ request body ตรง ๆ  
ต้อง validate เสมอ

```tsx
import { z } from 'zod'

const schema = z.object({
  title: z.string().min(1),
})

export async function POST(request: Request) {
  const body = await request.json()

  const parsed = schema.safeParse(body)
  if (!parsed.success) {
    return Response.json(
      { error: 'Invalid input' },
      { status: 422 }
    )
  }

  return Response.json({ ok: true, data: parsed.data }, { status: 201 })
}
```

Mental model:

```text
TypeScript = ตอนเขียน
Validation = ตอน runtime
```

---

# 10) Auth / Authorization Pattern

ทุก endpoint ที่กระทบข้อมูลจริงควรมี:

1. authentication
2. authorization

ตัวอย่างแนวคิด:

```tsx
export async function DELETE(request: Request) {
  const user = await requireUser()
  if (!user) {
    return Response.json({ error: 'Unauthorized' }, { status: 401 })
  }

  const canDelete = user.role === 'admin'
  if (!canDelete) {
    return Response.json({ error: 'Forbidden' }, { status: 403 })
  }

  return new Response(null, { status: 204 })
}
```

กฎจำง่าย:

```text
ทุก mutation endpoint = validate + auth + permission
```

---

# 11) Dynamic API Routes

ตัวอย่าง:

```text
app/api/posts/[id]/route.ts
```

```tsx
export async function GET(
  request: Request,
  context: { params: Promise<{ id: string }> }
) {
  const { id } = await context.params
  return Response.json({ id })
}
```

ใช้กับ:
- `/api/products/123`
- `/api/users/abc`
- `/api/orders/2026-001`

---

# 12) Query-based Filtering

```tsx
export async function GET(request: Request) {
  const { searchParams } = new URL(request.url)

  const page = Number(searchParams.get('page') ?? '1')
  const sort = searchParams.get('sort') ?? 'latest'
  const q = searchParams.get('q') ?? ''

  return Response.json({ page, sort, q })
}
```

เหมาะกับ:
- filter
- sort
- search
- pagination

---

# 13) Caching Mental Model สำหรับ GET Handlers

ถ้า Route Handler เป็น `GET` ก็ยังต้องคิดเรื่อง caching/freshness  
โดยเฉพาะเมื่อ endpoint นั้นถูก reuse หลายจุด

แยกความคิดเป็น:

- static-ish
- revalidated
- always fresh

ถ้าข้อมูลต้องสดมาก:
- อย่า rely กับ cache ที่ไม่ได้ตั้งใจ
- ชัดเจนเรื่อง invalidation

---

# 14) revalidatePath กับ Route Handlers

สามารถ invalidate cached data ที่เกี่ยวกับ route handler ได้ผ่าน `revalidatePath`

Mental model:

```text
ถ้า handler GET ถูก cache/reused
mutation อื่นควร invalidate จุดที่เกี่ยวข้อง
```

---

# 15) Route Handlers สำหรับ Webhook

นี่คือ use case สำคัญมาก

เหมาะกับ:
- Stripe webhook
- GitHub webhook
- LINE / Slack callback
- payment confirmation
- external system push event

ตัวอย่าง skeleton:

```tsx
export async function POST(request: Request) {
  const rawBody = await request.text()

  // verify signature
  // parse payload
  // process event

  return Response.json({ received: true })
}
```

จุดสำคัญ:
- verify signature
- อย่าเชื่อ payload ตรง ๆ
- log event id
- handle idempotency

---

# 16) Route Handlers สำหรับ File Upload

ใช้ได้กับ formData:

```tsx
export async function POST(request: Request) {
  const formData = await request.formData()
  const file = formData.get('file')

  return Response.json({ ok: true })
}
```

ต้องคิดต่อเรื่อง:
- file size
- mime type
- storage target
- auth
- antivirus / content policy
- signed upload flow ถ้า scale ใหญ่

---

# 17) Streaming Responses

Route Handler เหมาะกับงาน streaming เช่น:
- AI text stream
- SSE
- log stream
- incremental output

Mental model:

```text
Page = render UI
Route Handler = transport layer
```

เหมาะมากเวลาทำ AI app, chat, progress feed

---

# 18) อย่าใช้ `NextResponse.next()` ใน Route Handler

Route Handler คือปลายทางของ handler chain แล้ว  
ต้อง return `Response` เอง ไม่ใช่ forward ต่อแบบ proxy chain

สูตรจำง่าย:

```text
Route Handler = terminal response
```

---

# 19) Error Handling Strategy

แยก 3 ระดับ

## A. Validation Error
```tsx
return Response.json({ error: 'Invalid input' }, { status: 422 })
```

## B. Auth Error
```tsx
return Response.json({ error: 'Unauthorized' }, { status: 401 })
```

## C. Unexpected Error
```tsx
return Response.json({ error: 'Internal Server Error' }, { status: 500 })
```

Production mindset:
- อย่า expose internal stack trace
- log ฝั่ง server
- response ให้ predictable

---

# 20) Service Layer Pattern

อย่าเขียนทุกอย่างใน `route.ts`  
แยก service ออกมา

โครงสร้างแนะนำ:

```text
features/
  products/
    services/
      list-products.ts
      create-product.ts
    schemas/
      product.schema.ts

app/
  api/
    products/
      route.ts
```

ตัวอย่าง:

## route.ts
```tsx
import { listProducts } from '@/features/products/services/list-products'

export async function GET() {
  const products = await listProducts()
  return Response.json(products)
}
```

ข้อดี:
- route handler บาง
- test ง่าย
- business logic ไม่กระจุกใน transport layer

---

# 21) Route Handler กับ Database

ใช้ได้ดีมากกับงานเช่น:
- CRUD API
- webhook processor
- backend for mobile/web
- signed URL generation
- public/internal REST interface

แต่กฎเดิมยังใช้:
- validate input
- transaction เมื่อจำเป็น
- auth/permission
- logging
- error mapping

---

# 22) เมื่อไรไม่ควรใช้ Route Handler

ไม่ควรใช้เมื่อ:
- แค่อยาก fetch ข้อมูลเพื่อ render page ในแอปเดียวกัน
- แค่ form submit ภายใน UI เดียวกันแล้ว Server Action พอ
- อยากย้าย logic ทุกอย่างไป API แบบเดิมทั้งที่ App Router ช่วยได้แล้ว

anti-pattern ที่เจอบ่อย:

```text
Page -> fetch /api/... -> route.ts -> DB
```

ทั้งที่จริงบางกรณีควรเป็น:

```text
Page (server) -> service -> DB
```

เร็วกว่า ตรงกว่า และ boilerplate น้อยกว่า

---

# 23) Decision Framework

ถามทีละข้อ:

## Q1. ต้องเปิด endpoint ให้ external client ไหม?
- ใช่ -> Route Handler

## Q2. เป็น mutation จาก form/UI ภายในระบบอย่างเดียวไหม?
- ใช่ -> Server Action ก่อน

## Q3. จุดประสงค์คือ render UI ของ page ไหม?
- ใช่ -> Server Component ก่อน

## Q4. ต้องรับ webhook / upload / stream ไหม?
- ใช่ -> Route Handler

---

# 24) Example: Products API

```tsx
// app/api/products/route.ts
import { z } from 'zod'

const createSchema = z.object({
  title: z.string().min(1),
})

export async function GET() {
  const products = [
    { id: 1, title: 'Phone' },
    { id: 2, title: 'Laptop' },
  ]

  return Response.json(products)
}

export async function POST(request: Request) {
  try {
    const body = await request.json()

    const parsed = createSchema.safeParse(body)
    if (!parsed.success) {
      return Response.json(
        { error: 'Invalid input' },
        { status: 422 }
      )
    }

    const created = {
      id: Date.now(),
      title: parsed.data.title,
    }

    return Response.json(created, { status: 201 })
  } catch {
    return Response.json(
      { error: 'Internal Server Error' },
      { status: 500 }
    )
  }
}
```

---

# 25) Example: Product by ID

```tsx
// app/api/products/[id]/route.ts
export async function GET(
  request: Request,
  context: { params: Promise<{ id: string }> }
) {
  const { id } = await context.params

  const product = { id, title: 'Phone' }

  return Response.json(product)
}
```

---

# 26) Architecture Recommendation

```text
src/
  app/
    api/
      products/
        route.ts
      products/
        [id]/
          route.ts

  features/
    products/
      services/
        list-products.ts
        get-product-by-id.ts
        create-product.ts
      schemas/
        product.schema.ts

  lib/
    auth/
    db/
    logger/
```

แนวคิด:
- `route.ts` = HTTP transport
- `services` = business/data logic
- `schemas` = runtime validation
- `lib` = infra

---

# 27) Common Mistakes

1. ใช้ Route Handler ทั้งหมดแทน Server Components
2. ไม่ validate request body
3. ไม่ check auth/permission
4. เขียน business logic ทั้งหมดใน `route.ts`
5. ใช้ status code มั่ว
6. expose internal error detail
7. ไม่คิด idempotency ใน webhook
8. ไม่คิด raw body/signature verification ใน provider callback

---

# 28) Best Practices

1. ใช้ Route Handlers เมื่อมีเหตุผลด้าน HTTP/API จริง
2. แยก service / schema / transport
3. ใช้ `Response.json()` สำหรับ JSON response
4. map error ให้เป็น status code ที่ถูก
5. ทำ auth + authorization สำหรับ protected routes
6. validate input ทุกครั้ง
7. log ฝั่ง server อย่างพอเหมาะ
8. อย่าเรียก `/api/...` จาก page server component ถ้าไม่จำเป็น

---

# 29) Final Mental Model

```text
Route Handler
= endpoint ของระบบ
= รับ request
= validate
= auth
= call service
= return response
```

สูตรจำง่ายที่สุด:

```text
Page = UI
Server Action = internal mutation
Route Handler = HTTP endpoint
```

---

# 30) สรุปสุดท้าย

Route Handlers คือสะพานจากโลก App Router ไปสู่โลก HTTP แบบเต็มตัว  
มันเหมาะกับงานที่ต้องการ endpoint จริง เช่น webhook, upload, mobile/backend API, callback, และ streaming

แต่ใน App Router อย่าใช้มันเกินจำเป็น  
เพราะหลายกรณี:
- render data -> ใช้ Server Components ดีกว่า
- mutate จาก form ภายในระบบ -> ใช้ Server Actions ดีกว่า

คิดแบบนี้จะได้ architecture ที่ทั้งเร็ว ทั้งสะอาด และ production-ready
