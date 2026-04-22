# 🧪 Flutter Testing Guide (Production-Grade)

## Overview
Flutter testing is structured into 3 main layers:

| Layer | Purpose | Speed | Priority |
|------|--------|------|---------|
| Unit Test | Business logic | ⚡ Fast | 🔥 High |
| Widget Test | UI components | ⚡ Medium | 🔥 High |
| Integration Test | End-to-end flow | 🐢 Slow | 🔥 Critical |

---

## 1. Unit Test

### Use Cases
- UseCase (Clean Architecture)
- Repository logic
- Validation / Formatter

### Tools
- flutter_test
- mocktail

### Example
```dart
test('should return user when success', () async {
  final repo = MockUserRepository();
  when(() => repo.getUser()).thenAnswer((_) async => User(name: 'Dexter'));

  final usecase = GetUser(repo);

  final result = await usecase();

  expect(result.name, 'Dexter');
});
```

---

## 2. Widget Test

### Use Cases
- UI rendering
- Interaction (tap, scroll)
- State changes

### Example
```dart
testWidgets('should show loading then data', (tester) async {
  await tester.pumpWidget(MyApp());

  expect(find.byType(CircularProgressIndicator), findsOneWidget);

  await tester.pumpAndSettle();

  expect(find.text('Hello Dexter'), findsOneWidget);
});
```

---

## 3. Integration Test

### Use Cases
- Full app flow
- Login → API → UI

### Example
```dart
testWidgets('full app flow', (tester) async {
  app.main();
  await tester.pumpAndSettle();

  await tester.tap(find.text('Login'));
  await tester.pumpAndSettle();

  expect(find.text('Welcome'), findsOneWidget);
});
```

---

## Clean Architecture Mapping

```
presentation/ → Widget Test
domain/       → Unit Test (สำคัญสุด)
data/         → Unit Test + mock API
integration_test/ → Full flow
```

---

## Advanced Testing

### Golden Test
```dart
await expectLater(
  find.byType(MyWidget),
  matchesGoldenFile('my_widget.png'),
);
```

### Coverage
```bash
flutter test --coverage
```

---

## CI/CD Example

```yaml
- name: Run tests
  run: flutter test --coverage

- name: Fail if coverage < 80%
```

---

## Recommended Strategy

- Unit: 70%
- Widget: 20%
- Integration: 10%

---

## Key Principles

- Keep business logic outside UI
- Use dependency injection
- Mock external dependencies
- Enforce coverage in CI

---

## Summary

> Good Flutter testing = Test Pyramid + Clean Architecture + CI enforcement
