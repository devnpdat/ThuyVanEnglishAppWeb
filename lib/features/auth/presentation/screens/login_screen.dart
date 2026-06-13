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
          error: (msg) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg),
              backgroundColor: Colors.red[700],
              behavior: SnackBarBehavior.floating,
            ),
          ),
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
                        'English Learning',
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
                              color: Colors.black.withOpacity(0.08),
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
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email_outlined),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (v) =>
                                    (v == null || !v.contains('@')) ? 'Email không hợp lệ' : null,
                              ),
                              const SizedBox(height: 16),
                              if (_isRegisterMode) ...[
                                TextFormField(
                                  controller: _displayNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Tên hiển thị',
                                    prefixIcon: Icon(Icons.person_outlined),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (v) =>
                                      (v == null || v.isEmpty) ? 'Nhập tên của bạn' : null,
                                ),
                                const SizedBox(height: 16),
                              ],
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: 'Mật khẩu',
                                  prefixIcon: const Icon(Icons.lock_outlined),
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined),
                                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                  ),
                                ),
                                validator: (v) =>
                                    (v == null || v.length < 6) ? 'Mật khẩu tối thiểu 6 ký tự' : null,
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
                      TextButton(
                        onPressed: () => setState(() => _isRegisterMode = !_isRegisterMode),
                        child: Text(
                          _isRegisterMode
                              ? 'Đã có tài khoản? Đăng nhập'
                              : 'Chưa có tài khoản? Đăng ký',
                          style: const TextStyle(color: Color(0xFF4F6AF5)),
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
