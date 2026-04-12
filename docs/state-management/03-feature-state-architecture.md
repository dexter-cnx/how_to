# 03 — Feature-first Pragmatic Architecture

โครงที่แนะนำ:
```text
feature/
  data/
  domain/
  presentation/
```

## หลักคิด
- แยกตาม feature ก่อน
- แยกชั้นภายในเท่าที่จำเป็น
- controller/notifier อยู่ใกล้ feature
- widgets อ่าน state ไม่แบก business logic
