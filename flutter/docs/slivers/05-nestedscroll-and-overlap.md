# 05 — NestedScrollView และ Overlap

`NestedScrollView` ไม่ได้ดีกว่า `CustomScrollView` แต่มันเหมาะกับปัญหาคนละแบบ

## ใช้เมื่อ
- มี shared collapsible header
- มี `TabBarView`
- แต่ละแท็บมี scroll state ของตัวเอง

## อย่าใช้เมื่อ
- ทั้งหน้าควร scroll ร่วมกัน
- tabs เป็นแค่ quick navigation ไป sections เดียวกัน

## overlap tools
- `SliverOverlapAbsorber`
- `SliverOverlapInjector`

ใช้เมื่อ geometry ระหว่าง outer/inner เริ่มกินพื้นที่กันผิด
