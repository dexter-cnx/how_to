# Provider Tutorial and Provider -> GetX Tutorial

> คู่มือสำหรับคนอยากเข้าใจ Provider แบบพื้นฐาน และแนวทางย้ายจาก Provider ไปใช้ GetX

---

## Part 1: Provider Tutorial

Flutter docs ฝั่ง simple app state management ใช้ `provider` เป็นจุดเริ่มต้น และแนะนำว่าถ้าคุณยังใหม่กับ Flutter และยังไม่มีเหตุผลหนักแน่นที่จะเลือกแนวอื่น Provider เป็นแนวทางที่ดีในการเริ่ม เพราะเข้าใจง่ายและใช้แนวคิดที่ต่อยอดไป approach อื่นได้

---

## Provider คืออะไร

Provider เป็น wrapper ที่ช่วยให้ใช้งาน `InheritedWidget` ได้ง่ายขึ้น และมักใช้ทั้งสำหรับ:
- dependency injection
- state exposure
- rebuild UI เมื่อค่าที่สนใจเปลี่ยน

อย่างไรก็ตาม Provider ไม่ได้บังคับรูปแบบ state management ตายตัว คุณมักจะใช้คู่กับ `ChangeNotifier`, `ValueNotifier`, หรือ class รูปแบบอื่นตามที่ทีมกำหนด

---

## โครงสร้างพื้นฐาน

### 1) model/state

```dart
import 'package:flutter/foundation.dart';

class CounterModel extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }
}
```

### 2) inject ที่ root

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CounterModel(),
      child: const MyApp(),
    ),
  );
}
```

### 3) อ่านค่าใน UI

```dart
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<CounterModel>();

    return Scaffold(
      body: Center(
        child: Text('${model.count}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: model.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

---

## `watch`, `read`, `select` ต่างกันยังไง

### `context.watch<T>()`
ใช้ตอน widget ต้อง rebuild เมื่อค่าของ provider เปลี่ยน

```dart
final cart = context.watch<CartModel>();
```

### `context.read<T>()`
ใช้ตอนต้องการเรียก method แบบ one-shot โดยไม่อยากให้ widget rebuild จาก object นั้น

```dart
context.read<CartModel>().addItem(item);
```

### `context.select<T, R>()`
ใช้ตอนอยาก subscribe แค่บาง field เพื่อลด rebuild

```dart
final totalPrice = context.select<CartModel, double>((m) => m.totalPrice);
```

---

## ตัวอย่าง Todo แบบง่าย

### model

```dart
class Todo {
  final String title;
  final bool done;

  const Todo({required this.title, this.done = false});

  Todo copyWith({String? title, bool? done}) {
    return Todo(
      title: title ?? this.title,
      done: done ?? this.done,
    );
  }
}

class TodoModel extends ChangeNotifier {
  final List<Todo> _todos = [];

  List<Todo> get todos => List.unmodifiable(_todos);

  void addTodo(String title) {
    _todos.add(Todo(title: title));
    notifyListeners();
  }

  void toggle(int index) {
    final todo = _todos[index];
    _todos[index] = todo.copyWith(done: !todo.done);
    notifyListeners();
  }
}
```

### inject

```dart
ChangeNotifierProvider(
  create: (_) => TodoModel(),
  child: const MyApp(),
)
```

### ui

```dart
class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<TodoModel>().todos;

    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return CheckboxListTile(
          value: todo.done,
          title: Text(todo.title),
          onChanged: (_) => context.read<TodoModel>().toggle(index),
        );
      },
    );
  }
}
```

---

## MultiProvider

เมื่อแอปโตขึ้น เรามักมีหลาย provider

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthModel()),
    ChangeNotifierProvider(create: (_) => CartModel()),
    Provider(create: (_) => ApiClient()),
  ],
  child: const MyApp(),
)
```

### ใช้เมื่อ
- มีหลาย service / model
- ต้อง inject dependency หลายตัว
- อยากให้ root ชัดเจน

---

## จุดแข็งของ Provider

- เข้าใจง่าย
- เป็นพื้นฐานดีมากสำหรับคนเริ่ม Flutter
- ใช้ร่วมกับแนวคิด ChangeNotifier ได้ตรงไปตรงมา
- ecosystem เก่าแก่และมีตัวอย่างเยอะ
- เหมาะกับ app เล็กถึงกลาง หรือทีมที่ไม่ต้องการ abstraction สูงมาก

## จุดอ่อนของ Provider

- async/loading/error state ไม่ elegant เท่า Riverpod
- dependency graph และ composition ไม่ยืดหยุ่นเท่า Riverpod
- เมื่อ app ใหญ่ขึ้น ถ้าใช้ `ChangeNotifier` หนักเกินไป อาจกลายเป็น object ใหญ่ที่รู้ทุกอย่าง
- ระวัง rebuild เกินจำเป็นถ้าใช้ `watch` กว้างเกินไป

---

## Best practices สำหรับ Provider

1. อย่าใส่ business logic หนักใน widget
2. อย่าให้ ChangeNotifier ตัวเดียวแบกทั้ง feature ใหญ่
3. แยก service/repository ออกจาก UI model
4. ใช้ `read` สำหรับ action
5. ใช้ `select` เพื่อลด rebuild เมื่อจำเป็น
6. ใช้ `MultiProvider` จัด DI ที่ root

---

## Part 2: Provider -> GetX Tutorial

นี่คือคู่มือสำหรับคนที่เคยใช้ Provider แล้วอยากย้ายไป GetX

---

## Mental model เดิมของ Provider

- state object มักเป็น `ChangeNotifier`
- UI ใช้ `context.watch()` หรือ `Consumer`
- action เรียก method ที่ model แล้ว `notifyListeners()`
- DI ผ่าน `Provider`, `ChangeNotifierProvider`, `MultiProvider`

## Mental model ใหม่ของ GetX

- state อยู่ใน `GetxController`
- reactive field ใช้ `.obs`
- UI ใช้ `Obx()`
- action เรียก method ใน controller
- DI ใช้ `Get.put()`, `Get.find()`

---

## Mapping: Provider -> GetX

| Provider | GetX |
|---|---|
| ChangeNotifier | GetxController |
| field + notifyListeners() | Rx field (`.obs`) |
| context.watch() / Consumer | Obx() |
| Provider.of / context.read | Get.find() |
| MultiProvider | Bindings หรือ Get.put หลายตัว |

---

## Counter migration example

### Provider version

```dart
class CounterModel extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}
```

```dart
ChangeNotifierProvider(
  create: (_) => CounterModel(),
  child: const MyApp(),
)
```

```dart
final model = context.watch<CounterModel>();
Text('${model.count}');
```

### GetX version

```dart
class CounterController extends GetxController {
  final count = 0.obs;

  void increment() => count.value++;
}
```

```dart
Get.put(CounterController());
```

```dart
final controller = Get.find<CounterController>();
Obx(() => Text('${controller.count.value}'));
```

---

## Todo migration example

### Provider version

```dart
class TodoModel extends ChangeNotifier {
  final List<Todo> _todos = [];

  List<Todo> get todos => List.unmodifiable(_todos);

  void addTodo(String title) {
    _todos.add(Todo(title: title));
    notifyListeners();
  }
}
```

### GetX version

```dart
class TodoController extends GetxController {
  final todos = <Todo>[].obs;

  void addTodo(String title) {
    todos.add(Todo(title: title));
  }

  void toggle(int index) {
    final todo = todos[index];
    todos[index] = todo.copyWith(done: !todo.done);
  }
}
```

### UI

```dart
class TodoPage extends StatelessWidget {
  TodoPage({super.key});

  final controller = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: controller.todos.length,
        itemBuilder: (context, index) {
          final todo = controller.todos[index];
          return CheckboxListTile(
            value: todo.done,
            title: Text(todo.title),
            onChanged: (_) => controller.toggle(index),
          );
        },
      ),
    );
  }
}
```

---

## สิ่งที่ต้องระวังตอนย้ายจาก Provider ไป GetX

### 1) อย่าเอาทุกอย่างไปกองใน controller เดียว

ตอนย้าย หลายคนมักเอา model หลายตัวจาก Provider มารวมเป็น controller ใหญ่หนึ่งตัว ผลคือ maintain ยาก

### 2) ระวัง business logic กับ navigation ปนกัน

GetX ทำให้ navigation ง่ายมาก จนบางครั้ง controller กลายเป็นทั้ง state, workflow, navigation coordinator ในที่เดียว

### 3) วางกติกา DI ให้ชัด

เช่น:
- put ที่ route level
- service อยู่ global
- feature controller อยู่ per screen

### 4) ตั้ง convention การแบ่ง feature

เช่น

```text
lib/
  features/
    auth/
      controllers/
      pages/
      widgets/
      services/
    todo/
      controllers/
      pages/
      widgets/
```

---

## เมื่อไรควรย้ายจาก Provider ไป GetX

เหมาะเมื่อ:
- อยากลด boilerplate
- อยากให้ state + DI + navigation มาอยู่ชุดเดียว
- ทีมเล็ก
- ต้องการ speed สูง

ไม่เหมาะเมื่อ:
- ทีมใหญ่และต้องการ explicit dependency มาก ๆ
- อยากให้ state flow เข้มและ predictable สูง
- project มี architecture rule ที่ต้อง review กันเข้มมาก

---

## สูตรย้ายทีละขั้น

1. เริ่มจาก feature ใหม่ก่อน อย่า rewrite ทั้งแอปในครั้งเดียว
2. ย้าย model เดิมจาก `ChangeNotifier` เป็น `GetxController`
3. ย้าย field ที่ reactive เป็น `.obs`
4. เปลี่ยน UI จาก `Consumer/context.watch` เป็น `Obx`
5. แยก services/repositories ออกเหมือนเดิม
6. อย่าให้ controller แบก data access เองทั้งหมด

---

## สรุปสั้น

### Provider เหมาะเมื่อ
- อยากเริ่มจากของเข้าใจง่าย
- โปรเจกต์ยังไม่ใหญ่มาก
- ทีมรับได้กับ ChangeNotifier model

### GetX เหมาะเมื่อ
- อยากขึ้นงานเร็ว
- ลด boilerplate
- ใช้ state + DI + route ใน ecosystem เดียว

### จาก Provider ไป GetX
- ได้ความเร็วเพิ่ม
- ได้ syntax ที่สั้นขึ้น
- แต่ต้องแลกกับการควบคุม architecture ด้วยทีมของคุณเองมากขึ้น

---

## Source notes

อิงจาก:
- Flutter docs: Simple app state management
- provider package docs และ example
- Flutter docs: Approaches to state management
