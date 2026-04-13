# 01 — Mindset และคู่มือการตัดสินใจ

Sliver คือวิธีคิดแบบ section-based scroll architecture  
ไม่ใช่แค่ widget ชุดหนึ่งสำหรับทำ UI แปลก ๆ

## เมื่อไรควรเริ่มคิดแบบ Sliver
เมื่อ requirement เริ่มมีอย่างใดอย่างหนึ่ง:
- collapsing app bar
- sticky header
- grid + list ในหน้าเดียว
- TOC / scroll-to-section
- grouped list
- tabs ที่แชร์ header ร่วมกัน
- dashboard ที่มีหลาย block

## กฎสำคัญ
- one page, one scroll story → `CustomScrollView`
- shared collapsible header + independent tab scrolls → พิจารณา `NestedScrollView`
- อย่าแก้ปัญหาเชิง architecture ด้วย `shrinkWrap` อย่างเดียว

## สิ่งที่มักเข้าใจผิด
### 1. Sliver advanced เกินไป
จริง ๆ Flutter ใช้ sliver อยู่ใต้ hood ของ list/grid อยู่แล้ว

### 2. ต้องเขียน RenderSliver เอง
ส่วนใหญ่ไม่ต้อง

### 3. Sliver มีไว้แค่ทำ UI fancy
จริง ๆ มันมีไว้ให้ geometry ถูกต้องและ scale ได้
