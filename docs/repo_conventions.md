# Repo Conventions

## Structure
- app แต่ละตัวเป็น use case ชัดเจนหนึ่งแบบ
- shared logic ที่ reuse จริงค่อยย้ายไป packages
- docs แยกตามหมวดและเรียง sequence ด้วยเลขเมื่อจำเป็น

## Naming
- app names ลงท้าย `_app`
- widgets ที่ reusable ข้าม app อยู่ใน `packages/ui_kit`
- state helpers ที่ reuse ข้าม feature อยู่ใน `packages/feature_shared`

## Architecture
- app แต่ละตัวใช้แนว feature-first pragmatic
- ภายใน feature แยก `data / domain / presentation`
- Riverpod ใช้เป็น state + dependency boundary
- go_router ใช้ใน app ที่มี flow เหมาะสม

## Run strategy
ภายใน app ที่ต้องการ:
```bash
flutter pub get
flutter create . --platforms=android,web
flutter run -d chrome
```

## Test strategy
- เริ่มด้วย widget tests สำหรับ smoke behavior
- pure logic แยกให้ unit test ได้ง่าย
- integration tests ค่อยเพิ่มภายหลังสำหรับ critical flows
