# React + TypeScript Best Practices

คู่มือฉบับ production-grade สำหรับใช้ React กับ TypeScript อย่างเป็นระบบ  
โฟกัสที่ component, props, hooks, state modeling, forms, async state, composition, และ architecture ที่ดูแลง่ายในระยะยาว

---

# 1) Mental Model ใหญ่

สูตรจำง่าย:

```text
React = UI composition
TypeScript = contract + safety
```

เมื่อรวมกัน:

```text
React + TypeScript
= เขียน UI ที่อ่านง่าย
+ refactor ปลอดภัย
+ state model ชัด
+ component contract ชัด
```

---

# 2) หลักคิดสำคัญ

อย่ามองว่า TypeScript เป็นแค่ “ใส่ type ให้ครบ”  
แต่ให้มองว่า TypeScript คือเครื่องมือสำหรับ:

- อธิบาย contract ของ component
- จำกัด state ที่เป็นไปได้
- กัน misuse ของ props และ hooks
- ทำให้ refactor component tree ปลอดภัยขึ้น
- ทำให้ทีมเข้าใจ intent จาก type ได้ทันที

---

# 3) Props ต้องชัด แต่ไม่เยิ่นเย้อ

## ดี

```tsx
type ButtonProps = {
  label: string
  disabled?: boolean
  onClick?: () => void
}

export function Button({ label, disabled, onClick }: ButtonProps) {
  return (
    <button disabled={disabled} onClick={onClick}>
      {label}
    </button>
  )
}
```

## ไม่ดี

```tsx
type ButtonProps = any
```

หรือใส่ props กว้างเกินไปจนไม่บอก intent

Production rule:

```text
props ควรเล็ก ชัด และสะท้อนหน้าที่ของ component
```

---

# 4) ใช้ type alias กับ props ได้สบาย

สำหรับ React component props ใช้ `type` ได้ดีมาก

```tsx
type CardProps = {
  title: string
  children: React.ReactNode
}
```

จะใช้ `interface` ก็ได้ ถ้าทีมอยากยึด convention เดียว  
ประเด็นสำคัญกว่าคือ consistency

---

# 5) อย่าใช้ React.FC เป็น default

หลายทีมสมัยใหม่ไม่ใช้ `React.FC` เป็นค่าเริ่มต้น  
เพราะมันใส่ `children` มาให้ implicit และบางครั้งทำให้ contract ไม่ชัด

## แนะนำ

```tsx
type CardProps = {
  children: React.ReactNode
}

export function Card({ children }: CardProps) {
  return <div>{children}</div>
}
```

แทนที่จะ:

```tsx
const Card: React.FC = ({ children }) => { ... }
```

Production mindset:

```text
declare props ตรง ๆ ชัดกว่า
```

---

# 6) children ต้องระบุเมื่อ component รองรับจริง

## รองรับ children

```tsx
type ModalProps = {
  children: React.ReactNode
}
```

## ไม่รองรับ children
ไม่ต้องใส่

อย่าใส่ `children` ให้ทุก component โดยอัตโนมัติ

---

# 7) Event Types ควรระบุให้ถูก

## input change

```tsx
function handleChange(e: React.ChangeEvent<HTMLInputElement>) {
  console.log(e.target.value)
}
```

## form submit

```tsx
function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
  e.preventDefault()
}
```

## button click

```tsx
function handleClick(e: React.MouseEvent<HTMLButtonElement>) {
  console.log("clicked")
}
```

ข้อดี:
- autocomplete ถูก
- รู้ว่า target/type คืออะไร
- ลด assertion มั่ว

---

# 8) useState: ให้ type ชัดเมื่อจำเป็น

## infer ได้อยู่แล้ว

```tsx
const [count, setCount] = useState(0)
```

## ควรใส่ type เมื่อ state ซับซ้อน

```tsx
const [status, setStatus] = useState<"idle" | "loading" | "success" | "error">("idle")
```

หรือ:

```tsx
type User = {
  id: string
  name: string
}

const [user, setUser] = useState<User | null>(null)
```

Production rule:

```text
state ที่ primitive ง่าย ๆ ให้ infer
state ที่เป็น union/object สำคัญ ใส่ explicit type
```

---

# 9) อย่า model async state แบบ optional มั่ว

## ไม่ดี

```tsx
type ProductsState = {
  loading?: boolean
  items?: string[]
  error?: string
}
```

เพราะเกิด impossible state ได้ เช่น:
- loading = true และ items ก็มี
- error ก็มี แต่ success ก็มี

## ดี

```tsx
type ProductsState =
  | { status: "idle" }
  | { status: "loading" }
  | { status: "success"; items: string[] }
  | { status: "error"; message: string }
```

นี่คือ best practice สำคัญมาก

---

# 10) ใช้ discriminated union กับ UI state

ตัวอย่าง:

```tsx
type SubmitState =
  | { status: "idle" }
  | { status: "submitting" }
  | { status: "success" }
  | { status: "error"; message: string }
```

ใน render:

```tsx
if (state.status === "submitting") return <p>Saving...</p>
if (state.status === "error") return <p>{state.message}</p>
```

ข้อดี:
- state machine ชัด
- ลด bug
- React render branch อ่านง่ายมาก

---

# 11) useReducer เหมาะกับ state ซับซ้อน

ถ้า state หลาย field และเปลี่ยนหลายแบบ  
`useReducer` มักชัดกว่า `useState`

```tsx
type State = {
  count: number
}

type Action =
  | { type: "increment" }
  | { type: "decrement" }

function reducer(state: State, action: Action): State {
  switch (action.type) {
    case "increment":
      return { count: state.count + 1 }
    case "decrement":
      return { count: state.count - 1 }
  }
}
```

Production rule:

```text
state ง่าย -> useState
state ซับซ้อน + action หลายแบบ -> useReducer
```

---

# 12) ใช้ exhaustive check กับ reducer/state

```tsx
function assertNever(x: never): never {
  throw new Error(`Unexpected action: ${JSON.stringify(x)}`)
}

function reducer(state: State, action: Action): State {
  switch (action.type) {
    case "increment":
      return { count: state.count + 1 }
    case "decrement":
      return { count: state.count - 1 }
    default:
      return assertNever(action)
  }
}
```

ประโยชน์:
- เพิ่ม action ใหม่แล้วลืม handle -> TS เตือน

---

# 13) Custom Hooks ควรมี return contract ชัด

## ดี

```tsx
type UseCounterReturn = {
  count: number
  increment: () => void
  decrement: () => void
}

function useCounter(): UseCounterReturn {
  const [count, setCount] = useState(0)

  return {
    count,
    increment: () => setCount((c) => c + 1),
    decrement: () => setCount((c) => c - 1),
  }
}
```

นี่อ่านง่ายกว่า return array แบบไม่บอกความหมายใน hook ที่ซับซ้อน

---

# 14) Hook ที่คืน object มักอ่านง่ายกว่า tuple

## tuple เหมาะกับ built-in pattern เช่น `useState`

## custom hook ส่วนใหญ่แนะนำ object

```tsx
const { data, loading, error, refetch } = useProducts()
```

ดีกว่า:

```tsx
const [data, loading, error, refetch] = useProducts()
```

เพราะจำตำแหน่งยากและ refactor ยาก

---

# 15) อย่า export type มั่วจากทุกไฟล์ component

ทางที่ดี:
- type ที่ใช้เฉพาะในไฟล์ -> เก็บ local
- type ที่ใช้ข้าม feature -> ย้ายไป `types/`
- API/form/schema type -> แยกตาม concern

โครงสร้างที่ดี:

```text
features/
  products/
    types/
      product.ts
    components/
      product-card.tsx
    hooks/
      use-products.ts
```

---

# 16) แยก UI props ออกจาก domain model

## อย่าทำแบบนี้

```tsx
type Product = {
  id: string
  title: string
  price: number
  createdAt: string
  updatedAt: string
  internalFlag: boolean
}

function ProductCard(props: Product) { ... }
```

เพราะ card ไม่จำเป็นต้องรู้ทุก field

## ดีกว่า

```tsx
type ProductCardProps = {
  title: string
  price: number
}
```

Production rule:

```text
component รับเฉพาะข้อมูลที่มันต้องใช้
```

---

# 17) Prefer composition over giant prop surfaces

## ไม่ดี

```tsx
type ModalProps = {
  title: string
  description: string
  footerText: string
  primaryButtonLabel: string
  secondaryButtonLabel: string
  ...
}
```

## ดีกว่า

```tsx
type ModalProps = {
  title: string
  children: React.ReactNode
  footer?: React.ReactNode
}
```

ข้อดี:
- flexible
- reusable
- props surface เล็กลง

---

# 18) Forms: แยก form values type ให้ชัด

```tsx
type LoginFormValues = {
  email: string
  password: string
}
```

อย่าใช้ domain user type เป็น form type ตรง ๆ

เพราะ form:
- อาจมี string ทั้งหมด
- อาจมี field ชั่วคราว
- อาจมี confirmPassword

---

# 19) Forms + runtime validation

React + TS ยังไม่พอสำหรับ form ที่รับ input จาก user  
เพราะ TS ไม่ validate runtime

ตัวอย่างใช้ zod:

```tsx
import { z } from "zod"

export const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
})

export type LoginFormValues = z.infer<typeof loginSchema>
```

Pattern นี้ดีมากเพราะ:
- schema เป็น truth
- inferred type เป็น contract
- client/server ใช้ร่วมกันได้

---

# 20) useRef ต้องใส่ type ให้ถูก

```tsx
const inputRef = useRef<HTMLInputElement | null>(null)
```

เวลาจะใช้:

```tsx
inputRef.current?.focus()
```

อย่าใช้ `any` กับ ref ถ้าเลี่ยงได้

---

# 21) useMemo / useCallback อย่าใส่พร่ำเพรื่อ

TypeScript ไม่ได้ทำให้ `useMemo` หรือ `useCallback` จำเป็นขึ้น  
ยังคงใช้ก็ต่อเมื่อมีเหตุผลด้าน performance/identity จริง

Production rule:

```text
อย่า optimize ก่อนจำเป็น
แต่ถ้าใช้ ให้ type อินและเอาต์ชัด
```

---

# 22) Async data hooks ควรคืน state ที่ model ดี

```tsx
type UseProductsReturn =
  | { status: "loading" }
  | { status: "error"; message: string }
  | { status: "success"; items: string[] }
```

หรือถ้าใช้ library เช่น React Query / SWR ก็ยังควร map state ให้ UI ใช้ง่าย

---

# 23) Avoid `as` เมื่อยังไม่ได้ validate

## ไม่ดี

```tsx
const user = data as User
```

ถ้า `data` มาจาก API ภายนอก  
คุณยังไม่รู้จริงว่ามัน shape ตรงหรือไม่

## ดีกว่า
ใช้ schema validate ก่อน

```tsx
const parsed = userSchema.safeParse(data)
if (!parsed.success) {
  throw new Error("Invalid user")
}
const user = parsed.data
```

---

# 24) Component Variants ควร model ด้วย literal unions

```tsx
type ButtonVariant = "primary" | "secondary" | "danger"

type ButtonProps = {
  variant?: ButtonVariant
  label: string
}
```

ดีกว่า:

```tsx
variant?: string
```

เพราะ:
- autocomplete ดี
- จำกัดค่าที่รองรับ
- refactor theme/component ง่าย

---

# 25) Polymorphic components อย่าทำเร็วเกินไป

component แบบ `as` prop เช่น render เป็น `button`, `a`, `Link` ได้  
มีประโยชน์ แต่ typing ซับซ้อน

Production rule:

```text
เริ่มจาก component ธรรมดาก่อน
ทำ polymorphic เมื่อมี use case ชัดจริง
```

---

# 26) Context ควร type ชัดและกัน null ให้ดี

```tsx
type AuthContextValue = {
  user: { id: string; name: string } | null
  logout: () => void
}

const AuthContext = createContext<AuthContextValue | null>(null)
```

สร้าง custom hook ครอบ:

```tsx
function useAuth() {
  const ctx = useContext(AuthContext)
  if (!ctx) {
    throw new Error("useAuth must be used within AuthProvider")
  }
  return ctx
}
```

นี่เป็น best practice สำคัญมาก

---

# 27) Separate server data type from UI view model

ข้อมูลจาก API ไม่จำเป็นต้องตรงกับสิ่งที่ component อยากใช้

## API data

```ts
type ProductDto = {
  id: string
  title: string
  price_cents: number
}
```

## UI view model

```ts
type ProductCardViewModel = {
  id: string
  title: string
  priceLabel: string
}
```

map ก่อนส่งเข้า UI:

```ts
function toProductCardViewModel(dto: ProductDto): ProductCardViewModel {
  return {
    id: dto.id,
    title: dto.title,
    priceLabel: `$${(dto.price_cents / 100).toFixed(2)}`,
  }
}
```

ข้อดี:
- UI ง่ายขึ้น
- แยก concern ชัด

---

# 28) Keep component signatures small

ถ้า component props ใหญ่มาก  
ให้ถามว่า:
- component นี้ทำหลายหน้าที่เกินไปไหม
- ควร split component ไหม
- บาง prop ควรย้ายไป composition ไหม

Production rule:

```text
component ที่ดีมักมี API เล็กและชัด
```

---

# 29) Naming ที่ช่วยชีวิตทีม

แนะนำ naming แบบนี้:

- `Product` = domain model
- `ProductDto` = API payload
- `ProductCardProps` = component props
- `ProductFormValues` = form model
- `UseProductsReturn` = hook return type
- `CreateProductInput` = service input

อ่านแล้วรู้ boundary ทันที

---

# 30) React + TS กับ async actions

ถ้า component เรียก action / mutation  
return type ควร predictable

```ts
type ActionResult =
  | { ok: true }
  | { ok: false; message: string }
```

component จะจัดการง่าย:

```tsx
if (!result.ok) {
  setError(result.message)
}
```

ดีกว่า throw string หรือคืน shape มั่ว

---

# 31) Error boundary ไม่แทน typed state

Error boundary ดีสำหรับ unexpected errors  
แต่ไม่ควรแทน business state ปกติ เช่น:
- form invalid
- no data
- unauthorized
- not found

พวกนี้ควร model เป็น typed UI state หรือ typed result

---

# 32) แนะนำ pattern สำหรับ feature หนึ่งชุด

```text
features/
  products/
    types/
      product.ts
    schemas/
      product.schema.ts
    hooks/
      use-products.ts
    components/
      product-card.tsx
      product-list.tsx
      product-form.tsx
```

แนวคิด:
- `types/` = compile-time models
- `schemas/` = runtime truth
- `hooks/` = UI logic reuse
- `components/` = presentation

---

# 33) Example: Good typed component set

```tsx
type ProductCardProps = {
  title: string
  priceLabel: string
  onSelect?: () => void
}

export function ProductCard({
  title,
  priceLabel,
  onSelect,
}: ProductCardProps) {
  return (
    <button onClick={onSelect}>
      <h3>{title}</h3>
      <p>{priceLabel}</p>
    </button>
  )
}
```

จุดเด่น:
- props น้อย
- intent ชัด
- ไม่ผูกกับ DTO/raw API

---

# 34) Example: Good typed hook

```tsx
type UseToggleReturn = {
  value: boolean
  open: () => void
  close: () => void
  toggle: () => void
}

export function useToggle(initial = false): UseToggleReturn {
  const [value, setValue] = useState(initial)

  return {
    value,
    open: () => setValue(true),
    close: () => setValue(false),
    toggle: () => setValue((v) => !v),
  }
}
```

---

# 35) Example: Typed form + schema

```tsx
import { z } from "zod"

export const contactSchema = z.object({
  name: z.string().min(1),
  email: z.string().email(),
})

export type ContactFormValues = z.infer<typeof contactSchema>
```

```tsx
type ContactFormProps = {
  onSubmit: (values: ContactFormValues) => Promise<void>
}
```

---

# 36) Common Mistakes

1. ใช้ `any` ใน props/hook state
2. ใช้ API DTO ตรง ๆ ใน UI ทุกชั้น
3. state หลายสถานะแต่ใช้ optional field มั่ว
4. ใช้ `React.FC` ทุก component แบบไม่คิด
5. assert `as` โดยไม่ validate runtime data
6. component ใหญ่เกินและ props surface ใหญ่เกิน
7. export type มั่วจน structure เละ
8. ใช้ generic ซับซ้อนเกินความจำเป็น

---

# 37) Best Practices Checklist

- ใช้ explicit props type
- ไม่ใช้ `React.FC` เป็น default
- ใส่ `children` เฉพาะ component ที่รองรับจริง
- model UI state ด้วย discriminated union
- แยก form values / dto / domain / ui props
- ใช้ zod หรือ runtime validation กับ input ภายนอก
- ใช้ custom hook ที่คืน contract ชัด
- ใช้ context ผ่าน custom hook กัน null
- ให้ component รับเฉพาะข้อมูลที่ต้องใช้
- ให้ชื่อ type บอก boundary ชัด

---

# 38) Final Mental Model

```text
Props = contract ของ component
State = state machine ของ UI
Hooks = reusable UI logic
Schema = runtime truth
Types = compile-time contract
```

สูตรจำง่ายที่สุด:

```text
React ทำให้ UI แยกเป็นชิ้น
TypeScript ทำให้แต่ละชิ้นคุยกันอย่างปลอดภัย
```

---

# 39) สรุปสุดท้าย

React + TypeScript ที่ใช้ดี  
ไม่ใช่แค่ “component มี type”  
แต่คือการออกแบบทั้งระบบให้:

- props เล็กและชัด
- state model ถูกต้อง
- hook return อ่านง่าย
- form มี runtime validation
- UI ไม่ผูกกับ raw API shape
- refactor ได้อย่างมั่นใจ

เมื่อทำได้แบบนี้ codebase จะ:
- อ่านง่ายขึ้น
- เปลี่ยนแปลงง่ายขึ้น
- bug ลดลง
- onboarding ทีมง่ายขึ้น
- scale ได้ดีขึ้น
