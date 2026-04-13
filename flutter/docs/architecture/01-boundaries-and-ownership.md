# 01 — Boundaries และ Ownership

สถาปัตยกรรมที่ดีต้องตอบได้ว่า:
- state อยู่ที่ไหน
- data เข้ามาจากไหน
- side effects เกิดที่ไหน
- widget tree ควรรู้อะไรและไม่ควรรู้อะไร

## boundary หลักในชุดนี้
- `presentation`: UI, user events, composition
- `domain`: models, feature semantics
- `data`: repository, fake/real source integration

## rule of thumb
UI ไม่ควรรู้:
- HTTP details
- storage details
- ad-hoc parsing rules
