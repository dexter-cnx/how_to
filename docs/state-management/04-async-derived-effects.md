# 04 — Async State, Derived State, Side Effects

## Async state
model ให้ explicit:
- loading
- data
- error
- refreshing
- appending

## Derived state
คำนวณจาก source-of-truth เช่น:
- total
- filtered list
- canSubmit

## Side effects
เช่น:
- navigation
- snackbar
- dialog

อย่าทำ side effects เป็น durable state แบบมั่ว เพราะอาจ replay ซ้ำได้
