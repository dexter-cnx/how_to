# 03 — Pagination, Refresh, Retry

## Pagination
แยก:
- initial load
- append
- hasMore
- append error

## Refresh
ไม่ใช่ append  
ควร reset หรือ refresh state อย่าง intentional

## Retry
ต้องแยก initial error กับ append error เพราะ UX คนละแบบ
