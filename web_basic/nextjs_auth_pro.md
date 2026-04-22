# Next.js Auth Pro (Production Guide)

คู่มือฉบับ production-grade สำหรับระบบ Authentication/Authorization ใน Next.js App Router  
ครอบคลุม: mental model, session, cookie, server/client, proxy, route handler, server action, และ architecture จริง

---

# 1) Mental Model ใหญ่

Auth = identity + session + permission

---

# 2) Auth Flow

Login → Server Action → validate → set cookie → redirect → read cookie → allow/deny

---

# 3) Session Strategy

## Cookie-based (recommended)
browser → cookie → server → identify user

## Token-based
client → token → server verify

---

# 4) Cookie Best Practice

httpOnly = true  
secure = true  
sameSite = lax/strict  

---

# 5) Login (Server Action)

```tsx
'use server'

import { cookies } from 'next/headers'
import { redirect } from 'next/navigation'

export async function login(formData: FormData) {
  const email = formData.get('email')

  if (!email) {
    return { error: 'Invalid' }
  }

  cookies().set('session', 'user-id', {
    httpOnly: true,
  })

  redirect('/dashboard')
}
```

---

# 6) Read Session

```tsx
import { cookies } from 'next/headers'

const session = cookies().get('session')
```

---

# 7) Proxy Guard

```tsx
if (!session) redirect('/login')
```

---

# 8) Authorization

```tsx
if (user.role !== 'admin') throw new Error('Forbidden')
```

---

# 9) Protect API

```tsx
if (!user) return 401
```

---

# 10) Logout

```tsx
cookies().delete('session')
```

---

# 11) Architecture

features/auth/actions  
features/auth/services  
features/auth/schemas  

---

# 12) Final Mental Model

Auth = cookie + server check + permission
