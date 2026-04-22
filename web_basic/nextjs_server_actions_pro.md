# Next.js Server Actions Pro

คู่มือฉบับ production-grade สำหรับเข้าใจและใช้งาน **Server Actions** ใน Next.js App Router  
โฟกัสที่ mental model, form flow, validation, security, revalidation, และ architecture ที่ใช้งานจริง

> อ้างอิงแนวคิดล่าสุดจากเอกสารทางการ Next.js App Router, คู่มือ Forms, และ Data Security ของ Next.js

---

# 1) Server Actions คืออะไร

Server Actions คือ **Server Functions** ที่ทำงานบนเซิร์ฟเวอร์ และสามารถถูกเรียกจาก Server Components หรือ Client Components เพื่อจัดการการ submit form และ data mutation ได้

Mental model:

```text
Server Action = function ฝั่ง server ที่ UI เรียกได้โดยตรง
```

หรืออีกแบบ:

```text
อ่านข้อมูล -> server fetch
แก้ข้อมูล -> server action
```

---

# 2) ทำไม Server Actions สำคัญ

ก่อนหน้านี้ flow แบบคลาสสิกมักเป็น:

```text
Client form
-> POST ไป API route
-> API validate
-> Save DB
-> กลับมา refresh หน้า
```

พอมี Server Actions flow จะสั้นลงเป็น:

```text
Form / UI
-> call server action
-> validate
-> save
-> revalidate / redirect
```

ข้อดี:
- boilerplate น้อยลง
- mutation logic อยู่ฝั่ง server
- เข้ากับ App Router มาก
- progressive enhancement กับ form ได้ดี

---

# 3) Server Action vs Route Handler

## ใช้ Server Action เมื่อ:
- เป็น mutation จาก UI ภายในแอป
- form submit, create, update, delete
- ไม่จำเป็นต้องเปิด endpoint ให้ client ภายนอกเรียก

## ใช้ Route Handler เมื่อ:
- ต้อง expose API endpoint
- mobile app หรือ third-party ต้องเรียก
- webhook
- API contract ภายนอก

สูตรจำง่าย:

```text
internal UI mutation = Server Action
external API contract = Route Handler
```

---

# 4) รูปแบบพื้นฐานของ Server Action

ใช้ directive:

```tsx
'use server'
```

ตัวอย่าง:

```tsx
'use server'

export async function createPost(formData: FormData) {
  const title = formData.get('title')
  // validate
  // save to db
}
```

Next.js อธิบายว่า Server Actions เป็น async functions ที่ทำงานบน server และใช้กับ form submissions ได้โดยตรง

---

# 5) ใช้กับ form อย่างไร

## แบบพื้นฐานที่สุด

```tsx
import { createPost } from './actions'

export default function Page() {
  return (
    <form action={createPost}>
      <input name="title" />
      <button type="submit">Save</button>
    </form>
  )
}
```

Mental model:

```text
<form action={serverAction}>
```

คือการ bind form เข้ากับฟังก์ชันฝั่ง server โดยตรง

---

# 6) Progressive Enhancement

Next.js ระบุว่า forms ที่เรียก Server Actions จาก **Server Components** สามารถทำงานได้แม้ JavaScript จะยังไม่โหลด  
ส่วน forms ที่เรียกจาก **Client Components** จะ queue submission ไว้จน hydration เสร็จ

สรุปง่าย ๆ:

```text
Server form = resilient กว่า
Client form = interactive มากกว่า
```

นี่เป็นเหตุผลว่าทำไมถ้า form ไม่ต้อง interactive มาก ควรเริ่มจาก server-first form ก่อน

---

# 7) ที่อยู่ของ Server Actions

มี 2 แนวคิดหลัก

## A. เขียนใกล้ component/server route
เหมาะกับ use case เล็ก ๆ เฉพาะหน้า

## B. แยกเป็นไฟล์ actions.ts
เหมาะกับ feature จริงใน production

ตัวอย่างโครงสร้าง:

```text
features/
  products/
    actions/
      create-product.ts
      update-product.ts
    schemas/
      product.schema.ts
```

แนวทาง production แนะนำให้แยกเป็นไฟล์ reusable มากกว่า

---

# 8) Validation ต้องทำบน Server เสมอ

อย่าคิดว่าเพราะใช้ form แล้วจะปลอดภัยเอง  
Server Action ยังต้อง validate input เสมอ

ตัวอย่างแนวคิด:

```tsx
'use server'

import { z } from 'zod'

const schema = z.object({
  title: z.string().min(1),
})

export async function createPost(formData: FormData) {
  const parsed = schema.safeParse({
    title: formData.get('title'),
  })

  if (!parsed.success) {
    return { error: 'Invalid input' }
  }

  // save data
}
```

Mental model:

```text
Client validation = UX
Server validation = truth
```

---

# 9) Return ค่าอย่างไร

Server Action สามารถ:
- return object error/success
- throw error
- redirect
- revalidate cache/path/tag

ตัวอย่าง return state:

```tsx
return { ok: true }
```

หรือ

```tsx
return { error: 'Title is required' }
```

---

# 10) Redirect หลัง submit

สามารถ redirect หลัง action สำเร็จได้

```tsx
'use server'

import { redirect } from 'next/navigation'

export async function createPost(formData: FormData) {
  // save
  redirect('/posts')
}
```

เหมาะกับ:
- create/edit flow
- save แล้วกลับ list page
- onboarding step

---

# 11) Revalidate หลัง mutation

หลัง create/update/delete มักต้องทำให้ข้อมูลที่ cache ไว้สดขึ้น

มี 2 แนวคิดหลัก:

## A. revalidatePath
เหมาะกับ invalidate route ที่รู้ชัด

```tsx
import { revalidatePath } from 'next/cache'

revalidatePath('/products')
```

## B. revalidateTag
เหมาะกับ invalidate data set ที่ใช้หลาย route

```tsx
import { revalidateTag } from 'next/cache'

revalidateTag('products')
```

Next.js docs อธิบายเรื่อง path/tag revalidation ไว้เป็นกลไกหลักของการ refresh data หลัง mutation

---

# 12) Pattern ที่แนะนำ: Action + Service + Schema

โครงสร้าง production ที่ดี:

```text
features/
  products/
    actions/
      create-product.ts
    services/
      insert-product.ts
    schemas/
      product.schema.ts
```

ตัวอย่าง:

## schema
```tsx
import { z } from 'zod'

export const productSchema = z.object({
  title: z.string().min(1),
})
```

## service
```tsx
export async function insertProduct(input: { title: string }) {
  // db insert
}
```

## action
```tsx
'use server'

import { revalidatePath } from 'next/cache'
import { productSchema } from '../schemas/product.schema'
import { insertProduct } from '../services/insert-product'

export async function createProduct(formData: FormData) {
  const parsed = productSchema.safeParse({
    title: formData.get('title'),
  })

  if (!parsed.success) {
    return { error: 'Invalid title' }
  }

  await insertProduct(parsed.data)
  revalidatePath('/products')

  return { ok: true }
}
```

ข้อดี:
- action = orchestration
- service = domain/data work
- schema = validation

---

# 13) ใช้ใน Client Component ได้ไหม

ได้  
ตราบใดที่ Server Action ถูกส่งเข้ามาหรือ import ตาม pattern ที่รองรับ

ตัวอย่างแนวคิด:

```tsx
'use client'

export function ProductForm({ action }: { action: (formData: FormData) => void }) {
  return (
    <form action={action}>
      <input name="title" />
      <button type="submit">Save</button>
    </form>
  )
}
```

Mental model:

```text
Client component ใช้ action ได้
แต่ตัว action ยังรันบน server
```

---

# 14) useActionState / Form State Mental Model

ใน flow ที่ต้องแสดง error/success state จาก action กลับมาที่ UI  
สามารถใช้แนวทาง form state เช่น `useActionState` เพื่อผูก action result กับ UI

แนวคิด:

```text
submit -> server action -> return state -> UI update
```

เหมาะกับ:
- field error
- submit error
- success message
- retry UX

---

# 15) useFormStatus Mental Model

ใช้กับปุ่ม submit หรือส่วนของ form ที่ต้องรู้สถานะกำลังส่งข้อมูลอยู่

ตัวอย่างสิ่งที่ทำได้:
- disable ปุ่มตอนกำลัง submit
- เปลี่ยน label เป็น “Saving...”
- แสดง spinner

แนวคิด:

```text
pending state ของ form ควรแยกจาก business state
```

---

# 16) Security เรื่องสำคัญมาก

เอกสาร Data Security ของ Next.js ระบุว่า **Server Actions ที่ถูกสร้างและ export ออกมา สามารถถูกเรียกผ่าน direct POST request ได้** ไม่ใช่เรียกได้แค่จาก UI ของแอป

แปลว่า:

```text
Server Action ไม่ใช่ private เพียงเพราะมันอยู่ฝั่ง server
```

ดังนั้นต้องทำเสมอ:
- validate input
- check auth/permission
- อย่าเชื่อ formData ตรง ๆ
- อย่า assume ว่ามาจาก UI ของเราแน่ ๆ

---

# 17) allowedOrigins และ CSRF-related thinking

Next.js มี `serverActions.allowedOrigins` ใน config เพื่อเพิ่ม origin ที่เชื่อถือได้ โดยระบบจะเทียบ origin ของ request กับ host domain เพื่อช่วยป้องกัน CSRF บางส่วน

แนวคิด:
- same-origin เป็น default
- ถ้ามี proxy / custom infra อาจต้องกำหนด allowedOrigins เพิ่ม

นี่เป็นเรื่อง infra/security level ที่สำคัญใน production

---

# 18) Auth Check ใน Server Action

ทุก action ที่กระทบข้อมูลจริงควรมี auth check

ตัวอย่าง mental model:

```tsx
'use server'

export async function deletePost(formData: FormData) {
  const user = await requireUser()
  const id = formData.get('id')

  // check ownership / role
  // delete
}
```

กฎจำง่าย:

```text
ทุก mutation = auth + validation + authorization
```

---

# 19) Error Handling Strategy

มี 3 แนวทางหลัก

## A. return error object
เหมาะกับ form UX

```tsx
return { error: 'Title is required' }
```

## B. throw error
เหมาะกับ unexpected error

```tsx
throw new Error('Database failed')
```

## C. redirect
เหมาะกับ success flow ที่ไม่ต้องอยู่หน้าเดิม

```tsx
redirect('/products')
```

Production แนะนำให้:
- validation/business error -> return state
- unexpected/system error -> throw/log

---

# 20) Optimistic UI Mental Model

แม้ mutation จริงจะเกิดบน server  
UI ฝั่ง client สามารถทำ optimistic update ได้ในบางกรณี

เหมาะกับ:
- toggle like
- add todo
- quick form
- chat/send action

แต่ต้องมี rollback strategy ถ้า server fail

แนวคิด:

```text
UI เดาไว้ก่อน -> server ยืนยัน -> sync จริง
```

---

# 21) เมื่อไรไม่ควรใช้ Server Action

ไม่ใช่ทุกอย่างต้องใช้ Server Action

ไม่ควรใช้เมื่อ:
- ต้องการ public API ให้ external clients
- ต้องรองรับ mobile app หลายตัวเรียก endpoint เดียวกัน
- integration กับ third-party ต้องการ REST endpoint ชัดเจน
- stream/transport แบบเฉพาะทางที่ action ไม่เหมาะ

กรณีนี้ให้ใช้ Route Handlers หรือ backend service ปกติ

---

# 22) Pattern ตัวอย่าง: Create Product

## action
```tsx
'use server'

import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'

export async function createProduct(formData: FormData) {
  const title = String(formData.get('title') ?? '').trim()

  if (!title) {
    return { error: 'Title is required' }
  }

  // save to db

  revalidatePath('/products')
  redirect('/products')
}
```

## page
```tsx
import { createProduct } from '@/features/products/actions/create-product'

export default function NewProductPage() {
  return (
    <form action={createProduct} className="space-y-4">
      <input name="title" className="border px-3 py-2" />
      <button type="submit">Create</button>
    </form>
  )
}
```

---

# 23) Pattern ตัวอย่าง: Delete Button

สำหรับ action ที่มาจากปุ่มใน list:

```tsx
'use server'

import { revalidatePath } from 'next/cache'

export async function deleteProduct(formData: FormData) {
  const id = String(formData.get('id') ?? '')

  // auth check
  // delete

  revalidatePath('/products')
}
```

```tsx
export function DeleteForm({ id }: { id: string }) {
  return (
    <form action={deleteProduct}>
      <input type="hidden" name="id" value={id} />
      <button type="submit">Delete</button>
    </form>
  )
}
```

---

# 24) Architecture Recommendation

โครงสร้างแนะนำ:

```text
src/
  app/
    products/
      page.tsx
      new/
        page.tsx

  features/
    products/
      actions/
        create-product.ts
        delete-product.ts
      services/
        insert-product.ts
        remove-product.ts
      schemas/
        product.schema.ts
      components/
        product-form.tsx
        delete-form.tsx
```

แนวคิด:
- page = route composition
- action = mutation entrypoint
- service = DB/business operation
- schema = input validation
- component = UI

---

# 25) Server Actions + Data Fetching Strategy

ผูกกับเรื่องก่อนหน้าแบบนี้:

```text
อ่านข้อมูล = server fetch
แก้ข้อมูล = server action
refresh ข้อมูล = revalidatePath / revalidateTag
```

นี่คือ full loop ของ App Router

---

# 26) Common Mistakes

1. ไม่ validate input
2. ไม่ check auth/permission
3. export action แล้วคิดว่าคนภายนอกเรียกไม่ได้
4. ใช้ action แทน public API ทุกกรณี
5. ไม่มี revalidation ทำให้ข้อมูลหน้าจอ stale
6. ใส่ business logic ทุกอย่างใน action file จนพอง
7. ผูก action กับ client-heavy form โดยไม่จำเป็น

---

# 27) Best Practices

1. เริ่มจาก server form ก่อน ถ้า UI ไม่ซับซ้อน
2. validate บน server เสมอ
3. แยก schema / service / action
4. ใช้ `revalidatePath` หรือ `revalidateTag` หลัง mutation
5. ใช้ `redirect` เมื่อ flow ควรเปลี่ยนหน้า
6. ทำ auth + authorization ทุก mutation
7. ใช้ Route Handler แทนถ้าต้องเปิด API ภายนอก
8. คืนค่า error แบบอ่านง่ายสำหรับ form UX

---

# 28) Final Mental Model

```text
Server Action
= server-side mutation function
= form/action entrypoint
= validate + auth + save + revalidate + redirect
```

สูตรจำง่ายที่สุด:

```text
fetch = server component
mutate = server action
expose API = route handler
```

---

# 29) สรุปสุดท้าย

Server Actions ทำให้ Next.js App Router มี flow ที่ครบมาก:

```text
Page render -> server fetch
User submit -> server action
Action success -> revalidate / redirect
Page สดขึ้น -> UI ตรงกับ data ใหม่
```

นี่คือหนึ่งในแกนสำคัญที่สุดของ Next.js ยุค App Router
