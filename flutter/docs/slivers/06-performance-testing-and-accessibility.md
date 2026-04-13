# 06 — Performance, Testing, Accessibility

## Performance
- builder delegates เป็น default
- fixed/prototype extent เมื่อทำได้
- row เบา
- อย่าใช้ `SliverToBoxAdapter` จำนวนมากแทน list

## Testing
ทดสอบ 3 ชั้น:
- composition
- behavior
- semantics

## Accessibility
- section headers ควรอ่านได้เข้าใจ
- chips/tabs ที่ใช้เป็น quick nav ควรมี label
- sticky layers ไม่ควรทำให้ผู้ใช้ screen reader งง
