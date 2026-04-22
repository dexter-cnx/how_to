# Next.js Server vs Client Components (Pro Guide)

## 🧠 Core Concept

Server Component = run on server  
Client Component = run in browser  

---

## 🔥 Mental Model

Server → data + render  
Client → interaction + state  

---

# 1️⃣ Server Component

## Definition
Component ที่รันบน server (default ใน App Router)

## Features
- fetch data ได้
- access DB ได้
- SEO ดี
- bundle = 0 JS
- ใช้ hook ไม่ได้

## Example

```tsx
export default async function Page() {
  const res = await fetch("https://dummyjson.com/products")
  const data = await res.json()

  return <div>{data.products.length}</div>
}
```

---

# 2️⃣ Client Component

## Definition
Component ที่รันใน browser

ต้องใส่:

```tsx
'use client'
```

## Features
- ใช้ useState/useEffect ได้
- มี event handler
- ใช้ browser API ได้
- bundle ใหญ่ขึ้น

## Example

```tsx
'use client'

import { useState } from 'react'

export default function Counter() {
  const [count, setCount] = useState(0)

  return (
    <button onClick={() => setCount(count + 1)}>
      {count}
    </button>
  )
}
```

---

# 3️⃣ Decision Rule

```
มี interaction → client
ไม่มี → server
```

---

# 4️⃣ Composition Pattern

Server → Client

```tsx
// server
export default async function Page() {
  const data = await fetchData()
  return <ClientList data={data} />
}
```

```tsx
'use client'
export function ClientList({ data }) {
  return data.map(item => <div>{item.name}</div>)
}
```

---

# 5️⃣ Hydration

HTML จาก server → React attach event → interactive

---

# 6️⃣ Performance

Server:
- เร็ว
- SEO ดี
- JS น้อย

Client:
- interactive
- bundle มากขึ้น

---

# 7️⃣ Common Mistakes

❌ ใช้ useState ใน server  
❌ ใช้ window ใน server  
❌ ใส่ 'use client' ทุกไฟล์  
❌ fetch ใน client โดยไม่จำเป็น  

---

# 8️⃣ Best Practice

- default ใช้ server
- แยก client เฉพาะ interactive
- ส่ง data ผ่าน props
- ลด bundle

---

# 🧠 Final Mental Model

Server = data + render  
Client = interaction  

