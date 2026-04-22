# ⚛️ React Pro Pack (Production-Grade + Architecture + Next.js Bridge)

## 🧠 Core Philosophy

UI = f(state)

React = Declarative + Component-Based + Unidirectional Data Flow

---

# 🧱 Recommended Project Architecture

## Folder Structure (Scalable)

```
src/
  app/              # pages / routing (Next.js style)
  components/
    ui/             # pure UI (dumb)
    shared/         # reusable cross-feature
  features/
    auth/
      components/
      hooks/
      services/
    product/
  hooks/            # global hooks
  services/         # API layer
  store/            # state management
  styles/
  utils/
```

---

# 🧩 Component Architecture

## 3 Layers

1. UI Component (dumb)
2. Container (logic)
3. Hook (reusable logic)

---

## Example

### UI

```jsx
export function Button({ children, onClick }) {
  return <button onClick={onClick}>{children}</button>
}
```

### Hook

```js
export function useCounter() {
  const [count, setCount] = useState(0)
  return { count, inc: () => setCount(c => c+1) }
}
```

### Container

```jsx
export function Counter() {
  const { count, inc } = useCounter()
  return <Button onClick={inc}>{count}</Button>
}
```

---

# ⚛️ State Strategy

## 3 Types

1. Local state → useState
2. Server state → React Query / fetch
3. Global state → Zustand / Redux

---

## Rule

- UI state → local
- API state → server
- shared state → global

---

# 🔁 Rendering Model

React Flow:

```
event → setState → re-render → diff → update DOM
```

Optimization:

- React.memo
- useMemo
- useCallback

---

# ⚡ Hooks Deep Dive

## useEffect

```js
useEffect(() => {
  fetchData()
}, [])
```

## useMemo

```js
const value = useMemo(() => compute(), [dep])
```

## useCallback

```js
const fn = useCallback(() => {}, [dep])
```

---

# 🎨 Styling Strategy

## Tailwind + Design Token

```
tokens:
  spacing
  color
  radius
  shadow
```

Component example:

```jsx
<button class="px-4 py-2 bg-indigo-600 text-white rounded-lg">
  Save
</button>
```

---

# 🌐 API Layer

```
services/
  api.js
```

```js
export async function getProducts() {
  const res = await fetch("/api/products")
  return res.json()
}
```

---

# ⚛️ Next.js Mapping

| Concept | Next.js |
|--------|--------|
| Component | Page |
| Fetch | Server Component |
| State | Client Component |

---

## Server vs Client

### Server Component

- fetch data
- SEO
- no useState

### Client Component

- interaction
- hooks
- browser only

---

# 🧠 Performance Rules

- split component
- avoid prop drilling
- memo when needed
- lazy load

---

# 🐞 Debug Strategy

## React DevTools

- inspect state
- inspect props

## VS Code

- breakpoint
- debugger
- watch

---

# 📦 Production Checklist

- ESLint + Prettier
- TypeScript
- Error boundary
- Loading state
- Empty state
- API error handling

---

# 🤖 Prompt Pack (for AI Agents)

## Generate Component

```
Create React component using:
- Tailwind
- clean architecture
- separate hook
- reusable props
```

## Generate Feature

```
Generate feature folder:
- components
- hooks
- services
- example usage
```

---

# 🧠 Mental Model Final

```
Component = UI
Hook = logic
Service = data
State = truth
```

---

# 🚀 Summary

React Production Stack:

- React + Vite / Next.js
- Tailwind
- Zustand / React Query
- Clean Architecture

