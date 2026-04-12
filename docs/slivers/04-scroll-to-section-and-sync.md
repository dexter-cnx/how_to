# 04 — Scroll to Section และ Active Section Sync

pattern นี้สำคัญมากใน:
- docs / article pages
- product catalogs
- contacts A–Z
- settings แบบ grouped

## ส่วนประกอบ
- `ScrollController`
- section keys หรือ section registry
- top inset calculation
- active section resolver

ใน `apps/slivers_catalog_app` ใช้:
- key ต่อ section
- helper `_scrollTo`
- listener `_onScroll`
- state `activeSectionProvider`

สิ่งนี้ทำให้ได้ 2 ทิศทาง:
- tap chip → scroll ไป section
- scroll เอง → active chip เปลี่ยนตาม

## จุดพังที่พบบ่อย
- ลืมคิด pinned top area
- section ยังไม่ mount
- responsive ทำให้ geometry เปลี่ยน
- hardcode offset แบบไม่มี structure
