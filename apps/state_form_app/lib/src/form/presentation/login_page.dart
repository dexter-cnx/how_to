import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginFormStateModel {
  const LoginFormStateModel({
    this.email = '',
    this.password = '',
    this.isSubmitting = false,
    this.emailError,
    this.passwordError,
    this.submitSuccess = false,
    this.submitError,
  });

  final String email;
  final String password;
  final bool isSubmitting;
  final String? emailError;
  final String? passwordError;
  final bool submitSuccess;
  final String? submitError;

  bool get canSubmit =>
      !isSubmitting &&
      emailError == null &&
      passwordError == null &&
      email.isNotEmpty &&
      password.isNotEmpty;

  LoginFormStateModel copyWith({
    String? email,
    String? password,
    bool? isSubmitting,
    String? emailError,
    String? passwordError,
    bool? submitSuccess,
    String? submitError,
  }) {
    return LoginFormStateModel(
      email: email ?? this.email,
      password: password ?? this.password,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      emailError: emailError,
      passwordError: passwordError,
      submitSuccess: submitSuccess ?? this.submitSuccess,
      submitError: submitError,
    );
  }
}

final formProvider =
    StateNotifierProvider<LoginFormController, LoginFormStateModel>(
  (ref) => LoginFormController(),
);

class LoginFormController extends StateNotifier<LoginFormStateModel> {
  LoginFormController() : super(const LoginFormStateModel());

  void updateEmail(String value) {
    state = state.copyWith(
      email: value,
      emailError: _validateEmail(value),
      passwordError: state.passwordError,
      submitError: null,
      submitSuccess: false,
    );
  }

  void updatePassword(String value) {
    state = state.copyWith(
      password: value,
      passwordError: _validatePassword(value),
      emailError: state.emailError,
      submitError: null,
      submitSuccess: false,
    );
  }

  Future<void> submit() async {
    final emailError = _validateEmail(state.email);
    final passwordError = _validatePassword(state.password);

    state = state.copyWith(
      emailError: emailError,
      passwordError: passwordError,
      submitError: null,
      submitSuccess: false,
    );

    if (emailError != null || passwordError != null) return;

    state = state.copyWith(isSubmitting: true);

    await Future<void>.delayed(const Duration(milliseconds: 700));

    if (state.email == 'fail@example.com') {
      state = state.copyWith(
        isSubmitting: false,
        submitError: 'ระบบจำลองให้ submit ล้มเหลว',
        submitSuccess: false,
      );
      return;
    }

    state = state.copyWith(
      isSubmitting: false,
      submitError: null,
      submitSuccess: true,
    );
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) return 'กรุณากรอกอีเมล';
    if (!value.contains('@')) return 'รูปแบบอีเมลไม่ถูกต้อง';
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) return 'กรุณากรอกรหัสผ่าน';
    if (value.length < 6) return 'รหัสผ่านต้องอย่างน้อย 6 ตัวอักษร';
    return null;
  }
}

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  void initState() {
    super.initState();
    ref.listenManual<LoginFormStateModel>(formProvider, (previous, next) {
      if (next.submitError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.submitError!)),
        );
      }
      if (next.submitSuccess) {
        context.go('/success');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(formProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('State Form')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Email',
              errorText: state.emailError,
            ),
            onChanged: (value) => ref.read(formProvider.notifier).updateEmail(value),
          ),
          const SizedBox(height: 16),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              errorText: state.passwordError,
            ),
            onChanged: (value) => ref.read(formProvider.notifier).updatePassword(value),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: state.canSubmit
                ? () => ref.read(formProvider.notifier).submit()
                : null,
            child: state.isSubmitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
