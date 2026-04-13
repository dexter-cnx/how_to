# 04 — Cache และ UI States

แม้ demo นี้ใช้ cache แบบง่าย แต่หลักคิดสำคัญคือ:
- source-of-truth อยู่ที่ไหน
- cache อยู่ได้นานเท่าไร
- invalidate เมื่อไร
- UI จะใช้ stale data ได้ไหมระหว่าง refresh

ถ้าคิดเรื่องพวกนี้ตั้งแต่ต้น คุณจะต่อยอดไป production ได้ง่าย
