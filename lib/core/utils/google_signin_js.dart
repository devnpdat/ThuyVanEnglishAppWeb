import 'dart:js_interop';
import 'dart:js_interop_unsafe';

// JS types
extension type GoogleCredentialResponse._(JSObject _) implements JSObject {
  external String get credential;
}

extension type GoogleIdConfig._(JSObject _) implements JSObject {
  external factory GoogleIdConfig({
    required String client_id,
    required JSFunction callback,
    String? ux_mode,
    String? response_mode,
    bool? auto_select,
    bool? cancel_on_tap_outside,
  });
}

extension type GoogleButtonConfig._(JSObject _) implements JSObject {
  external factory GoogleButtonConfig({
    String? type,
    String? shape,
    String? theme,
    String? size,
    String? text,
    String? locale,
    int? width,
  });
}

@JS('google.accounts.id.initialize')
external void _googleInitialize(GoogleIdConfig config);

@JS('google.accounts.id.renderButton')
external void _googleRenderButton(JSObject element, GoogleButtonConfig config);

@JS('document.getElementById')
external JSObject? _getElementById(String id);

/// Đăng ký Dart callback để nhận credential từ GIS (qua window._dartGoogleCallback)
void registerGoogleCallback(void Function(String idToken) onCredential) {
  globalContext.setProperty(
    '_dartGoogleCallback'.toJS,
    ((String credential) => onCredential(credential)).toJS,
  );
}

/// Init GIS + render button vào div có id [buttonDivId]
/// ux_mode: redirect — tránh COOP block
void initGoogleSignIn({
  required String clientId,
  required String buttonDivId,
  required void Function(String idToken) onCredential,
}) {
  // Đăng ký callback
  registerGoogleCallback(onCredential);

  // Initialize GIS
  _googleInitialize(GoogleIdConfig(
    client_id: clientId,
    callback: ((GoogleCredentialResponse response) {
      onCredential(response.credential);
    }).toJS,
    ux_mode: 'redirect', // redirect mode — không dùng popup, tránh COOP block
    response_mode: 'fragment', // fragment mode — Google redirect bằng GET #credential, tránh nginx 405
    auto_select: false,
    cancel_on_tap_outside: true,
  ));
}

/// Render GIS button vào div element sau khi Flutter build xong
void renderGoogleButton(String buttonDivId) {
  final el = _getElementById(buttonDivId);
  if (el != null) {
    _googleRenderButton(
      el,
      GoogleButtonConfig(
        type: 'standard',
        shape: 'rectangular',
        theme: 'outline',
        size: 'large',
        text: 'signin_with',
        locale: 'vi',
        width: 400,
      ),
    );
  }
}
