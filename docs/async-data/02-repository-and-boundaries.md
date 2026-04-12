# 02 — Repository และ Boundaries

repository ที่ดีไม่ใช่ pass-through ไป HTTP อย่างเดียว

## หน้าที่ของมัน
- ซ่อน transport details
- normalize data access
- own cache policy
- แปลง error ให้ UI layer ใช้ได้ง่ายขึ้น
