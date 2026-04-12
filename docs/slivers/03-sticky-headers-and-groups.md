# 03 — Sticky Headers และ SliverMainAxisGroup

sticky header ที่ดีต้องตอบคำถามว่า:
- sticky เมื่อไร
- หายไปพร้อมอะไร
- ownership อยู่กับ section ไหน

## `SliverPersistentHeader`
เหมาะกับ:
- section header
- sticky filters
- category bar
- search bar ที่ตอบสนองต่อ scroll

## `SliverMainAxisGroup`
ใช้เมื่อหลาย slivers ต้อง behave เป็น section เดียวกัน เช่น:
- header + list
- header + grid
- header + list + footer

```dart
SliverMainAxisGroup(
  slivers: [
    SliverPersistentHeader(...),
    SliverGrid(...),
  ],
)
```

## ปัญหาที่พบบ่อย
- sticky header แต่ไม่สัมพันธ์กับ section จริง
- pinned header โดยไม่ group section
- delegate ทำงานหนักเกินใน `build()`
