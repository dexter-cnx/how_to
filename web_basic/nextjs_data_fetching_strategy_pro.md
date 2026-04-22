# Next.js Data Fetching Strategy Pro

คู่มือฉบับ production-grade สำหรับการตัดสินใจเรื่อง data fetching ใน Next.js App Router  
โฟกัสที่ **Server Components**, **fetch**, **cache**, **revalidate**, **no-store**, **Route Handlers**, และ **Server Actions**

---

# 1) Mental Model ใหญ่สุด

สูตรจำง่าย:

```text
default = server fetch
interactive = client
freshness = cache strategy
mutation = server action / route handler
```

อีกแบบ:

```text
Where to fetch?
- Server Component = default
- Client Component = เมื่อจำเป็นจริง
- Route Handler = เมื่อต้อง expose endpoint
- Server Action = เมื่อต้อง mutate ผ่าน UI flow
```

---

# 2) Data Fetching มี 4 แบบหลัก

## A. Fetch ใน Server Component
เหมาะกับ:
- page data
- SEO
- initial render
- dashboard summary
- product list
- detail page

```tsx
export default async function ProductsPage() {
  const res = await fetch('https://dummyjson.com/products')
  const data = await res.json()

  return <div>{data.products.length}</div>
}
```

นี่คือ default strategy ที่ควรคิดก่อนเสมอ

---

## B. Fetch ใน Client Component
เหมาะกับ:
- browser-only interaction
- live search UI
- polling บางกรณี
- state ที่ขึ้นกับ user interaction ทันที

```tsx
'use client'

import { useEffect, useState } from 'react'

export function SearchBox() {
  const [items, setItems] = useState([])

  useEffect(() => {
    fetch('/api/search?q=phone')
      .then((r) => r.json())
      .then(setItems)
  }, [])

  return <div>{items.length}</div>
}
```

ใช้เมื่อจำเป็นจริง เพราะ client fetch ทำให้:
- initial HTML มีข้อมูลน้อยลง
- ต้องรอ JS
- SEO มักด้อยกว่า server fetch

---

## C. Fetch ผ่าน Route Handler
เหมาะกับ:
- external consumer
- webhook
- custom API
- upload flow
- browser/client ที่ต้องเรียก endpoint ของระบบเรา

```tsx
// app/api/products/route.ts
export async function GET() {
  return Response.json([{ id: 1, name: 'A' }])
}
```

---

## D. Mutation ผ่าน Server Action
เหมาะกับ:
- create/update/delete จาก form ใน app
- action ที่เกิดจาก UI flow
- logic ที่ไม่จำเป็นต้อง expose endpoint สาธารณะ

```tsx
'use server'

export async function createPost(formData: FormData) {
  const title = formData.get('title')
  // validate
  // save
}
```

---

# 3) Core Rule: เริ่มจาก Server ก่อน

Production mindset:

```text
1. เริ่มคิดว่า fetch บน server
2. ถ้ามี interaction ค่อยแยก interactive island ไป client
3. ถ้าต้องเปิด endpoint ให้คนอื่นเรียก -> route handler
4. ถ้าเป็น mutation จาก UI ของแอป -> server action
```

---

# 4) Cache Strategy 3 แบบที่ต้องแยกให้ชัด

## แบบที่ 1: Cache ได้ยาว
ข้อมูลเปลี่ยนไม่บ่อย เช่น:
- marketing content
- category list
- docs
- public product catalog ที่เปลี่ยนเป็นช่วง

ใช้เมื่อ:
- อยากเร็ว
- ยอมให้ข้อมูลไม่สด 100%
- อ่านเยอะ แก้น้อย

ตัวอย่าง:

```tsx
await fetch('https://example.com/products', {
  cache: 'force-cache',
})
```

---

## แบบที่ 2: Revalidate เป็นช่วง
ข้อมูลเปลี่ยนได้ แต่ไม่ต้องสดทุก request เช่น:
- dashboard summary
- product list
- news list
- profile summary ที่ยอม lag ได้เล็กน้อย

ตัวอย่าง:

```tsx
await fetch('https://example.com/products', {
  next: { revalidate: 60 },
})
```

แปลว่า cache ได้ แต่หลัง 60 วินาทีค่อย refresh ใหม่

---

## แบบที่ 3: สดทุกครั้ง
ข้อมูล sensitive / request-specific / user-specific เช่น:
- current user session
- inventory สด
- cart
- permission
- highly dynamic analytics

ตัวอย่าง:

```tsx
await fetch('https://example.com/me', {
  cache: 'no-store',
})
```

หรือมองอีกแบบว่า route นี้ dynamic จริง

---

# 5) `cache: 'force-cache'` คืออะไร

ใช้เมื่ออยากให้ Next.js ใช้ Data Cache สำหรับ request นี้

```tsx
const res = await fetch('https://example.com/categories', {
  cache: 'force-cache',
})
```

เหมาะกับ:
- ข้อมูล public
- ข้อมูลเปลี่ยนไม่บ่อย
- shared data ที่ reuse ข้าม request ได้

ข้อดี:
- เร็ว
- ลด load ที่ backend ต้นทาง
- เหมาะกับหน้า content-heavy

ข้อควรระวัง:
- ข้อมูลอาจ stale
- ต้องมี invalidation/revalidation plan

---

# 6) `next: { revalidate: N }` คืออะไร

ใช้เมื่ออยาก cache แล้ว refresh เป็นช่วงเวลา

```tsx
const res = await fetch('https://example.com/posts', {
  next: { revalidate: 300 },
})
```

เหมาะกับ:
- ISR-style mindset
- public data ที่เปลี่ยนทุกไม่กี่นาที
- performance + freshness balance

Mental model:

```text
เร็วแบบ cache
แต่ไม่เก่าเกินไป
```

---

# 7) `cache: 'no-store'` คืออะไร

ใช้เมื่อไม่ต้องการ cache เลย

```tsx
const res = await fetch('https://example.com/account', {
  cache: 'no-store',
})
```

เหมาะกับ:
- request ที่ต้องสด
- per-user data
- personalized response
- security-sensitive data

ข้อดี:
- สดเสมอ

ข้อเสีย:
- แพงกว่า
- ช้ากว่า
- load backend มากขึ้น

---

# 8) เลือกยังไง: Decision Table

| use case | strategy |
|---|---|
| blog list | `revalidate` |
| homepage content | `force-cache` หรือ `revalidate` |
| current user | `no-store` |
| cart | `no-store` |
| category taxonomy | `force-cache` |
| stock count สด | `no-store` |
| public dashboard summary | `revalidate` |
| docs/static content | `force-cache` |

---

# 9) Route-level Thinking

อย่าคิดแค่ “fetch ทีละตัว”  
ให้คิดระดับ route ด้วย

ตัวอย่างหน้า `/products`:

- category list → cache ได้นาน
- product list → revalidate 60
- personalized recommendation → no-store หรือแยกไป client หลังบ้าน

แปลว่าใน 1 route อาจมีหลาย freshness strategy ได้

---

# 10) Dynamic vs Static Mindset

อย่าคิดแบบเก่าว่า “หน้านี้ static หรือ dynamic ทั้งหน้า” อย่างเดียว  
ใน App Router เราคิด incremental ได้

```text
ส่วนหนึ่ง cache ได้
อีกส่วนหนึ่งสด
อีกส่วนหนึ่ง client interactive
```

นี่คือข้อดีใหญ่มากของแนวคิดใหม่

---

# 11) Data Fetching Layer ที่แนะนำ

แยก service ออกมา:

```text
features/
  products/
    services/
      get-products.ts
      get-product-by-id.ts
```

ตัวอย่าง:

```tsx
export async function getProducts() {
  const res = await fetch('https://dummyjson.com/products', {
    next: { revalidate: 60 },
  })

  if (!res.ok) {
    throw new Error('Failed to fetch products')
  }

  const data = await res.json()
  return data.products
}
```

ข้อดี:
- reuse ได้
- test ง่ายขึ้น
- เปลี่ยน strategy ทีเดียวได้

---

# 12) อย่า Fetch มั่วใน Client

ตัวอย่าง anti-pattern:

```tsx
'use client'

useEffect(() => {
  fetch('/api/products')
}, [])
```

ถ้าข้อมูลนั้นใช้ render หน้าแรกได้อยู่แล้ว  
ควร fetch ใน server ก่อน แล้วส่งลง client ผ่าน props

ถูกกว่าแบบนี้:

```tsx
// server
export default async function Page() {
  const products = await getProducts()
  return <ProductGrid products={products} />
}
```

```tsx
'use client'

export function ProductGrid({ products }) {
  return <div>{products.length}</div>
}
```

---

# 13) Search, Filter, Pagination ควรคิดเป็น URL State

ตัวอย่าง:

```text
/products?page=2&sort=price_desc&q=phone
```

แล้ว page/server component อ่านจาก search params เพื่อ fetch ให้ตรง query

ข้อดี:
- share URL ได้
- refresh แล้ว state ไม่หาย
- server fetch sync กับ route ได้ดี

---

# 14) Loading / Error / Empty State ต้องครบ

## loading.tsx
แสดงตอน route segment กำลังรอข้อมูล

## error.tsx
แสดงตอน fetch fail

## empty state
แสดงตอน data มาแต่ไม่มีรายการ

ตัวอย่าง empty state:

```tsx
if (!products.length) {
  return <div>No products found</div>
}
```

Production app ที่ดีต้องมีทั้ง 3 แบบ

---

# 15) Revalidation แบบ On-demand

ถ้าแก้ข้อมูลแล้วอยากให้ route หรือ tag ถูก invalidate  
แนวคิดคือใช้ revalidation API หลัง mutation

ตัวอย่าง mental model:

```text
save data
-> invalidate related cache
-> request ถัดไปได้ข้อมูลใหม่
```

จุดนี้สำคัญมากใน dashboard / CMS / admin panel

---

# 16) Tag-based Revalidation Mindset

เวลา fetch สามารถใส่ tag ได้:

```tsx
await fetch('https://example.com/products', {
  next: { tags: ['products'] },
})
```

แล้วหลัง update ค่อย invalidate tag นี้

```tsx
revalidateTag('products')
```

เหมาะกับ:
- data set ที่ใช้หลาย route
- CMS
- catalog
- admin flows

---

# 17) Path-based Revalidation Mindset

ถ้ารู้ชัดว่าหน้าไหนต้อง refresh:

```tsx
revalidatePath('/products')
```

เหมาะกับ:
- create/update/delete ที่กระทบ route ชัดเจน
- admin save แล้วกลับ list page

---

# 18) Route Handlers vs Server Actions

## ใช้ Route Handler เมื่อ:
- ต้อง expose API ให้ client/app ภายนอก
- webhook
- mobile app เรียก
- 3rd party เรียก

## ใช้ Server Action เมื่อ:
- เป็น mutation จาก form/action ใน app โดยตรง
- ไม่จำเป็นต้องเปิด endpoint ภายนอก
- อยากลด boilerplate

สูตรจำง่าย:

```text
internal UI mutation = server action
external API contract = route handler
```

---

# 19) Common Production Patterns

## Pattern A: public list page
- fetch ใน server
- `revalidate: 60`
- loading/error/empty ครบ

## Pattern B: account page
- fetch ใน server
- `cache: 'no-store'`

## Pattern C: settings form
- page fetch ใน server
- submit ผ่าน server action
- success แล้ว `revalidatePath`

## Pattern D: search autocomplete
- shell เป็น server
- interactive search box เป็น client
- เรียก route handler เมื่อ user พิมพ์

---

# 20) Common Mistakes

## 1. ใช้ `no-store` ทุกอย่าง
ทำให้แอปช้ากว่าที่ควร

## 2. ใช้ cache กับข้อมูลส่วนตัว
เสี่ยง stale และ logic เพี้ยน

## 3. fetch ซ้ำทั้ง server และ client โดยไม่จำเป็น
เสียทั้งเวลาและ network

## 4. ไม่มี invalidation plan
ข้อมูลเปลี่ยนแล้วหน้าจอไม่อัปเดต

## 5. ใช้ route handler ทั้งหมดแทน server component
ทำให้เสียข้อดีของ App Router

---

# 21) Recommended Decision Framework

ถามทีละข้อ:

## Q1. ข้อมูลนี้ใช้ render หน้าแรกไหม?
- ใช่ → fetch ใน server ก่อน

## Q2. ข้อมูลนี้ personalized ไหม?
- ใช่ → คิด `no-store` หรือ dynamic route

## Q3. ข้อมูลนี้เปลี่ยนบ่อยแค่ไหน?
- น้อย → `force-cache`
- ปานกลาง → `revalidate`
- สูง/ต้องสด → `no-store`

## Q4. ต้อง expose API ให้ภายนอกไหม?
- ใช่ → route handler

## Q5. เป็น mutation จาก UI ภายในระบบไหม?
- ใช่ → server action

---

# 22) Example: Product List แบบ Production

```tsx
// features/products/services/get-products.ts
export async function getProducts() {
  const res = await fetch('https://dummyjson.com/products', {
    next: { revalidate: 60, tags: ['products'] },
  })

  if (!res.ok) {
    throw new Error('Failed to fetch products')
  }

  const data = await res.json()
  return data.products
}
```

```tsx
// app/products/page.tsx
import { getProducts } from '@/features/products/services/get-products'

export default async function ProductsPage() {
  const products = await getProducts()

  if (!products.length) {
    return <div>No products found</div>
  }

  return (
    <main>
      <h1>Products</h1>
      <ul>
        {products.map((product: any) => (
          <li key={product.id}>{product.title}</li>
        ))}
      </ul>
    </main>
  )
}
```

---

# 23) Example: Mutation + Revalidate

```tsx
'use server'

import { revalidatePath } from 'next/cache'

export async function createProduct(formData: FormData) {
  const title = formData.get('title')

  // save to DB

  revalidatePath('/products')
}
```

---

# 24) Architecture Recommendation

```text
app/
  products/
    page.tsx
    loading.tsx
    error.tsx

features/
  products/
    services/
      get-products.ts
      create-product.ts
    components/
      product-list.tsx
      product-form.tsx
    schemas/
      product.schema.ts
```

แยกให้ชัด:
- page = route composition
- services = fetching/mutation
- components = UI
- schemas = validation

---

# 25) Final Mental Model

```text
Server fetch = default
Client fetch = exception
force-cache = shared + stable
revalidate = balanced freshness
no-store = always fresh
route handler = public/external endpoint
server action = internal mutation
```

---

# 26) สูตรจำง่ายที่สุด

```text
อ่านข้อมูล = server ก่อน
แก้ข้อมูล = server action ก่อน
เปิด API = route handler
ความสดของข้อมูล = cache strategy
```
