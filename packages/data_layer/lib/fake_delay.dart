Future<void> fakeDelay([int ms = 500]) async {
  await Future<void>.delayed(Duration(milliseconds: ms));
}
