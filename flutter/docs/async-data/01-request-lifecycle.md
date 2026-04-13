# 01 — Request Lifecycle

แอปจริงไม่ได้มีแค่ loading/data/error

อย่างน้อยคุณมักต้องคิดถึง:
- initial loading
- success
- empty
- initial error
- refreshing
- appending
- append error
- end reached

ถ้า model สถานะเหล่านี้ไม่ชัด UI จะเริ่มมั่วเร็วมาก
