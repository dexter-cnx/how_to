# พื้นฐาน Web Dev สำหรับ Next.js (ภาษาไทย)

## 1. HTML / CSS / JavaScript คืออะไร

### HTML (HyperText Markup Language)
- เป็น “โครงสร้าง” ของเว็บ
- ใช้กำหนดว่าในหน้าเว็บมีอะไรบ้าง เช่น หัวข้อ, ปุ่ม, รูปภาพ, ฟอร์ม

ตัวอย่าง:
```html
<h1>Hello World</h1>
<button>Click me</button>
```

---

### CSS (Cascading Style Sheets)
- เป็น “หน้าตา/สไตล์” ของเว็บ
- ใช้ตกแต่งสี ขนาด layout animation

ตัวอย่าง:
```css
h1 {
  color: blue;
}
```

---

### JavaScript (JS)
- เป็น “สมอง/logic” ของเว็บ
- ใช้ควบคุมพฤติกรรม เช่น click, fetch API, validation

ตัวอย่าง:
```js
button.onclick = () => {
  alert("Clicked!");
};
```

---

### สรุป
- HTML = โครงสร้าง
- CSS = หน้าตา
- JS = พฤติกรรม

---

## 2. React Component คืออะไร

React = library สำหรับสร้าง UI แบบ component-based

### Component คืออะไร
- คือ “ชิ้นส่วน UI ที่ reusable ได้”
- เช่น Button, Card, Navbar

ตัวอย่าง:
```tsx
function Button() {
  return <button>Click me</button>;
}
```

### การใช้งาน:
```tsx
<Button />
```

---

### จุดสำคัญ
- Component = function
- return JSX (HTML-like syntax)
- ใช้ซ้ำได้
- แยก logic กับ UI ได้ดี

---

## 3. page กับ layout ใน Next.js คืออะไร

Next.js (App Router) ใช้ folder เป็น routing

### page.tsx
- คือ “หน้าเว็บจริง”
- ทุก route ต้องมี page.tsx

ตัวอย่าง:
```
app/
 ├─ page.tsx        -> "/"
 └─ about/
     └─ page.tsx    -> "/about"
```

---

### layout.tsx
- คือ “โครง layout ที่ใช้ร่วมกัน”
- เช่น header, sidebar, footer

ตัวอย่าง:
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

---

### ความต่าง
| page | layout |
|------|--------|
| content ของหน้า | wrapper ของหลายหน้า |
| เปลี่ยนตาม route | ใช้ร่วมกัน |
| มี data ของตัวเอง | ครอบ children |

---

## 4. Server Component vs Client Component

Next.js แยก component เป็น 2 แบบ

---

### Server Component (default)
- รันบน server
- ไม่มี JavaScript ส่งไป browser
- เหมาะกับ:
  - fetch data
  - SEO
  - performance

ตัวอย่าง:
```tsx
export default async function Page() {
  const data = await fetch("https://api.com").then(res => res.json());
  return <div>{data.name}</div>;
}
```

---

### Client Component
- รันบน browser
- ใช้ state, event, interactivity ได้

ต้องใส่:
```tsx
"use client";
```

ตัวอย่าง:
```tsx
"use client";

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

---

### เปรียบเทียบ

| Feature | Server | Client |
|--------|--------|--------|
| run ที่ไหน | server | browser |
| useState | ❌ | ✅ |
| onClick | ❌ | ✅ |
| fetch data | ✅ ดีมาก | ทำได้ |
| performance | สูง | ต่ำกว่า |

---

### แนวคิดสำคัญ
- ใช้ Server เป็น default
- ใช้ Client เฉพาะจุดที่ต้อง interactive

---

## สรุปทั้งหมด

- HTML/CSS/JS = พื้นฐาน web
- React = สร้าง UI แบบ component
- Next.js = framework ที่จัด routing + server/client
- page = หน้า
- layout = โครง
- Server Component = เร็ว, backend style
- Client Component = interactive

---

## Step ต่อไป
- ทำ Todo App
- ใช้ route + component + API
- เริ่ม full stack จริง
