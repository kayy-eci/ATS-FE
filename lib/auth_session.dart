// Menyimpan JWT in-memory selama aplikasi berjalan.
// Backend tidak diubah, jadi token adalah JWT dari POST /api/auth/login.
class AuthSession {
  AuthSession._();
  static final AuthSession instance = AuthSession._();

  String? token;
  String? username;

  bool get isLoggedIn => token != null && token!.isNotEmpty;

  void setSession({required String token, String? username}) {
    this.token = token;
    if (username != null) this.username = username;
  }

  void clear() {
    token = null;
    username = null;
  }
}
