# JavaScript Fundamentals — คู่มือพื้นฐานครบระบบ

## 🧠 JavaScript คืออะไร
JavaScript = ภาษาโปรแกรมที่ใช้ทำให้เว็บ “มีพฤติกรรม”

- HTML → โครงสร้าง
- CSS → หน้าตา
- JS → logic + interaction

---

## 🔷 Mental Model

1. Variables → เก็บข้อมูล
2. Data Types → รูปแบบข้อมูล
3. Operators → คำนวณ/เปรียบเทียบ
4. Control Flow → เงื่อนไข + loop
5. Functions → reusable logic
6. Objects & Arrays → โครงสร้างข้อมูล
7. DOM → คุม UI
8. Events → interaction
9. Async → งานไม่รอ
10. Modules → แยกไฟล์

---

# 1️⃣ Variables

```js
let name = "Dexter"
const age = 30
```

- let → เปลี่ยนค่าได้
- const → ควรใช้เป็น default

---

# 2️⃣ Data Types

Primitive:
- string
- number
- boolean
- null
- undefined

Complex:
- object
- array

---

# 3️⃣ Operators

```js
1 + 2
5 === 5
true && false
```

ใช้ === เป็นหลัก

---

# 4️⃣ Control Flow

```js
if (age > 18) {
  console.log("Adult")
}
```

Loop:

```js
for (let i = 0; i < 5; i++) {}
```

---

# 5️⃣ Functions

```js
const add = (a, b) => a + b
```

---

# 6️⃣ Object & Array

```js
const user = { name: "Dexter" }
const list = [1,2,3]
```

Methods:

```js
list.map(x => x*2)
list.filter(x => x>1)
```

---

# 7️⃣ DOM

```js
const el = document.querySelector("#btn")
el.innerText = "Click"
```

---

# 8️⃣ Events

```js
btn.addEventListener("click", () => {})
```

---

# 9️⃣ Async / Await

```js
async function load() {
  const res = await fetch("/api")
}
```

---

# 🔟 Modules

```js
export const add = (a,b)=>a+b
import { add } from "./math.js"
```

---

# 1️⃣1️⃣ Closure

```js
function counter() {
  let count = 0
  return () => count++
}
```

---

# 🧠 สรุป

JavaScript =

- Data
- Logic
- Interaction
