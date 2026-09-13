class AuthSession {
  AuthSession._();
  static final AuthSession instance = AuthSession._();

  String? token;
  String? username;
  String? email;

  bool get isLoggedIn => token != null && token!.isNotEmpty;

  void setSession({required String token, String? username, String? email}) {
    this.token = token;
    if (username != null) this.username = username;
    if (email != null) this.email = email;
  }

  void clear() {
    token = null;
    username = null;
    email = null;
  }
}
