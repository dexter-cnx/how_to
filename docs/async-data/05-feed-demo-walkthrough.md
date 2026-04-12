# 05 — Feed Demo Walkthrough

app: `apps/async_feed_app`

## สิ่งที่ demo นี้แสดง
- initial loading
- refresh
- infinite scroll trigger
- append loading
- empty/error handling
- repository + cache แบบง่าย

## ไฟล์สำคัญ
- `lib/src/feed/data/feed_repository.dart`
- `lib/src/feed/presentation/feed_page.dart`

## จุดที่ต่อยอดได้
- แยก error model ให้ชัด
- เพิ่ม append error UI
- ใช้ Dio/client จริง
- เพิ่ม optimistic updates
