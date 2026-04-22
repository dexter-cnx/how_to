# TypeScript Pro Pack
> คู่มือ TypeScript แบบเข้มข้นสำหรับใช้เรียนจริง ทำงานจริง และต่อยอดสู่ React / Next.js / Node.js

---

# สารบัญ
1. TypeScript คืออะไร
2. ทำไมต้องใช้ TypeScript
3. TypeScript vs JavaScript
4. ติดตั้งและเริ่มโปรเจกต์
5. พื้นฐานชนิดข้อมูล
6. Type Inference และ Annotation
7. Union / Literal / Narrowing
8. Type Alias และ Interface
9. Function ใน TypeScript
10. Object, Optional, Readonly
11. Array, Tuple, Enum
12. Generics
13. Utility Types
14. Type Assertion, `as const`, `satisfies`
15. Classes และ OOP
16. Modules และการแยกไฟล์
17. Error Handling และ `unknown`
18. Type Guard
19. Advanced Types
20. TSConfig ที่ควรรู้
21. โครงสร้างโปรเจกต์ที่แนะนำ
22. Best Practices
23. React + TypeScript
24. Next.js + TypeScript
25. Node.js + TypeScript
26. Clean Architecture + TypeScript
27. Common Pitfalls
28. Mini Recipes
29. Checklist เวลารีวิวโค้ด
30. Roadmap การฝึก TypeScript

---

# 1) TypeScript คืออะไร

TypeScript คือ **superset ของ JavaScript** ที่เพิ่มระบบชนิดข้อมูล (type system) เข้าไป  
พูดง่าย ๆ คือคุณยังเขียนโค้ดแนว JavaScript ได้เหมือนเดิม แต่มีตัวช่วยตรวจความถูกต้องก่อนรันมากขึ้น

TypeScript ช่วยเรื่องสำคัญมาก ๆ เช่น

- รู้ว่าตัวแปรควรเก็บค่าอะไร
- ลด bug จากการส่งค่าผิดประเภท
- refactor ง่ายขึ้น
- IDE ช่วย autocomplete ได้แม่นขึ้น
- อ่านโค้ดทีมง่ายขึ้น

TypeScript ไม่ได้รันตรง ๆ ใน browser หรือ Node แบบดั้งเดิม  
โดยทั่วไปจะต้อง **compile/transpile** ออกมาเป็น JavaScript ก่อน

---

# 2) ทำไมต้องใช้ TypeScript

## ปัญหาของ JavaScript ล้วน ๆ
JavaScript ยืดหยุ่นมาก ซึ่งดีมากตอนเริ่มต้น แต่พอโปรเจกต์ใหญ่จะเกิดปัญหา เช่น

- ส่ง string ไปแทน number
- เรียก field ที่ไม่มีจริง
- object บางตัว shape ไม่ตรงกัน
- function รับ parameter ผิด แต่กว่าจะรู้คือตอน runtime

## สิ่งที่ TypeScript ช่วยได้
- จับ error ตั้งแต่ตอนเขียน
- บอก intent ของข้อมูลชัดเจน
- ช่วยทีมทำงานร่วมกันได้ง่าย
- ลด cognitive load เวลาย้อนกลับมาอ่านโค้ดเก่า
- เหมาะกับ codebase ขนาดกลางถึงใหญ่

---

# 3) TypeScript vs JavaScript

## JavaScript
- รันได้ทันที
- เรียนง่าย เริ่มไว
- ยืดหยุ่นมาก
- เสี่ยง runtime error มากกว่า

## TypeScript
- ต้องมี compile step
- มี type system
- ใช้เวลา setup เพิ่มนิดหน่อย
- ป้องกัน bug ได้เยอะมาก
- เหมาะกับงาน production

## ตัวอย่าง

### JavaScript
```js
function add(a, b) {
  return a + b;
}

add(10, "20"); // ได้ "1020"
```

### TypeScript
```ts
function add(a: number, b: number): number {
  return a + b;
}

add(10, "20"); // error
```

---

# 4) ติดตั้งและเริ่มโปรเจกต์

## ติดตั้ง TypeScript
```bash
npm install -D typescript
```

## สร้าง tsconfig
```bash
npx tsc --init
```

## compile
```bash
npx tsc
```

## รันไฟล์ TypeScript แบบ dev ง่าย ๆ
```bash
npm install -D tsx
npx tsx src/index.ts
```

---

# 5) พื้นฐานชนิดข้อมูล

```ts
const username: string = "Dexter";
const age: number = 30;
const isAdmin: boolean = false;
const nothing: null = null;
const notDefined: undefined = undefined;
```

## ชนิดสำคัญ
- `string`
- `number`
- `boolean`
- `null`
- `undefined`
- `bigint`
- `symbol`

---

# 6) Type Inference และ Annotation

## Inference
TypeScript เดา type ให้ได้ในหลายกรณี

```ts
const title = "Hello"; // string
const count = 42; // number
```

## Annotation
ใส่ type เองเมื่ออยากชัดเจน

```ts
let price: number = 100;
```

## ใช้เมื่อไร
- ถ้า inference ชัดอยู่แล้ว ไม่ต้องใส่ทุกตัว
- ถ้าเป็น function public API, model, return type ควรใส่
- ถ้า object ซับซ้อน ควร define type แยก

---

# 7) Union / Literal / Narrowing

## Union Type
ตัวแปรหนึ่งรับได้หลายแบบ

```ts
let id: string | number;
id = 1;
id = "abc";
```

## Literal Type
จำกัดค่าที่รับได้

```ts
type ThemeMode = "light" | "dark";
let mode: ThemeMode = "light";
```

## Narrowing
ตรวจเงื่อนไขแล้ว type แคบลง

```ts
function printId(id: string | number) {
  if (typeof id === "string") {
    console.log(id.toUpperCase());
  } else {
    console.log(id.toFixed(0));
  }
}
```

---

# 8) Type Alias และ Interface

## Type Alias
```ts
type User = {
  id: string;
  name: string;
  age: number;
};
```

## Interface
```ts
interface Product {
  id: string;
  title: string;
  price: number;
}
```

## ต่างกันยังไง
โดยใช้งานทั่วไปคล้ายกันมาก  
แนวคิดที่นิยม:

- `interface` เหมาะกับ object shape ที่อยาก extend ได้
- `type` เหมาะกับ union, mapped type, utility composition

## Extend
```ts
interface BaseUser {
  id: string;
  name: string;
}

interface AdminUser extends BaseUser {
  permissions: string[];
}
```

---

# 9) Function ใน TypeScript

## Parameter type
```ts
function greet(name: string) {
  return `Hello, ${name}`;
}
```

## Return type
```ts
function sum(a: number, b: number): number {
  return a + b;
}
```

## Optional parameter
```ts
function log(message: string, prefix?: string) {
  console.log(prefix ? `[${prefix}] ${message}` : message);
}
```

## Default parameter
```ts
function createUser(role: string = "user") {
  return { role };
}
```

## Function type
```ts
type MathOp = (a: number, b: number) => number;

const multiply: MathOp = (a, b) => a * b;
```

---

# 10) Object, Optional, Readonly

```ts
type Profile = {
  id: string;
  name: string;
  bio?: string;
  readonly createdAt: Date;
};
```

- `bio?` = field นี้อาจมีหรือไม่มีก็ได้
- `readonly` = ห้ามแก้หลังสร้าง

---

# 11) Array, Tuple, Enum

## Array
```ts
const tags: string[] = ["ts", "react"];
const scores: Array<number> = [10, 20, 30];
```

## Tuple
ใช้เมื่อตำแหน่งมีความหมาย

```ts
const point: [number, number] = [10, 20];
```

## Enum
มีได้ แต่หลายทีมปัจจุบันนิยมใช้ literal union แทน

```ts
enum Status {
  Idle,
  Loading,
  Success,
  Error,
}
```

แนว modern ที่อ่านง่ายกว่า:
```ts
type Status = "idle" | "loading" | "success" | "error";
```

---

# 12) Generics

Generics คือการเขียน type แบบ reusable

```ts
function identity<T>(value: T): T {
  return value;
}

const a = identity<string>("hello");
const b = identity<number>(123);
```

## Generic กับ array
```ts
function firstItem<T>(items: T[]): T | undefined {
  return items[0];
}
```

## Generic type alias
```ts
type ApiResponse<T> = {
  data: T;
  message: string;
  success: boolean;
};
```

ตัวอย่าง:
```ts
type User = {
  id: string;
  name: string;
};

const response: ApiResponse<User[]> = {
  data: [{ id: "1", name: "Dexter" }],
  message: "ok",
  success: true,
};
```

---

# 13) Utility Types

TypeScript มี utility types ที่ทรงพลังมาก

## Partial
เปลี่ยนทุก field ให้ optional
```ts
type User = {
  id: string;
  name: string;
  email: string;
};

type UpdateUser = Partial<User>;
```

## Required
เปลี่ยนทุก field ให้ required
```ts
type FullUser = Required<User>;
```

## Pick
เลือกบาง field
```ts
type UserPreview = Pick<User, "id" | "name">;
```

## Omit
ตัดบาง field ออก
```ts
type UserCreateInput = Omit<User, "id">;
```

## Record
สร้าง object ที่ key เป็นแบบกำหนด
```ts
type Role = "admin" | "editor" | "viewer";

const permissions: Record<Role, string[]> = {
  admin: ["read", "write", "delete"],
  editor: ["read", "write"],
  viewer: ["read"],
};
```

## ReturnType
```ts
function makeUser() {
  return { id: "1", name: "Dexter" };
}

type MadeUser = ReturnType<typeof makeUser>;
```

---

# 14) Type Assertion, `as const`, `satisfies`

## Type Assertion
บอก compiler ว่าเราแน่ใจ

```ts
const input = document.getElementById("email") as HTMLInputElement;
```

ใช้ได้ แต่ไม่ควรใช้พร่ำเพรื่อ เพราะอาจปิด error จริง

## `as const`
ทำให้ค่ากลายเป็น readonly literal

```ts
const config = {
  mode: "dark",
  pageSize: 20,
} as const;
```

## `satisfies`
ดีมากสำหรับ validate shape โดยยังคง literal type เอาไว้

```ts
type AppConfig = {
  mode: "light" | "dark";
  pageSize: number;
};

const config = {
  mode: "dark",
  pageSize: 20,
} satisfies AppConfig;
```

---

# 15) Classes และ OOP

```ts
class UserService {
  constructor(private apiUrl: string) {}

  getApiUrl(): string {
    return this.apiUrl;
  }
}
```

## Access modifier
- `public`
- `private`
- `protected`

## Interface กับ class
```ts
interface Animal {
  speak(): void;
}

class Dog implements Animal {
  speak() {
    console.log("woof");
  }
}
```

หมายเหตุ: ใน TypeScript/JavaScript สมัยใหม่ หลายทีมไม่ได้ยึด OOP หนักเสมอไป  
functional style + plain objects มักอ่านง่ายกว่าในหลายกรณี

---

# 16) Modules และการแยกไฟล์

## export
```ts
export type User = {
  id: string;
  name: string;
};

export function getUserName(user: User) {
  return user.name;
}
```

## import
```ts
import { getUserName, type User } from "./user";
```

แนวที่ดี:
- แยก model / service / utility ชัดเจน
- import `type` เมื่อ import มาใช้เฉพาะ type
- อย่าให้ไฟล์ใหญ่เกินไป

---

# 17) Error Handling และ `unknown`

`any` อันตรายมาก เพราะปล่อยผ่านทุกอย่าง  
ถ้าไม่รู้ชนิดจริง ควรใช้ `unknown`

```ts
function handleError(error: unknown) {
  if (error instanceof Error) {
    console.error(error.message);
  } else {
    console.error("Unknown error", error);
  }
}
```

## `any` vs `unknown`
- `any` = ปิดระบบตรวจ type
- `unknown` = ปลอดภัยกว่า ต้องตรวจสอบก่อนใช้

---

# 18) Type Guard

## `typeof`
```ts
function format(value: string | number) {
  if (typeof value === "string") {
    return value.trim();
  }
  return value.toFixed(2);
}
```

## `instanceof`
```ts
if (error instanceof Error) {
  console.log(error.message);
}
```

## `in`
```ts
type Cat = { meow: () => void };
type Dog = { bark: () => void };

function speak(pet: Cat | Dog) {
  if ("meow" in pet) {
    pet.meow();
  } else {
    pet.bark();
  }
}
```

## Custom type guard
```ts
type ApiError = {
  message: string;
  code: number;
};

function isApiError(value: unknown): value is ApiError {
  return (
    typeof value === "object" &&
    value !== null &&
    "message" in value &&
    "code" in value
  );
}
```

---

# 19) Advanced Types

## Intersection
```ts
type Timestamped = {
  createdAt: Date;
};

type User = {
  id: string;
  name: string;
};

type UserRecord = User & Timestamped;
```

## Discriminated Union
ทรงพลังมากสำหรับ state และ API result

```ts
type LoadingState = { status: "loading" };
type SuccessState = { status: "success"; data: string[] };
type ErrorState = { status: "error"; message: string };

type State = LoadingState | SuccessState | ErrorState;

function render(state: State) {
  switch (state.status) {
    case "loading":
      return "Loading...";
    case "success":
      return state.data.join(", ");
    case "error":
      return state.message;
  }
}
```

## Mapped Types
```ts
type Flags<T> = {
  [K in keyof T]: boolean;
};

type Features = {
  darkMode: () => void;
  analytics: () => void;
};

type FeatureFlags = Flags<Features>;
```

## `keyof`
```ts
type User = {
  id: string;
  name: string;
};

type UserKey = keyof User; // "id" | "name"
```

## Indexed Access Types
```ts
type User = {
  id: string;
  profile: {
    email: string;
  };
};

type Email = User["profile"]["email"];
```

---

# 20) TSConfig ที่ควรรู้

ไฟล์ `tsconfig.json` สำคัญมาก เพราะกำหนดกติกาของ project

ตัวอย่างแนว strict ที่แนะนำ:

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "Bundler",
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,
    "skipLibCheck": true,
    "isolatedModules": true,
    "esModuleInterop": true
  }
}
```

## options สำคัญ
- `strict`: เปิดโหมดเข้ม
- `noImplicitAny`: ห้าม any แบบแอบ ๆ
- `strictNullChecks`: null/undefined ต้องชัด
- `noUncheckedIndexedAccess`: index access ปลอดภัยขึ้น
- `exactOptionalPropertyTypes`: optional field แม่นขึ้น
- `isolatedModules`: สำคัญกับ bundler สมัยใหม่
- `skipLibCheck`: ทำให้ build เร็วขึ้น

---

# 21) โครงสร้างโปรเจกต์ที่แนะนำ

```text
src/
  app/
  modules/
    user/
      models/
      services/
      hooks/
      components/
      types.ts
  shared/
    types/
    utils/
    constants/
  index.ts
```

## แนวคิด
- type ที่เฉพาะ module ให้อยู่ใกล้ module
- shared type ค่อยย้ายไป `shared/types`
- อย่าสร้าง `types/` กลางแบบมั่วรวมทุกอย่างเร็วเกินไป

---

# 22) Best Practices

## 1. เปิด strict mode
อย่าปิด strict ง่าย ๆ เพื่อให้ error หาย

## 2. หลีกเลี่ยง `any`
ใช้ `unknown`, union, generic, type guard แทน

## 3. ใช้ literal union แทน enum ในหลายกรณี
```ts
type Theme = "light" | "dark";
```

## 4. แยก type ให้มีชื่อเมื่อ object เริ่มซับซ้อน
```ts
type CreateOrderInput = {
  customerId: string;
  items: OrderItem[];
};
```

## 5. ใช้ discriminated union สำหรับ state
เหมาะมากกับ UI state / request state

## 6. อย่า over-engineer
ไม่ต้องเขียน generic ซับซ้อนเกินจำเป็น

## 7. อย่า assert type มั่ว
`as Something` มากเกินไปคือกลิ่นไม่ดี

## 8. ระวัง `null` และ `undefined`
ออกแบบ data flow ให้ชัด

## 9. เขียน function ให้รับ input ชัด และ return ชัด
public API ทุกตัวควรอ่านแล้วเข้าใจทันที

## 10. ให้ type บอก intent ของ business domain
type ดีไม่ใช่แค่ผ่าน compiler แต่ต้องช่วยคนอ่านเข้าใจระบบ

---

# 23) React + TypeScript

## Props typing
```tsx
type ButtonProps = {
  label: string;
  onClick: () => void;
  disabled?: boolean;
};

export function Button({ label, onClick, disabled = false }: ButtonProps) {
  return (
    <button onClick={onClick} disabled={disabled}>
      {label}
    </button>
  );
}
```

## useState
```tsx
const [count, setCount] = useState<number>(0);
```

## API state with union
```tsx
type UserState =
  | { status: "idle" }
  | { status: "loading" }
  | { status: "success"; data: { id: string; name: string }[] }
  | { status: "error"; message: string };
```

## React best practice
- type props ชัด
- อย่าใช้ `React.FC` ถ้าไม่จำเป็น
- ระวัง event type
- สร้าง reusable type สำหรับ form/model

---

# 24) Next.js + TypeScript

Next.js รองรับ TypeScript ดีมาก

## route component
```tsx
export default function Page() {
  return <div>Hello</div>;
}
```

## typed params
```tsx
type PageProps = {
  params: {
    slug: string;
  };
};

export default function BlogPage({ params }: PageProps) {
  return <div>{params.slug}</div>;
}
```

## data typing
```ts
type Post = {
  id: string;
  title: string;
};
```

## แนวคิดสำคัญ
- แยก server-side model กับ client-side UI model เมื่อจำเป็น
- validate data จาก API/DB ก่อนเชื่อ type
- TypeScript ไม่ได้แทน runtime validation

---

# 25) Node.js + TypeScript

## เริ่มต้นเร็ว
```bash
npm init -y
npm install -D typescript tsx @types/node
npx tsc --init
```

## ตัวอย่าง
```ts
import http from "node:http";

const server = http.createServer((req, res) => {
  res.writeHead(200, { "content-type": "application/json" });
  res.end(JSON.stringify({ ok: true }));
});

server.listen(3000, () => {
  console.log("Server running on port 3000");
});
```

## สิ่งที่ควรทำ
- แยก env parsing
- validate request body
- หลีกเลี่ยง any จาก external data
- สร้าง domain types ชัดเจน

---

# 26) Clean Architecture + TypeScript

ตัวอย่างชั้นหลัก ๆ

```text
src/
  domain/
    entities/
    repositories/
    usecases/
  data/
    repositories/
    datasources/
    dto/
  presentation/
    components/
    pages/
  shared/
```

## หลักคิด
- `domain` ไม่ควรรู้จัก framework
- `data` แปลง DTO → domain model
- `presentation` ใช้ domain/usecase ผ่าน interface
- type ควรสะท้อน boundary ของแต่ละ layer

## ตัวอย่าง DTO vs Domain
```ts
type UserDto = {
  user_id: string;
  full_name: string;
};

type User = {
  id: string;
  name: string;
};

function toUser(dto: UserDto): User {
  return {
    id: dto.user_id,
    name: dto.full_name,
  };
}
```

---

# 27) Common Pitfalls

## 1. ใช้ `any` เยอะเกิน
ผลคือเหมือนกลับไปเขียน JS

## 2. เชื่อ external data มากเกินไป
API บอกว่าเป็น `User` ไม่ได้แปลว่าของจริงเป็น `User`

## 3. ใช้ type assertion แก้ทุกปัญหา
ทำให้ compiler เงียบ แต่ bug ยังอยู่

## 4. สร้าง generic ซับซ้อนเกินเหตุ
type-level programming ที่อ่านยาก อาจไม่คุ้ม

## 5. ไม่เปิด strict mode
เสียประโยชน์หลักของ TypeScript

## 6. ใช้ optional จน data model เละ
ควรกำหนดให้ชัดว่า field ไหนควรมีเสมอ

---

# 28) Mini Recipes

## Recipe: API Result
```ts
type Result<T> =
  | { ok: true; data: T }
  | { ok: false; error: string };

function parseUser(json: unknown): Result<{ id: string; name: string }> {
  if (
    typeof json === "object" &&
    json !== null &&
    "id" in json &&
    "name" in json
  ) {
    return {
      ok: true,
      data: {
        id: String((json as { id: unknown }).id),
        name: String((json as { name: unknown }).name),
      },
    };
  }

  return { ok: false, error: "Invalid user payload" };
}
```

## Recipe: Dictionary
```ts
type UserMap = Record<string, { id: string; name: string }>;
```

## Recipe: Sort key
```ts
type SortOrder = "asc" | "desc";
```

## Recipe: Reusable ID type
```ts
type UserId = string;
type OrderId = string;
```

---

# 29) Checklist เวลารีวิวโค้ด

## Type Safety
- มี `any` ไหม
- ใช้ `unknown` แทนได้ไหม
- external data ถูก validate ไหม
- function public API มี return type ชัดไหม

## Data Modeling
- type ชื่อสื่อความหมายไหม
- DTO กับ domain model แยกหรือยัง
- optional field ใช้เกินจำเป็นไหม

## Maintainability
- type ซับซ้อนเกินไปไหม
- มี type ซ้ำหลายที่ไหม
- generic อ่านแล้วเข้าใจไหม

## React/Next
- props type ชัดไหม
- state ใช้ union ได้ดีกว่า boolean หลายตัวไหม
- client/server boundary ชัดไหม

---

# 30) Roadmap การฝึก TypeScript

## ระดับ 1: Beginner
- primitive types
- object / array
- function typing
- union
- interface / type

## ระดับ 2: Intermediate
- generics
- utility types
- type guard
- discriminated union
- tsconfig strict mode

## ระดับ 3: Advanced
- mapped types
- conditional types
- indexed access types
- reusable architecture patterns
- runtime validation integration

## ระดับ 4: Production
- domain modeling
- API boundary typing
- React/Next patterns
- Node service contracts
- shared package types
- monorepo type strategy

---

# สรุปสั้นแบบใช้งานจริง

ถ้าจะใช้ TypeScript ให้คุ้มที่สุด:

1. เปิด strict mode
2. หลีกเลี่ยง `any`
3. ใช้ union และ discriminated union ให้เป็น
4. ใช้ generic เท่าที่จำเป็น
5. แยก domain model, DTO, UI model ให้ชัด
6. อย่าเชื่อ external data โดยไม่มี validation
7. ให้ type ช่วยสื่อ business meaning ไม่ใช่แค่ทำให้ compile ผ่าน

---

# แนวทางฝึกต่อทันที

## แบบฝึก 1
ทำฟังก์ชัน `formatPrice(price, currency)` โดยกำหนด type ให้ชัด

## แบบฝึก 2
ทำ `ApiResponse<T>` แล้วใช้กับ users/posts/orders

## แบบฝึก 3
สร้าง React component รับ props แบบ optional + union

## แบบฝึก 4
ออกแบบ state loading/success/error ด้วย discriminated union

## แบบฝึก 5
แยก DTO → domain model ใน mock API project

---

# Cheat Sheet

## Primitive
```ts
let name: string;
let age: number;
let active: boolean;
```

## Object
```ts
type User = {
  id: string;
  name: string;
};
```

## Function
```ts
function add(a: number, b: number): number {
  return a + b;
}
```

## Union
```ts
let value: string | number;
```

## Generic
```ts
type Box<T> = { value: T };
```

## Utility
```ts
Partial<T>
Required<T>
Pick<T, K>
Omit<T, K>
Record<K, T>
```

---

# ปิดท้าย

TypeScript ไม่ได้ทำให้โค้ด “เทพ” โดยอัตโนมัติ  
แต่มันทำให้คุณสร้างระบบที่ **อ่านง่ายขึ้น ปลอดภัยขึ้น ขยายง่ายขึ้น** ได้จริง  
ถ้าใช้ถูกวิธี มันคือเครื่องมือที่ช่วยให้ codebase โตโดยไม่พังง่าย

และจุดสำคัญที่สุดคือ:

> Type ที่ดี ไม่ใช่แค่ type ที่ compiler พอใจ  
> แต่คือ type ที่ทำให้ “มนุษย์” เข้าใจระบบได้เร็วขึ้นด้วย
