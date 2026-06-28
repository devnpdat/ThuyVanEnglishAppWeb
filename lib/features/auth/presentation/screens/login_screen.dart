import 'package:web/web.dart' as web;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:english_learning_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:english_learning_app/core/config/app_config.dart';
import 'package:english_learning_app/core/utils/google_signin_js.dart';

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

  AuthBloc? _bloc;

  @override
  void initState() {
    super.initState();
    _checkGoogleCallback();
  }

  /// Kiểm tra nếu URL chứa id_token từ Google OAuth redirect
  /// Hoạt động với mọi path (redirect_uri là root URL)
  void _checkGoogleCallback() {
    final hash = web.window.location.hash;

    // Kiểm tra hash chứa id_token (từ Google OAuth fragment redirect)
    if (hash.startsWith('#') && hash.contains('id_token')) {
      final idToken = parseIdTokenFromHash(hash);
      if (idToken != null && idToken.isNotEmpty) {
        // Xoá hash khỏi URL ngay (tránh xử lý lại khi rebuild)
        web.window.history.replaceState(null, '', '/');

        // Gửi id_token lên BE sau frame đầu (khi _bloc đã được set)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _bloc?.add(AuthSocialLoginEvent(provider: 'google', idToken: idToken));
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
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
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3))],
            ),
            child: Row(
              children: [
                Icon(isError ? Icons.error_outline : Icons.check_circle_outline,
                    color: Colors.white, size: 20),
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

  Widget _buildEmailConfirmationScreen(BuildContext context, String message, AuthBloc bloc) {
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
                const Icon(Icons.mark_email_unread_outlined, size: 80, color: Color(0xFF4F6AF5)),
                const SizedBox(height: 24),
                Text(
                  'Kiểm tra email của bạn',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(12)),
                  child: const Text(
                    '🔄 Chưa nhận được email?\n'
                    'Kiểm tra hộp thư Spam hoặc\n'
                    'thử đăng ký lại với email khác.',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => bloc.add(const AuthLogoutEvent()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F6AF5),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Quay lại đăng nhập', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          authenticated: (userId, email, token, displayName) {},
          error: (msg) => _showTopMessage(context, msg),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final bloc = context.read<AuthBloc>();
        _bloc = bloc;
        final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);

        final emailConfirmInfo = state.whenOrNull<String?>(
          emailConfirmationRequired: (email, message) => message,
        );
        if (emailConfirmInfo != null) {
          return _buildEmailConfirmationScreen(context, emailConfirmInfo, bloc);
        }

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
                      width: 80, height: 80,
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
                        fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isRegisterMode ? 'Tạo tài khoản mới' : 'Đăng nhập để học tiếp',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 32),

                    // Form card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 4))],
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
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF4F6AF5), width: 2)),
                                errorStyle: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                              validator: (v) => (v == null || !v.contains('@')) ? 'Email không hợp lệ' : null,
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
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF4F6AF5), width: 2)),
                                  errorStyle: TextStyle(color: Colors.red, fontSize: 12),
                                ),
                                validator: (v) => (v == null || v.isEmpty) ? 'Nhập tên của bạn' : null,
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
                                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF4F6AF5), width: 2)),
                                errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                ),
                              ),
                              validator: (v) => (v == null || v.length < 6) ? 'Mật khẩu tối thiểu 6 ký tự' : null,
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
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: isLoading
                                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                    : Text(
                                        _isRegisterMode ? 'Đăng ký' : 'Đăng nhập',
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Divider "hoặc"
                    Row(
                      children: [
                        const Expanded(child: Divider(thickness: 0.5)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text('hoặc', style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                        ),
                        const Expanded(child: Divider(thickness: 0.5)),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Google Sign-In button — redirect OAuth với response_mode=fragment
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () => redirectToGoogleOAuth(
                          clientId: AppConfig.googleServerClientId,
                          redirectUri: 'https://thuyvan-english.com/',
                        ),
                        icon: Image.network(
                          'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                          width: 20,
                          height: 20,
                        ),
                        label: const Text(
                          'Đăng nhập với Google',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.grey, width: 0.5),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Quên mật khẩu + Switch login/register
                    Row(
                      mainAxisAlignment: _isRegisterMode
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.spaceBetween,
                      children: [
                        if (!_isRegisterMode)
                          TextButton(
                            onPressed: () => context.go('/forgot-password'),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('Quên mật khẩu?',
                                style: TextStyle(color: Color(0xFF4F6AF5), fontSize: 14, fontWeight: FontWeight.w500)),
                          ),
                        GestureDetector(
                          onTap: () => setState(() => _isRegisterMode = !_isRegisterMode),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              children: _isRegisterMode
                                  ? [
                                      const TextSpan(text: 'Đã có tài khoản? '),
                                      const TextSpan(text: 'Đăng nhập',
                                          style: TextStyle(color: Color(0xFF4F6AF5), fontWeight: FontWeight.w600)),
                                    ]
                                  : [
                                      const TextSpan(text: 'Chưa có tài khoản? '),
                                      const TextSpan(text: 'Đăng ký',
                                          style: TextStyle(color: Color(0xFF4F6AF5), fontWeight: FontWeight.w600)),
                                    ],
                            ),
                          ),
                        ),
                      ],
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
