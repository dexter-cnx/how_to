# 02 — Feature-first Pragmatic

แนวนี้ต่างจากแยก global folders แบบ presentation/domain/data ทั้งแอป เพราะมันมองว่า feature คือหน่วยจริงของการเปลี่ยนแปลง

## ข้อดี
- ของที่เกี่ยวกันอยู่ใกล้กัน
- onboarding ง่าย
- เปลี่ยนเฉพาะ feature ได้ง่าย
- ไม่ต้อง ceremony หนักเกินไป

## โครงตัวอย่าง
```text
src/catalog/
  data/
  domain/
  presentation/
```

## ใช้เมื่อไร
เหมาะกับ:
- app ที่มีหลาย feature ชัด
- ทีมขนาดเล็กถึงกลาง
- โปรเจกต์ที่ต้อง balance speed กับ maintainability
