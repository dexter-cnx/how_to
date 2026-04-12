# 02 — UI State vs Domain State

## UI state
มีเพื่อ interaction เช่น:
- open panel
- selected tab
- show password

## Domain state
มีเพราะปัญหาทางธุรกิจมีอยู่จริง เช่น:
- user session
- order
- cart

## กฎ
อย่าดัน UI state ไป global โดยไม่จำเป็น  
อย่าฝัง domain state ไว้ใน widget เล็ก ๆ
