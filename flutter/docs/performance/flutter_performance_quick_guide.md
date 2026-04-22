# 🚀 Flutter Performance Optimization (Quick Guide)

> Version: 1.0  
> Generated: 2026-04-22 04:25

---

## 🎯 เป้าหมาย
Optimize Flutter app ในด้าน:
- 🚀 ความเร็ว (Startup / Interaction)
- 🎯 ความลื่น (FPS / Jank)
- 🧠 Memory usage
- 🌐 Network efficiency

---

## 🧪 Step 1: วัดก่อน (Profiling)

ใช้เครื่องมือ:
- Flutter DevTools (CPU, Memory, Network, Performance)
- Performance Overlay
- Profile / Release mode เท่านั้น

---

## ⚡ Step 2: Quick Wins

### UI
- ใช้ `const` ให้มากที่สุด
- แยก widget ให้เล็กลง
- ใช้ `ListView.builder`
- หลีกเลี่ยง rebuild ทั้งหน้า

### Memory
- Dispose controllers ให้ครบ
- ลดขนาด image (cacheWidth/cacheHeight)

### Network
- Cache data
- ใช้ debounce/throttle

---

## 🔥 Step 3: จุดที่ควรแก้ก่อน

1. Rebuild เยอะเกิน
2. Image ใหญ่เกิน
3. JSON parse บน main thread
4. Startup หนักเกิน

---

## 🧠 Step 4: Advanced

- ใช้ Isolate (`compute()`)
- Lazy initialization
- Pagination
- Cache strategy

---

## ✅ Checklist

- [ ] ไม่มี jank ตอน scroll
- [ ] Memory ไม่ leak
- [ ] Startup เร็ว
- [ ] ใช้งานลื่นในเครื่องระดับกลาง

---

## 📌 สรุป

Focus ที่:
- ลด rebuild
- ใช้ lazy list
- optimize image
- ย้ายงานหนักออก main thread
