import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:english_learning_app/features/auth/presentation/bloc/forgot_password_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _showTopMessage(BuildContext context, String msg, {bool isError = true}) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Positioned(
        top: 24, right: 16, left: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isError ? Colors.red[700] : Colors.green[700],
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3))],
            ),
            child: Row(
              children: [
                Icon(isError ? Icons.error_outline : Icons.check_circle_outline, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(child: Text(msg, style: const TextStyle(color: Colors.white, fontSize: 14))),
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
    Future.delayed(const Duration(seconds: 4), () { if (entry.mounted) entry.remove(); });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordBloc(),
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          state.maybeWhen(
            error: (msg) => _showTopMessage(context, msg),
            orElse: () {},
          );
        },
        builder: (context, state) {
          final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);
          final isCodeSent = state.maybeWhen(codeSent: () => true, orElse: () => false);

          return Scaffold(
            backgroundColor: const Color(0xFFF5F7FF),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4F6AF5), size: 20),
                onPressed: () => context.go('/login'),
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        isCodeSent ? 'Kiểm tra email' : 'Quên mật khẩu?',
                        style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isCodeSent
                            ? 'Email đặt lại mật khẩu đã được gửi đến:'
                            : 'Nhập email tài khoản, chúng tôi sẽ gửi link đặt lại mật khẩu.',
                        style: TextStyle(color: Colors.grey[600], fontSize: 15, height: 1.5),
                      ),
                      const SizedBox(height: 32),

                      if (isCodeSent) ...[
                        // ── Success state ──────────────────────────
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 4))],
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 72, height: 72,
                                decoration: BoxDecoration(color: Colors.green[50], shape: BoxShape.circle),
                                child: Icon(Icons.mark_email_read_outlined, color: Colors.green[600], size: 40),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _emailController.text.trim(),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E)),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Kiểm tra cả thư mục Spam/Junk nếu không thấy email trong hộp thư đến.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey[500], fontSize: 13, height: 1.5),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () => context.go('/login'),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF4F6AF5)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Quay lại đăng nhập',
                                style: TextStyle(color: Color(0xFF4F6AF5), fontSize: 15, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ] else ...[
                        // ── Form state ────────────────────────────
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 4))],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  autofocus: true,
                                  style: const TextStyle(color: Colors.black87),
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    hintText: 'example@gmail.com',
                                    prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF4F6AF5)),
                                    filled: true,
                                    fillColor: const Color(0xFFF8F9FF),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF4F6AF5), width: 2)),
                                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.red[400]!)),
                                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.red[400]!)),
                                    errorStyle: const TextStyle(fontSize: 12),
                                  ),
                                  validator: (v) => (v == null || !v.contains('@')) ? 'Email không hợp lệ' : null,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<ForgotPasswordBloc>().add(
                                          ForgotPasswordEvent.sendCode(email: _emailController.text.trim()),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4F6AF5),
                                      foregroundColor: Colors.white,
                                      disabledBackgroundColor: const Color(0xFF4F6AF5).withValues(alpha: 0.5),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: isLoading
                                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                        : const Text('Gửi link đặt lại', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
