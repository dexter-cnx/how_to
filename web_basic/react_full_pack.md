# React Full Pack — พื้นฐานถึงใช้งานจริง (VS Code + Debug + Setup)

## 🧠 React คืออะไร
React = library สำหรับสร้าง UI แบบ component-based

UI = f(state)

---

# 🧩 Component คืออะไร

Component = function ที่ return JSX

```jsx
function Hello() {
  return <h1>Hello</h1>
}
```

ใช้:
```jsx
<Hello />
```

---

# 🔷 Props

```jsx
function Greeting({ name }) {
  return <h1>Hello {name}</h1>
}
```

---

# 🔷 State

```jsx
import { useState } from "react"

function Counter() {
  const [count, setCount] = useState(0)
  return <button onClick={() => setCount(count+1)}>{count}</button>
}
```

---

# ⚙️ Setup Environment

## 1. Install Node.js (LTS)
https://nodejs.org

## 2. Install VS Code
https://code.visualstudio.com

Recommended Extensions:
- ES7 React Snippets
- Prettier
- ESLint

---

# 🚀 Create React App (Vite)

```bash
npm create vite@latest my-app
cd my-app
npm install
npm run dev
```

---

# 📁 Project Structure

```
src/
  App.jsx
  main.jsx
  index.css
```

---

# 🧪 First App Example

```jsx
import { useState } from "react"

export default function App() {
  const [count, setCount] = useState(0)

  return (
    <div>
      <h1>{count}</h1>
      <button onClick={() => setCount(count+1)}>+</button>
    </div>
  )
}
```

---

# 🐞 Debug ใน VS Code

## วิธี 1: JavaScript Debug Terminal
- เปิด Terminal
- เลือก JavaScript Debug Terminal
- run:
```bash
npm run dev
```

## วิธี 2: launch.json

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "chrome",
      "request": "launch",
      "name": "React Debug",
      "url": "http://localhost:5173",
      "webRoot": "${workspaceFolder}/src"
    }
  ]
}
```

---

# 🎯 Breakpoint

## คลิกซ้ายที่บรรทัด
หรือใช้:

```js
debugger;
```

---

# 🔍 Debug Tools

- Variables
- Watch
- Call Stack
- Debug Console

---

# 📦 React DevTools

ใช้ดู:
- component tree
- state
- props

---

# 🧠 Mental Model

1. Component = function
2. Props = input
3. State = data
4. Event = trigger
5. Re-render = update UI

---

# 📅 Learning Plan (7 วัน)

Day 1: JSX + Component  
Day 2: Props  
Day 3: State  
Day 4: List + Condition  
Day 5: Form  
Day 6: useEffect  
Day 7: Mini Project  

---

# 🧠 สรุป

React = Component + State + Props + Event + Re-render
