# 03 — Apps vs Packages

## App level
แต่ละ app ควรเป็น use case ชัดเจนหนึ่งแบบ
ไม่ควรยัดทุก concept ลง app เดียวจนอ่านยาก

## Package level
ย้ายไป package เมื่อ:
- reuse ข้าม app จริง
- API surface ชัด
- ownership สมเหตุผล

## อย่าย้ายไป package เมื่อ
- แค่คิดว่าอาจ reuse ในอนาคต
- code ยังเปลี่ยนเร็วมาก
- ยังไม่รู้ public API ที่ดีคืออะไร
