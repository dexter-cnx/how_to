# 02 — Composition และการคิดเป็น Sections

หน้าจอ production ควรถูกออกแบบเป็น sections ไม่ใช่กอง widget

## ตัวอย่าง sections
- page identity
- filters
- featured content
- list/grid หลัก
- footer / empty state

## Sliver ที่ใช้บ่อย
- `SliverAppBar`
- `SliverPersistentHeader`
- `SliverList`
- `SliverGrid`
- `SliverToBoxAdapter`
- `SliverFillRemaining`

## ตัวอย่าง pattern
```dart
CustomScrollView(
  slivers: [
    SliverAppBar(...),
    SliverPersistentHeader(...),
    SliverGrid(...),
    SliverList(...),
  ],
)
```

## ทำไมต้องคิดเป็น section
- เปลี่ยน requirement เฉพาะส่วนได้ง่าย
- sticky behavior คิดง่ายขึ้น
- testability สูงขึ้น
- รู้ว่า sliver type ไหนเหมาะกับอะไร
