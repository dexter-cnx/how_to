# CSS Styling — คู่มือครบจบ (ฉบับ Production + Mental Model)

## 🧠 ภาพรวม
CSS = การกำหนดว่า UI “ดู + วาง + ขยับ” อย่างไร

- HTML → โครงสร้าง
- CSS → หน้าตา + layout
- JavaScript → behavior

---

## 🔷 6 แกนหลักของ CSS

1. Typography → ตัวอักษร
2. Box Model → กล่อง + spacing
3. Layout → การจัดวาง
4. Visual → สี + เอฟเฟกต์
5. Interaction → state / animation
6. Responsive → รองรับหลายหน้าจอ

---

# 1️⃣ Typography (ตัวอักษร)

```css
font-family: 'Inter', sans-serif;
font-size: 16px;
font-weight: 400;
line-height: 1.5;
letter-spacing: 0.5px;
text-align: center;
text-transform: uppercase;
```

### สำคัญ:
- font-family → ฟอนต์
- font-size → ขนาด
- font-weight → ความหนา
- line-height → ระยะบรรทัด
- letter-spacing → ระยะตัวอักษร
- text-align → จัดตำแหน่ง
- text-decoration → ขีดเส้น
- text-transform → เปลี่ยนรูปแบบตัวอักษร

👉 แนวคิด: readability + hierarchy

---

# 2️⃣ Box Model

โครงสร้าง:

```
[ margin ]
  [ border ]
    [ padding ]
      [ content ]
```

```css
.box {
  width: 200px;
  padding: 16px;
  border: 2px solid black;
  margin: 20px;
}
```

สำคัญมาก:

```css
box-sizing: border-box;
```

---

# 3️⃣ Layout

## Display

```css
display: block;
display: inline;
display: inline-block;
display: none;
```

---

## Flexbox

```css
.container {
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
  gap: 12px;
}
```

ใช้กับ:
- navbar
- row/column
- center element

---

## Grid

```css
.container {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
}
```

ใช้กับ:
- dashboard
- card layout
- complex UI

---

## Position

```css
position: static;
position: relative;
position: absolute;
position: fixed;
position: sticky;
```

```css
.top-right {
  position: absolute;
  top: 0;
  right: 0;
}
```

---

# 4️⃣ Visual Styling

## สี

```css
color: #333;
background-color: #f5f5f5;
```

## Border

```css
border: 1px solid #ddd;
border-radius: 12px;
```

## Shadow

```css
box-shadow: 0 4px 12px rgba(0,0,0,0.1);
```

## Background

```css
background-image: url('bg.jpg');
background-size: cover;
background-position: center;
```

---

# 5️⃣ Interaction

## Hover / Focus

```css
button:hover {
  background: blue;
}

input:focus {
  outline: none;
}
```

## Transition

```css
transition: all 0.3s ease;
```

## Animation

```css
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.box {
  animation: fadeIn 1s ease;
}
```

---

# 6️⃣ Responsive

## Media Query

```css
@media (max-width: 768px) {
  .container {
    flex-direction: column;
  }
}
```

## Units

- px → fixed
- % → relative
- em → relative font
- rem → root font
- vw/vh → screen size

---

# 7️⃣ Advanced

## Variables

```css
:root {
  --primary: #4f46e5;
}

button {
  background: var(--primary);
}
```

## Z-index

```css
z-index: 10;
```

## Overflow

```css
overflow: hidden;
overflow: auto;
```

## Cursor

```css
cursor: pointer;
```

---

# 🔥 Mental Model ขั้นสุด

1. Text → typography
2. Box → box model
3. Layout → flex / grid
4. Visual → color / shadow
5. Interaction → hover / animation
6. Responsive → media query

---

# 🧩 Example ครบระบบ

```css
.card {
  display: flex;
  flex-direction: column;
  padding: 16px;
  border-radius: 12px;
  background: white;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  transition: transform 0.2s ease;
}

.card:hover {
  transform: translateY(-4px);
}

.title {
  font-size: 18px;
  font-weight: 600;
}

@media (max-width: 768px) {
  .card {
    padding: 12px;
  }
}
```

---

# 🧠 สรุป

CSS = 3 Layer

- Structure → Box Model
- Layout → Flex / Grid
- Visual → Styling + Animation


---

# 8️⃣ Tailwind Mindset

Tailwind ไม่ได้เปลี่ยน “หลักการ CSS”  
แต่มันเปลี่ยน “วิธีคิดตอนเขียน CSS”

## แนวคิดหลัก

แทนที่จะเขียนแบบนี้:

```html
<div class="card">Hello</div>
```

```css
.card {
  padding: 16px;
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}
```

Tailwind จะเขียน style ตรงใน class:

```html
<div class="p-4 bg-white rounded-xl shadow-md">Hello</div>
```

---

## วิธีคิดแบบ Tailwind

### 1. คิดเป็น utility เล็ก ๆ
หนึ่ง class = หนึ่งหน้าที่

- `p-4` → padding
- `bg-white` → background color
- `rounded-xl` → border radius
- `shadow-md` → shadow
- `text-lg` → font size
- `font-semibold` → font weight

Tailwind mindset คือ:

> ไม่สร้าง class semantic เยอะเกินไป  
> แต่ประกอบ UI จาก utility class เล็ก ๆ

---

### 2. คิดเป็น Design Tokens
Tailwind ไม่ได้สุ่มค่าไปเรื่อย ๆ  
มันมี scale ที่ค่อนข้างเป็นระบบ เช่น spacing, font size, radius, shadow

ตัวอย่าง:
- `p-1 p-2 p-4 p-6 p-8`
- `text-sm text-base text-lg text-xl`
- `rounded-md rounded-lg rounded-xl`
- `shadow-sm shadow shadow-md shadow-lg`

แปลว่าเวลาใช้ Tailwind ให้คิดว่า:

> เรากำลังหยิบ “token” ที่ทีมตกลงกันแล้ว  
> ไม่ใช่ใส่ค่า ad-hoc มั่ว ๆ ทุก component

---

### 3. คิดจากนอกเข้าใน
เวลาทำ component ให้ไล่แบบนี้:

1. layout ก่อน
2. spacing
3. size
4. typography
5. visual
6. state

ตัวอย่าง:

```html
<button
  class="inline-flex items-center justify-center px-4 py-2 text-sm font-medium bg-indigo-600 text-white rounded-lg shadow hover:bg-indigo-700 transition"
>
  Save
</button>
```

แยกความหมาย:
- `inline-flex items-center justify-center` → layout
- `px-4 py-2` → spacing
- `text-sm font-medium` → typography
- `bg-indigo-600 text-white rounded-lg shadow` → visual
- `hover:bg-indigo-700 transition` → interaction

---

### 4. Mobile-first เป็น default
Tailwind ใช้แนวคิด responsive แบบ mobile-first

```html
<div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-4"></div>
```

ความหมาย:
- default = มือถือ 1 คอลัมน์
- `md:` = tablet/desktop กลาง 2 คอลัมน์
- `xl:` = จอใหญ่ 4 คอลัมน์

Mental model:

> เขียน default สำหรับจอเล็กก่อน  
> แล้วค่อย override ตอนจอใหญ่ขึ้น

---

### 5. State อยู่ใน class ได้เลย
Tailwind ทำให้ state ต่าง ๆ อ่านง่ายใน markup:

```html
<input class="border rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-indigo-500" />
<button class="bg-indigo-600 hover:bg-indigo-700 active:scale-95 disabled:opacity-50">
  Submit
</button>
```

ตัวอย่าง prefix ที่พบบ่อย:
- `hover:`
- `focus:`
- `active:`
- `disabled:`
- `dark:`
- `group-hover:`

---

### 6. Composition > Naming
CSS แบบเก่าชอบตั้งชื่อ class เช่น:

```css
.product-card {}
.product-card-title {}
.product-card-footer {}
```

Tailwind mindset จะเน้น “ประกอบจาก utility” มากกว่า “ตั้งชื่อทุกชิ้น”

เช่น:

```html
<div class="rounded-2xl border bg-white p-4 shadow-sm">
  <h3 class="text-lg font-semibold">Product</h3>
  <p class="mt-2 text-sm text-gray-600">Description</p>
  <div class="mt-4 flex items-center justify-between">
    <span class="text-base font-bold">$29</span>
    <button class="px-3 py-2 rounded-lg bg-black text-white">Buy</button>
  </div>
</div>
```

จุดเด่น:
- อ่านแล้วรู้หน้าตาทันที
- ไม่ต้องกระโดดไปหาไฟล์ CSS บ่อย
- refactor เร็ว

---

## Tailwind ไม่ใช่การไม่ต้องรู้ CSS

ตรงกันข้าม  
คนใช้ Tailwind ได้ดี ต้องเข้าใจ CSS ดี

เพราะ class เหล่านี้คือ wrapper ของ CSS:
- `flex` = `display: flex`
- `items-center` = `align-items: center`
- `justify-between` = `justify-content: space-between`
- `p-4` = `padding: 1rem`
- `rounded-xl` = `border-radius: ...`

ดังนั้น Tailwind คือ:

> CSS mindset ที่ถูกแปลงให้ใช้งานเร็วขึ้น

---

## Tailwind Mapping กับหมวด CSS

### Typography
- `text-sm`
- `text-lg`
- `font-medium`
- `font-bold`
- `leading-6`
- `tracking-wide`
- `text-center`

### Box Model / Spacing
- `p-4`
- `px-6`
- `py-2`
- `m-4`
- `mt-2`
- `w-full`
- `h-12`

### Layout
- `flex`
- `inline-flex`
- `grid`
- `grid-cols-3`
- `gap-4`
- `items-center`
- `justify-between`

### Visual
- `bg-white`
- `text-gray-900`
- `border`
- `rounded-xl`
- `shadow-md`
- `opacity-50`

### Interaction
- `hover:bg-blue-600`
- `focus:ring-2`
- `transition`
- `duration-200`
- `animate-pulse`

### Responsive
- `sm:`
- `md:`
- `lg:`
- `xl:`
- `2xl:`

---

## ตัวอย่างแปลงจาก CSS ปกติ → Tailwind

### CSS ปกติ

```css
.card {
  display: flex;
  flex-direction: column;
  padding: 16px;
  background: white;
  border-radius: 16px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}
.card:hover {
  transform: translateY(-4px);
}
.title {
  font-size: 18px;
  font-weight: 600;
}
```

### Tailwind

```html
<div class="flex flex-col p-4 bg-white rounded-2xl shadow-md hover:-translate-y-1 transition">
  <h3 class="text-lg font-semibold">Title</h3>
</div>
```

---

## ข้อดีของ Tailwind mindset

- เร็วมากในการทำ UI
- ลด context switching ระหว่าง HTML กับ CSS
- design consistency ดีขึ้น
- responsive/state เขียนง่าย
- refactor component-level ง่าย

---

## จุดที่ต้องระวัง

- class ยาวมากได้
- ถ้าไม่มีระบบ design token ที่ชัด จะเละได้เหมือนกัน
- ถ้า copy-paste utility โดยไม่คิด abstraction จะซ้ำเยอะ
- ต้องรู้จังหวะใช้ component abstraction เช่น `Button`, `Card`, `Input`

---

## Mental Model แบบสั้นที่สุด

เวลาเขียน Tailwind ให้คิดแบบนี้:

1. วาง layout ก่อน → `flex`, `grid`
2. ใส่ spacing → `p-4`, `gap-4`, `mt-2`
3. ใส่ typography → `text-sm`, `font-medium`
4. ใส่ visual → `bg-white`, `rounded-xl`, `shadow`
5. ใส่ state → `hover:`, `focus:`
6. ใส่ responsive → `md:`, `lg:`

สูตรจำง่าย:

> Tailwind = CSS utilities + design tokens + mobile-first + composition

---

## ตัวอย่าง production mindset

อย่าคิดแค่ว่า “ทำให้สวย”
ให้คิดว่า:

- token ไหนคือ spacing มาตรฐานของระบบ
- radius ไหนคือระดับ card / button / modal
- สีไหนคือ primary / secondary / muted
- breakpoint ไหนรองรับ device แบบไหน
- component ไหนควร abstract ออกมาใช้ซ้ำ

ตัวอย่าง component ที่ควร abstract:
- Button
- Input
- Card
- Modal
- Badge
- Table row
- Empty state

เพราะถึงแม้ Tailwind จะเป็น utility-first  
แต่ production app ยังต้องมี component system

---

## สรุป Tailwind Mindset

Tailwind ไม่ใช่แค่ syntax อีกแบบของ CSS  
แต่มันคือวิธีคิดว่า:

- style = การประกอบ utility
- utility = token ของระบบ
- responsive = mobile-first
- state = เขียนติดกับ element ได้
- component = ควร abstract เมื่อเริ่มใช้ซ้ำ
