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
              boxShadow: const [
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
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Validate params — nếu thiếu userId/token thì báo lỗi ngay
    final hasValidParams =
        widget.userId.isNotEmpty && widget.resetToken.isNotEmpty;

    return BlocProvider(
      create: (_) => ForgotPasswordBloc(),
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          state.maybeWhen(
            resetSuccess: () {
              // Redirect về login sau 2 giây
              Future.delayed(const Duration(seconds: 2), () {
                if (context.mounted) context.go('/login');
              });
            },
            error: (msg) => _showTopError(context, msg),
            orElse: () {},
          );
        },
        builder: (context, state) {
          final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);
          final isSuccess = state.maybeWhen(resetSuccess: () => true, orElse: () => false);

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
                        child: const Icon(Icons.lock_open_outlined,
                            color: Colors.white, size: 44),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Đặt Lại Mật Khẩu',
                        style:
                            Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1A1A2E),
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isSuccess
                            ? 'Mật khẩu đã được đặt lại thành công!'
                            : 'Nhập mật khẩu mới của bạn',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 32),

                      if (!hasValidParams) ...[
                        // Link không hợp lệ
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.link_off, color: Colors.red[400], size: 48),
                              const SizedBox(height: 12),
                              const Text(
                                'Link không hợp lệ hoặc đã hết hạn.\nVui lòng yêu cầu link mới.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black87),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => context.go('/forgot-password'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4F6AF5),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Yêu cầu link mới'),
                              ),
                            ],
                          ),
                        ),
                      ] else if (isSuccess) ...[
                        // Success card
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
                          child: Column(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.check_circle_outline,
                                    color: Colors.green[600], size: 36),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Thành công!',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1A1A2E),
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Đang chuyển về trang đăng nhập...',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 14),
                              ),
                              const SizedBox(height: 16),
                              const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF4F6AF5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
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
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    labelText: 'Mật khẩu mới',
                                    prefixIcon:
                                        const Icon(Icons.lock_outlined),
                                    border: const OutlineInputBorder(),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFF4F6AF5), width: 2),
                                    ),
                                    errorStyle: const TextStyle(
                                        color: Colors.red, fontSize: 12),
                                    suffixIcon: IconButton(
                                      icon: Icon(_obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined),
                                      onPressed: () => setState(
                                          () => _obscurePassword =
                                              !_obscurePassword),
                                    ),
                                  ),
                                  validator: (v) => (v == null || v.length < 6)
                                      ? 'Mật khẩu tối thiểu 6 ký tự'
                                      : null,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: _obscureConfirm,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    labelText: 'Xác nhận mật khẩu mới',
                                    prefixIcon:
                                        const Icon(Icons.lock_outlined),
                                    border: const OutlineInputBorder(),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFF4F6AF5), width: 2),
                                    ),
                                    errorStyle: const TextStyle(
                                        color: Colors.red, fontSize: 12),
                                    suffixIcon: IconButton(
                                      icon: Icon(_obscureConfirm
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined),
                                      onPressed: () => setState(
                                          () => _obscureConfirm =
                                              !_obscureConfirm),
                                    ),
                                  ),
                                  validator: (v) =>
                                      v != _passwordController.text
                                          ? 'Mật khẩu không khớp'
                                          : null,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              context
                                                  .read<ForgotPasswordBloc>()
                                                  .add(
                                                    ForgotPasswordEvent
                                                        .resetPassword(
                                                      userId: widget.userId,
                                                      resetToken:
                                                          widget.resetToken,
                                                      password:
                                                          _passwordController
                                                              .text,
                                                    ),
                                                  );
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4F6AF5),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2),
                                          )
                                        : const Text(
                                            'Đặt lại mật khẩu',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton.icon(
                          onPressed: () => context.go('/login'),
                          icon: const Icon(Icons.arrow_back,
                              size: 16, color: Color(0xFF4F6AF5)),
                          label: const Text(
                            'Quay lại đăng nhập',
                            style: TextStyle(
                              color: Color(0xFF4F6AF5),
                              fontWeight: FontWeight.w600,
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
