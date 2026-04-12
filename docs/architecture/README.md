# Architecture Handbook

หมวดนี้สรุปสถาปัตยกรรมของ repo ชุดนี้ในแบบที่ใช้จริงได้เร็ว ไม่ over-engineer แต่ยังมี boundary ที่ชัด

## หลักที่ใช้
- feature-first pragmatic
- Riverpod เป็น state boundary
- repositories ซ่อน data source details
- shared packages มีเท่าที่มีเหตุผล
- UI layer ไม่ควรรู้ transport details โดยตรง

## ทำไมไม่ใช้ clean architecture เต็ม
เพราะเป้าหมายของชุดนี้คือ:
- เริ่มได้เร็ว
- maintain ได้
- scale ได้ระดับ production จริง
- ลด ceremony สำหรับทีมที่ต้องส่งงานไว

## รูปแบบที่ใช้ใน apps
```text
src/
  <feature>/
    data/
    domain/
    presentation/
```

## หมวดเอกสาร
- [01-boundaries-and-ownership.md](01-boundaries-and-ownership.md)
- [02-feature-first-pragmatic.md](02-feature-first-pragmatic.md)
- [03-apps-vs-packages.md](03-apps-vs-packages.md)
- [04-hardening-notes.md](04-hardening-notes.md)
