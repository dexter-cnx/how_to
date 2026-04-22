# BLoC and Riverpod for GetX Developers

> คู่มือสำหรับคนใช้ GetX แล้วอยากเข้าใจวิธีคิดของ BLoC/Cubit และ Riverpod แบบใช้งานจริง

---

## Part 1: BLoC/Cubit for GetX dev

### แปลง mental model ก่อน

#### GetX เดิม

- มี `Controller`
- มี state แบบ `.obs`
- UI ใช้ `Obx()`
- action เรียก method ใน controller
- DI ใช้ `Get.put()`

#### BLoC/Cubit ใหม่

- มี `Cubit` หรือ `Bloc`
- state เป็น immutable value หรือ immutable object
- UI ใช้ `BlocBuilder`
- side effect ใช้ `BlocListener`
- inject ด้วย `BlocProvider`

### Mapping

| GetX | BLoC/Cubit |
|---|---|
| GetxController | Cubit / Bloc |
| `.obs` | immutable state |
| `Obx()` | `BlocBuilder` |
| `Get.put()` | `BlocProvider` |
| method ใน controller | method ใน cubit หรือ dispatch event |

---

## Cubit ก่อน สำหรับคนมาจาก GetX

ถ้าเพิ่งย้ายจาก GetX ให้เริ่มที่ **Cubit** ก่อน เพราะใกล้กับแนว controller + method มากที่สุด

### Counter example

```dart
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
```

```dart
void main() {
  runApp(
    BlocProvider(
      create: (_) => CounterCubit(),
      child: const MyApp(),
    ),
  );
}
```

```dart
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<CounterCubit, int>(
          builder: (context, count) => Text('$count'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<CounterCubit>().increment(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

### สิ่งที่ต้องเปลี่ยนวิธีคิด

#### เดิมใน GetX

```dart
count.value++;
```

#### ใน Cubit

```dart
emit(state + 1);
```

แนวคิดคือ “ปล่อย state ใหม่” ออกไปอย่าง explicit

---

## ตัวอย่าง Login state แบบ production ขึ้นหน่อย

### state

```dart
class LoginState {
  final String email;
  final String password;
  final bool isLoading;
  final String? error;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.error,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    String? error,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
```

### cubit

```dart
class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  void emailChanged(String value) {
    emit(state.copyWith(email: value));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value));
  }

  Future<void> login() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
```

### ui

```dart
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Column(
          children: [
            TextField(
              onChanged: (v) => context.read<LoginCubit>().emailChanged(v),
            ),
            TextField(
              onChanged: (v) => context.read<LoginCubit>().passwordChanged(v),
            ),
            ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () => context.read<LoginCubit>().login(),
              child: Text(state.isLoading ? 'Loading...' : 'Login'),
            ),
          ],
        );
      },
    );
  }
}
```

---

## เมื่อไรควรใช้ Bloc แทน Cubit

ใช้ Bloc เต็มเมื่อ:
- มี input หลายรูปแบบ
- มี event stream
- มี debounce/search
- มี pagination + refresh + retry
- ต้องการแยก event ออกจาก method อย่างชัดเจน

### ตัวอย่าง Bloc mental model

- user action ส่ง `Event`
- Bloc ประมวลผล
- ได้ `State` ใหม่

เหมาะกับ flow ที่ซับซ้อนกว่าการเรียก method ตรง ๆ

---

## กฎย้ายจาก GetX ไป BLoC แบบลื่น

1. เริ่มที่ Cubit ก่อน
2. 1 screen = 1 cubit ก่อน
3. side effects ใช้ `BlocListener`
4. rendering ใช้ `BlocBuilder`
5. แยก repository/service ออกจาก UI
6. อย่าใส่ business logic ใน widget

---

## Part 2: Riverpod for GetX dev

### Mental model ใหม่

ใน GetX คุณมักมี controller กลาง

ใน Riverpod คุณมี provider graph
- state เป็น provider
- dependency เป็น provider
- UI ใช้ `ref.watch()`
- action ใช้ `ref.read()`

### Mapping

| GetX | Riverpod |
|---|---|
| GetxController | Notifier / StateNotifier / provider logic |
| `.obs` | provider state |
| `Obx()` | `ref.watch()` |
| `Get.find()` | `ref.read()` |
| Bindings | provider dependency graph |

---

## เริ่มจาก StateNotifier style

### counter

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void increment() => state++;
  void decrement() => state--;
}

final counterProvider =
    StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});
```

```dart
void main() {
  runApp(const ProviderScope(child: MyApp()));
}
```

```dart
class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    return Scaffold(
      body: Center(child: Text('$count')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.notifier).increment(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

---

## Login example แบบค่อย ๆ ย้ายจาก GetX

### state

```dart
class LoginState {
  final String email;
  final String password;
  final bool isLoading;
  final String? error;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.error,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    String? error,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
```

### repository provider

```dart
class AuthRepository {
  Future<void> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
```

### notifier

```dart
class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier(this._repo) : super(const LoginState());

  final AuthRepository _repo;

  void onEmailChanged(String value) {
    state = state.copyWith(email: value);
  }

  void onPasswordChanged(String value) {
    state = state.copyWith(password: value);
  }

  Future<void> login() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repo.login(email: state.email, password: state.password);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final loginProvider =
    StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return LoginNotifier(repo);
});
```

### ui

```dart
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginProvider);
    final notifier = ref.read(loginProvider.notifier);

    return Column(
      children: [
        TextField(onChanged: notifier.onEmailChanged),
        TextField(onChanged: notifier.onPasswordChanged),
        ElevatedButton(
          onPressed: state.isLoading ? null : notifier.login,
          child: Text(state.isLoading ? 'Loading...' : 'Login'),
        ),
      ],
    );
  }
}
```

---

## สิ่งที่คนมาจาก GetX ต้องจำ

### BLoC/Cubit
- คิดเป็น state transitions
- state ควร immutable
- render กับ side effects แยกกัน

### Riverpod
- คิดเป็น provider graph
- dependency ต้อง explicit
- `watch` ใช้ render, `read` ใช้ action

---

## เลือกยังไงถ้าคุณใช้ GetX อยู่แล้ว

### ไป Riverpod เมื่อ
- อยากได้ balance ระหว่างความเร็วกับโครงสร้าง
- อยากให้ dependency ชัดขึ้น
- จะทำ Clean Architecture จริงจัง

### ไป Cubit/BLoC เมื่อ
- team ใหญ่
- flow ซับซ้อน
- อยากได้ predictable state transitions
- review/test สำคัญมาก

---

## Source notes

อิงจาก:
- Riverpod docs: Refs, Consumers, Reading providers, What's new in Riverpod 3.0
- bloclibrary docs: Getting Started, Why Bloc, Bloc Concepts, Flutter Bloc Concepts, Architecture
