# 🧠 Flutter Performance Optimization Guide (PRO)

> Version: 2.0 PRO  
> Generated: 2026-04-22 04:25  
> Format: Obsidian-friendly

---

# 🧭 Overview

Flutter performance แบ่งเป็น 4 ด้าน:

1. Startup Performance
2. UI Smoothness (FPS)
3. Memory Usage
4. Data & Network

---

# 🧪 Profiling (สำคัญมาก)

## Tools
- Flutter DevTools
- Performance Overlay
- Timeline

## Metrics
- Frame time (<16ms)
- Memory peak
- Rebuild count

---

# ⚡ UI Optimization

## Reduce Rebuild
- ใช้ const widget
- แยก widget tree
- จำกัด scope ของ state

## List Optimization
- ListView.builder
- SliverList
- Pagination

## Expensive Widgets
หลีกเลี่ยง:
- IntrinsicHeight
- Opacity เยอะ
- Blur หนัก

---

# 🧠 Memory Optimization

## Image
- ใช้ cacheWidth / cacheHeight
- ใช้ WebP
- หลีกเลี่ยงภาพใหญ่เกิน

## Dispose
ต้อง dispose:
- AnimationController
- TextEditingController
- ScrollController

---

# ⚙️ Heavy Work Optimization

## Move to Isolate
ใช้กับ:
- JSON parse
- Data processing

```dart
compute(parseJson, data);
```

---

# 🌐 Network Optimization

- Cache-first strategy
- Debounce search
- Pagination

---

# 🚀 Startup Optimization

- Lazy init
- Defer non-critical task
- ลด plugin init

---

# 🧩 State Management Optimization

- อย่า watch state กว้างเกิน
- ใช้ selector
- ลด unnecessary rebuild

---

# 🗄️ Database Optimization

- Query เฉพาะ field ที่ใช้
- ใช้ index
- Pagination

---

# 📊 Real-world Bottlenecks

1. Rebuild เยอะ
2. Image ใหญ่
3. Main thread heavy
4. Startup หนัก

---

# ✅ Production Checklist

## UI
- [ ] ไม่มี jank
- [ ] 60 FPS

## Memory
- [ ] ไม่มี leak
- [ ] memory stable

## Network
- [ ] ใช้ cache
- [ ] request optimized

---

# 🧭 Performance Strategy

## Phase 1
Profiling

## Phase 2
Quick wins

## Phase 3
Refactor

## Phase 4
Test on real devices

---

# 🧠 Key Insight

> Flutter ไม่ช้า — แต่ “การออกแบบ state + rendering” ทำให้มันช้า

---

# 📌 Final Summary

Focus:

- ลด rebuild
- optimize image
- isolate งานหนัก
- lazy everything
