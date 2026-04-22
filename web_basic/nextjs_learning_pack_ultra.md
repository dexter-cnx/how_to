# 🚀 Next.js Full Stack Learning Pack (Ultra Deep Version)
> Version: Expanded (10x depth) — Thai
> Target: Beginner → Intermediate Fullstack Developer

---

# 🧭 SECTION 1: Web Fundamentals (Deep Understanding)

## 🔹 HTML Deep Dive
HTML คือโครงสร้างของ Document Object Model (DOM)

### Key Concepts
- Tag
- Element
- Attribute
- Nesting
- Semantic HTML

### Example (Real Structure)
```html
<!DOCTYPE html>
<html>
  <head>
    <title>My App</title>
  </head>
  <body>
    <header>
      <h1>App</h1>
    </header>
    <main>
      <section>
        <article>
          <p>Hello</p>
        </article>
      </section>
    </main>
  </body>
</html>
```

### Semantic Importance
- SEO
- Accessibility
- Maintainability

---

## 🔹 CSS Deep Dive

### Concepts
- Box Model
- Flexbox
- Grid
- Responsive Design

### Example Flexbox
```css
.container {
  display: flex;
  justify-content: center;
  align-items: center;
}
```

---

## 🔹 JavaScript Deep Dive

### Core Concepts
- Variables
- Functions
- Closures
- Async/Await
- Promises

### Example Async
```js
async function load() {
  const res = await fetch('/api');
  const data = await res.json();
}
```

---

# ⚛️ SECTION 2: React (Mental Model)

## 🧠 React Philosophy
- UI = f(state)
- Declarative
- Component-driven

## 🔹 Component Types
- Presentational
- Container

## 🔹 State vs Props
| Type | Meaning |
|------|--------|
| Props | รับจาก parent |
| State | internal |

---

# ⚡ SECTION 3: Next.js Core

## 🧩 App Router
- File-based routing
- Nested layout
- Server-first rendering

---

## 🔹 Page vs Layout (Deep)

### Page
- entry point ของ route

### Layout
- shared tree structure

---

# 🧠 SECTION 4: Server vs Client (Important)

## Server Component
- run on server
- no JS bundle
- fetch directly

## Client Component
- interactive
- useState/useEffect

---

## 🔥 RULE (สำคัญมาก)
> Default = Server  
> Add Client only when needed

---

# 🔌 SECTION 5: Fullstack in Next.js

## API Route Structure
```
app/api/todos/route.ts
```

### Example
```ts
export async function GET() {
  return Response.json([{ id: 1 }]);
}
```

---

# 🏗 SECTION 6: Architecture (สำคัญสุด)

## Layer
- UI (component)
- Feature (logic)
- Service (API)
- Backend (route)

## Flow
```
UI → Feature → Service → API → DB
```

---

# 🧪 SECTION 7: Testing Thinking

- Unit test
- Integration
- E2E

---

# 🚨 SECTION 8: Common Mistakes (Expanded)

- ❌ fetch ใน component ตรง ๆ
- ❌ logic ปน UI
- ❌ ไม่แยก feature
- ❌ client component มากเกินไป

---

# 🛠 SECTION 9: Real Mini Project (Detailed)

## Todo App (Production Thinking)

### Feature Breakdown
- Create Todo
- Update Todo
- Delete Todo
- Filter Todo

### Folder
```
features/todos/
  components/
  services/
  hooks/
```

---

# 🤖 SECTION 10: AI Integration

## Prompt Example
```
Generate Next.js feature:
- App Router
- Service layer
- Clean architecture
```

---

# 🚀 SECTION 11: Next Steps

- Prisma
- Auth
- Deployment (Vercel)
- Performance optimization

---

# ✅ FINAL SUMMARY

คุณควรเข้าใจ:
- Web fundamentals
- React mental model
- Next.js structure
- Fullstack flow
- Architecture thinking

---

🔥 ถ้าคุณเข้าใจไฟล์นี้ = คุณเริ่มเป็น fullstack dev ได้แล้ว
