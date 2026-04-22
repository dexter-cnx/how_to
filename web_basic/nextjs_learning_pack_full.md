# 🧠 Next.js Full Stack Learning Pack (Day 1–7) — ฉบับจัดเต็ม

> สำหรับผู้เริ่มจากศูนย์ → ไปถึงสร้าง Mini Fullstack App ได้จริง  
> โครงสร้างรองรับ Obsidian + ใช้ร่วมกับ AI (Codex / Claude)

---

# 🗺 Overview
- Day 1: Web Fundamentals (HTML/CSS/JS)
- Day 2: React Core
- Day 3: Next.js Routing (App Router)
- Day 4: Layout System
- Day 5: Server vs Client
- Day 6: API Routes (Backend)
- Day 7: Mini Project (Todo App)

---

# 📅 Day 1 — Web Fundamentals

## Concept
- HTML = โครงสร้าง
- CSS = หน้าตา
- JS = พฤติกรรม

## ตัวอย่าง
```html
<h1>Hello</h1>
<button onclick="alert('Hi')">Click</button>
```

## Exercise
- สร้างหน้า HTML
- เพิ่มปุ่ม + alert
- เพิ่ม CSS เปลี่ยนสี

## Goal
เข้าใจว่าเว็บ = structure + style + behavior

---

# 📅 Day 2 — React Basics

## Concept
- Component = function
- JSX = HTML-like syntax
- State = data ที่เปลี่ยนได้

## Example
```tsx
import { useState } from "react";

export default function Counter() {
  const [count, setCount] = useState(0);

  return (
    <button onClick={() => setCount(count + 1)}>
      {count}
    </button>
  );
}
```

## Exercise
- สร้าง Counter
- เพิ่มปุ่ม reset
- แยก component

## Goal
คิดแบบ component-based

---

# 📅 Day 3 — Next.js Routing

## Concept
- Folder = route

## Example
```
app/
 ├─ page.tsx -> /
 └─ about/page.tsx -> /about
```

## Exercise
- /about
- /contact
- link ไปมาระหว่างหน้า

## Goal
เข้าใจ routing แบบ filesystem

---

# 📅 Day 4 — Layout

## Concept
- layout.tsx = shared UI

## Example
```tsx
export default function Layout({ children }) {
  return (
    <div>
      <nav>Navbar</nav>
      {children}
    </div>
  );
}
```

## Exercise
- ทำ navbar
- ใช้ทุกหน้า

## Goal
แยก structure กับ content

---

# 📅 Day 5 — Server vs Client

## Concept
- Server = default (เร็ว, SEO ดี)
- Client = interactive

## Example Client
```tsx
"use client";
import { useState } from "react";
```

## Exercise
- Counter (client)
- fetch data (server)

## Goal
รู้ว่าอะไรควรอยู่ฝั่งไหน

---

# 📅 Day 6 — API Routes

## Concept
- Next.js = fullstack

## Example
```ts
export async function GET() {
  return Response.json({ msg: "Hello" });
}
```

## Exercise
- GET /api/hello
- POST /api/todo

## Goal
เข้าใจ backend ใน Next.js

---

# 📅 Day 7 — Mini Project: Todo App

## Features
- Add
- List
- Delete

## Structure
```
features/todos/
 ├─ components/
 ├─ services/
 └─ types.ts
```

## Flow
UI → service → API → response

---

# 🧠 Architecture Thinking

## Separation of Concerns
- UI ≠ Logic ≠ Data

## Good Practice
- Page = orchestration
- Feature = business logic
- Service = API call

---

# ⚠️ Common Mistakes
- ใส่ logic ใน component เยอะเกิน
- fetch API ใน UI ตรง ๆ
- ไม่แยก feature

---

# 🚀 Next Step
- Prisma + DB
- Auth
- Deploy

---

# 🤖 Prompt สำหรับ AI (ใช้กับ toolkit)

## Generate Feature
"Create a Next.js feature for todo CRUD using App Router, service layer, and clean architecture."

## Review Code
"Review this Next.js code for separation of concerns and performance."

---

# ✅ Summary
คุณควรทำได้:
- เข้าใจ web
- เขียน React
- ใช้ Next.js routing
- แยก server/client
- ทำ API
- สร้าง fullstack mini app

