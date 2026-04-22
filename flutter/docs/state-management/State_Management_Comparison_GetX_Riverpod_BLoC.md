# State Management Comparison: GetX vs Riverpod vs BLoC

> Obsidian-friendly notes สำหรับเปรียบเทียบแนวทาง state management ยอดนิยมใน Flutter

---

## ภาพรวมสั้น ๆ

- **GetX**: เขียนไว เริ่มง่าย รวม state + DI + navigation ไว้ในชุดเดียว
- **Riverpod**: ชัดเรื่อง dependency และ reactive composition, เหมาะกับ production app ที่ต้องการ scalability
- **BLoC/Cubit**: state flow ชัดที่สุดสำหรับหลายทีมและ business logic ซับซ้อน แต่มี ceremony มากกว่า

Flutter docs ระบุว่า state management ไม่มีคำตอบเดียวสำหรับทุกโปรเจกต์ และแต่ละวิธีมี trade-off ต่างกันชัดเจน ดังนั้นควรเลือกตามขนาดทีม ความซับซ้อน และวินัยทางสถาปัตยกรรมของโปรเจกต์

---

## 1) GetX

GetX เป็นแพ็กเกจที่รวมหลาย concern เข้าด้วยกันในตัวเดียว ได้แก่:
- state management
- dependency injection
- route management

### ข้อดี

- เริ่มเร็วมาก
- boilerplate น้อย
- syntax ตรงไปตรงมา
- เหมาะกับ MVP, prototype, internal tools
- คนเดียวทำได้ไวมาก เพราะไม่ต้องประกอบหลาย package

### ข้อเสีย

- ถ้าโปรเจกต์โตมาก ๆ และไม่มี convention ทีมที่เข้ม โค้ดอาจ drift ได้ง่าย
- เพราะมีทั้ง state, DI, navigation ในตัวเดียว ทำให้บางทีมวางขอบเขตยาก
- dependency flow และ lifecycle บางจุด implicit มากกว่า Riverpod/BLoC
- สำหรับทีมใหญ่ อาจทำให้ onboarding คนใหม่ช้าลง ถ้า codebase ไม่เป็นระบบ

### Mental model

```dart
class CounterController extends GetxController {
  final count = 0.obs;

  void increment() => count.value++;
}
```

```dart
final controller = Get.put(CounterController());

Obx(() => Text('${controller.count.value}'));
```

### เหมาะกับ

- solo dev
- startup MVP
- app ขนาดเล็กถึงกลาง
- ทีมที่ prioritize speed มากกว่าความ strict ของ state flow

---

## 2) Riverpod

Riverpod ใช้ provider tree ที่แยกจาก widget tree และใช้ `ref.watch`, `ref.read`, `ref.listen` เป็นแกนกลางของการเข้าถึง state และ dependency

### ข้อดี

- dependency ชัด
- test ง่าย
- compose provider ต่อ provider ได้ดี
- ทำงานกับ async/loading/error ได้สวย
- เหมาะกับ Clean Architecture และ modular feature structure
- ไม่ผูกกับ BuildContext ในรูปแบบเดิมของ Provider

### ข้อเสีย

- ช่วงแรกต้องใช้เวลาเข้าใจ provider lifecycle
- คนมาจาก GetX อาจรู้สึกว่าเขียนเยอะขึ้น
- ถ้าไม่ตั้งกติกาเรื่องชื่อและตำแหน่งของ provider อาจกระจายเต็มโปรเจกต์ได้

### Mental model

```dart
final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void increment() => state++;
}
```

```dart
class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    return Text('$count');
  }
}
```

### เหมาะกับ

- production app
- ทีมที่อยากได้ balance ระหว่าง speed และ architecture
- app ที่ต้องการ testability และ dependency graph ชัดเจน

---

## 3) BLoC / Cubit

BLoC ecosystem เน้น predictable state management และ separation ระหว่าง presentation กับ business logic

### ข้อดี

- state flow ชัดมาก
- test ง่าย
- เหมาะกับ business flow ซับซ้อน
- เหมาะกับทีมใหญ่และ enterprise app
- แยก presentation / logic / data ได้สวย

### ข้อเสีย

- verbose กว่าอีกสองทาง
- boilerplate มากกว่า
- ถ้าใช้ Bloc เต็มทุกจุด อาจหนักเกินสำหรับ feature เล็ก
- มือใหม่มักรู้สึกว่ามีพิธีกรรมเยอะ

### Mental model

```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
}
```

```dart
BlocBuilder<CounterCubit, int>(
  builder: (context, count) => Text('$count'),
)
```

### เหมาะกับ

- ทีมหลายคน
- business logic หนัก
- flow ที่ต้อง predictable มาก
- โปรเจกต์ที่ต้องมีมาตรฐานร่วมสูง

---

## ตารางเทียบแบบ practical

| ประเด็น | GetX | Riverpod | BLoC |
|---|---|---|---|
| ความเร็วเริ่มต้น | สูงมาก | สูง | กลาง |
| Boilerplate | ต่ำ | กลาง | สูง |
| Dependency ชัดเจน | กลาง | สูง | สูง |
| Testability | กลาง | สูง | สูงมาก |
| เหมาะกับ MVP | สูงมาก | สูง | กลาง |
| เหมาะกับ app ใหญ่ | กลาง | สูงมาก | สูงมาก |
| เหมาะกับทีมใหญ่ | กลาง | สูง | สูงมาก |
| Learning curve | ต่ำ | กลาง | กลางถึงสูง |
| Async state handling | พอใช้ | ดีมาก | ดีมาก |
| Architecture discipline | ต้องตั้งเอง | ดี | ดีมาก |

---

## สรุปแบบตัดสินใจเร็ว

### เลือก GetX เมื่อ

- ต้องการขึ้นงานเร็ว
- ทีมเล็ก
- อยากให้ state + DI + navigation อยู่ใน ecosystem เดียว
- โปรเจกต์ยังไม่ซับซ้อนมาก

### เลือก Riverpod เมื่อ

- อยากได้สมดุลระหว่าง productivity กับ scalability
- ต้องการ dependency ที่ explicit
- จะทำ Clean Architecture / feature-first / modular app
- อยาก test ง่ายขึ้นโดยไม่หนักเท่า BLoC

### เลือก BLoC เมื่อ

- business logic ซับซ้อน
- ทีมหลายคน
- ต้องการ predictable state transitions
- ยอมรับ boilerplate เพื่อแลกกับความชัดของ flow

---

## คำแนะนำเชิงสถาปัตยกรรม

### ถ้าคุณใช้ GetX อยู่แล้ว

- ถ้าปัญหาหลักคือ codebase โตและ dependency เริ่มมั่ว: **ย้ายไป Riverpod** มักนุ่มที่สุด
- ถ้าปัญหาหลักคือ flow ซับซ้อน, หลายทีม, ต้อง review/test อย่างเป็นระบบ: **ย้ายไป Cubit/BLoC**

### สำหรับ Flutter production app ทั่วไป

- **GetX** = เร็ว
- **Riverpod** = balance ที่ดีที่สุด
- **BLoC** = strict ที่สุด

---

## Source notes

อิงจากเอกสารทางการและเอกสารหลักของ ecosystem เหล่านี้:
- Flutter docs: Approaches to state management
- Flutter docs: Simple app state management
- provider package docs
- Riverpod docs (Refs, Consumers, Reading)
- bloclibrary docs (Getting Started, Concepts, Architecture, Flutter Bloc Concepts)
