class AuthSession {
  AuthSession._();

  static int? userId;
  static String? username;
  static String? password;
  static String? name;

  static bool get isAuthenticated =>
      userId != null && username != null && password != null;

  static void setSession({
    required int userId,
    required String username,
    required String password,
    String? name,
  }) {
    AuthSession.userId = userId;
    AuthSession.username = username;
    AuthSession.password = password;
    AuthSession.name = name;
  }

  static void clear() {
    userId = null;
    username = null;
    password = null;
    name = null;
  }
}
