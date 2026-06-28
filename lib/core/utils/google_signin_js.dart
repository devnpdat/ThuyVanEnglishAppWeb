import 'dart:math';
import 'package:web/web.dart' as web;

/// Sinh nonce ngẫu nhiên (20 byte hex)
String _generateNonce() {
  final rand = Random.secure();
  final bytes = List<int>.generate(20, (_) => rand.nextInt(256));
  return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}

/// Google OAuth redirect URL builder
/// Dùng direct OAuth endpoint với response_mode=fragment
/// để tránh form_post (nginx không xử lý POST body)
String buildGoogleOAuthUrl({
  required String clientId,
  required String redirectUri,
}) {
  final nonce = _generateNonce();
  final state = _generateNonce();

  // Lưu state vào sessionStorage để verify khi redirect về
  web.window.sessionStorage.setItem('google_oauth_state', state);

  final params = {
    'client_id': clientId,
    'redirect_uri': redirectUri,
    'response_type': 'id_token',
    'scope': 'openid email profile',
    'state': state,
    'nonce': nonce,
    'response_mode': 'fragment',
  };

  final queryString = params.entries
      .map((e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');

  return 'https://accounts.google.com/o/oauth2/v2/auth?$queryString';
}

/// Redirect browser đến Google OAuth — gọi từ Flutter khi click button
void redirectToGoogleOAuth({
  required String clientId,
  required String redirectUri,
}) {
  final url = buildGoogleOAuthUrl(
    clientId: clientId,
    redirectUri: redirectUri,
  );
  web.window.location.href = url;
}

/// Parse id_token từ URL hash (returned by Google OAuth fragment redirect)
/// Hash format: #id_token=xxx&state=yyy
String? parseIdTokenFromHash(String hash) {
  if (hash.isEmpty || !hash.startsWith('#')) return null;
  final params = Uri.splitQueryString(hash.substring(1));
  return params['id_token'];
}
