# 07 — Catalog Demo Walkthrough

app: `apps/slivers_catalog_app`

## สิ่งที่ demo นี้ทำ
- `SliverAppBar` แบบ collapse
- sticky filter/section bar
- active section chip
- tap chip → scroll to section
- scroll → active chip update
- grouped sections ด้วย header + grid

## ไฟล์สำคัญ
- `lib/src/catalog/data/catalog_repository.dart`
- `lib/src/catalog/domain/catalog_models.dart`
- `lib/src/catalog/presentation/catalog_page.dart`

## จุดที่ต่อยอดได้
- responsive grid ตาม width
- เพิ่ม detail page
- เปลี่ยน fake repository เป็น real backend
