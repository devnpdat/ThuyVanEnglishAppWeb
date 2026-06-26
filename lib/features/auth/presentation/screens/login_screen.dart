import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:english_learning_app/features/auth/presentation/bloc/auth_bloc.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();
  bool _isRegisterMode = false;
  bool _obscurePassword = true;

  void _showTopError(BuildContext context, String msg) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Positioned(
        top: 24,
        right: 16,
        left: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.red[700],
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3)),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(msg,
                      style: const TextStyle(color: Colors.white, fontSize: 14)),
                ),
                GestureDetector(
                  onTap: () => entry.remove(),
                  child: const Icon(Icons.close, color: Colors.white70, size: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 4), () {
      if (entry.mounted) entry.remove();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(AuthBloc bloc) {
    if (!_formKey.currentState!.validate()) return;
    if (_isRegisterMode) {
      bloc.add(AuthRegisterEvent(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        displayName: _displayNameController.text.trim(),
      ));
    } else {
      bloc.add(AuthLoginEvent(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // AuthBloc được inject từ app.dart qua BlocProvider.value — không tạo mới
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          // Router tự động redirect khi authenticated — không cần gọi setLoggedIn
          authenticated: (userId, email, token, displayName) {},
          error: (msg) {
            _showTopError(context, msg);
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final bloc = context.read<AuthBloc>();
        final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);

          return Scaffold(
            backgroundColor: const Color(0xFFF5F7FF),
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4F6AF5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.school, color: Colors.white, size: 44),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Thuỳ Vân',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isRegisterMode ? 'Tạo tài khoản mới' : 'Đăng nhập để học tiếp',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Form card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.black),
                                onFieldSubmitted: (_) => _submit(bloc),
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email_outlined),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF4F6AF5), width: 2),
                                  ),
                                  errorStyle: TextStyle(color: Colors.red, fontSize: 12),
                                ),
                                validator: (v) =>
                                    (v == null || !v.contains('@')) ? 'Email không hợp lệ' : null,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                              ),
                              const SizedBox(height: 16),
                              if (_isRegisterMode) ...[
                                TextFormField(
                                  controller: _displayNameController,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: const InputDecoration(
                                    labelText: 'Tên hiển thị',
                                    prefixIcon: Icon(Icons.person_outlined),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF4F6AF5), width: 2),
                                    ),
                                    errorStyle: TextStyle(color: Colors.red, fontSize: 12),
                                  ),
                                  validator: (v) =>
                                      (v == null || v.isEmpty) ? 'Nhập tên của bạn' : null,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                ),
                                const SizedBox(height: 16),
                              ],
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: const TextStyle(color: Colors.black),
                                onFieldSubmitted: (_) => _submit(bloc),
                                decoration: InputDecoration(
                                  labelText: 'Mật khẩu',
                                  prefixIcon: const Icon(Icons.lock_outlined),
                                  border: const OutlineInputBorder(),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF4F6AF5), width: 2),
                                  ),
                                  errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined),
                                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                  ),
                                ),
                                validator: (v) =>
                                    (v == null || v.length < 6) ? 'Mật khẩu tối thiểu 6 ký tự' : null,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : () => _submit(bloc),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4F6AF5),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 20, height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white, strokeWidth: 2),
                                        )
                                      : Text(
                                          _isRegisterMode ? 'Đăng ký' : 'Đăng nhập',
                                          style: const TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.w600),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Link Quên mật khẩu — chỉ hiển thị ở chế độ đăng nhập
                      if (!_isRegisterMode)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => context.go('/forgot-password'),
                            child: const Text(
                              'Quên mật khẩu?',
                              style: TextStyle(
                                color: Color(0xFF4F6AF5),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      TextButton(
                        onPressed: () => setState(() => _isRegisterMode = !_isRegisterMode),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.grey[700], fontSize: 14),
                            children: _isRegisterMode
                                ? [
                                    const TextSpan(text: 'Đã có tài khoản? '),
                                    const TextSpan(
                                      text: 'Đăng nhập',
                                      style: TextStyle(
                                        color: Color(0xFF4F6AF5),
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ]
                                : [
                                    const TextSpan(text: 'Chưa có tài khoản? '),
                                    const TextSpan(
                                      text: 'Đăng ký',
                                      style: TextStyle(
                                        color: Color(0xFF4F6AF5),
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                          ),
                        ),
                      ),
                    ],

                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
