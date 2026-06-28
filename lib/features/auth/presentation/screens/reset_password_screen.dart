import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:english_learning_app/features/auth/presentation/bloc/forgot_password_bloc.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String userId;
  final String resetToken;

  const ResetPasswordScreen({
    Key? key,
    required this.userId,
    required this.resetToken,
  }) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
    final hasValidParams = widget.userId.isNotEmpty && widget.resetToken.isNotEmpty;

    return BlocProvider(
      create: (_) => ForgotPasswordBloc(),
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          state.maybeWhen(
            resetSuccess: () {
              Future.delayed(const Duration(seconds: 2), () {
                if (context.mounted) context.go('/login');
              });
            },
            error: (msg) => _showTopMessage(context, msg),
            orElse: () {},
          );
        },
        builder: (context, state) {
          final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);
          final isSuccess = state.maybeWhen(resetSuccess: () => true, orElse: () => false);

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

                      // ── Link không hợp lệ ──────────────────────
                      if (!hasValidParams) ...[
                        const Text(
                          'Link không hợp lệ',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Link đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.',
                          style: TextStyle(color: Colors.grey[600], fontSize: 15, height: 1.5),
                        ),
                        const SizedBox(height: 32),
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
                              Icon(Icons.link_off_rounded, color: Colors.red[300], size: 56),
                              const SizedBox(height: 16),
                              Text('Vui lòng yêu cầu link mới', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: () => context.go('/forgot-password'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4F6AF5),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text('Yêu cầu link mới', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // ── Thành công ─────────────────────────────
                      ] else if (isSuccess) ...[
                        const Text(
                          'Đặt lại thành công!',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
                        ),
                        const SizedBox(height: 8),
                        Text('Mật khẩu mới đã được lưu.', style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                        const SizedBox(height: 32),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(32),
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
                                child: Icon(Icons.check_circle_outline_rounded, color: Colors.green[600], size: 44),
                              ),
                              const SizedBox(height: 16),
                              Text('Đang chuyển về trang đăng nhập...', style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                              const SizedBox(height: 16),
                              const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFF4F6AF5))),
                            ],
                          ),
                        ),

                      // ── Form ───────────────────────────────────
                      ] else ...[
                        const Text(
                          'Đặt lại mật khẩu',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
                        ),
                        const SizedBox(height: 8),
                        Text('Nhập mật khẩu mới cho tài khoản của bạn.', style: TextStyle(color: Colors.grey[600], fontSize: 15, height: 1.5)),
                        const SizedBox(height: 32),
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
                                _buildPasswordField(
                                  controller: _passwordController,
                                  label: 'Mật khẩu mới',
                                  obscure: _obscurePassword,
                                  onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                                  validator: (v) => (v == null || v.length < 6) ? 'Mật khẩu tối thiểu 6 ký tự' : null,
                                ),
                                const SizedBox(height: 16),
                                _buildPasswordField(
                                  controller: _confirmPasswordController,
                                  label: 'Xác nhận mật khẩu mới',
                                  obscure: _obscureConfirm,
                                  onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                                  validator: (v) => v != _passwordController.text ? 'Mật khẩu không khớp' : null,
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<ForgotPasswordBloc>().add(
                                          ForgotPasswordEvent.resetPassword(
                                            userId: widget.userId,
                                            resetToken: widget.resetToken,
                                            password: _passwordController.text,
                                          ),
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
                                        : const Text('Đặt lại mật khẩu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outlined, color: Color(0xFF4F6AF5)),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.grey[500]),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: const Color(0xFFF8F9FF),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF4F6AF5), width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.red[400]!)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.red[400]!)),
        errorStyle: const TextStyle(fontSize: 12),
      ),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
