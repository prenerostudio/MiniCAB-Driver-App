import 'base_auth_user_provider.dart';

class SimpleAuthUser extends BaseAuthUser {
  SimpleAuthUser({this.isLoggedIn = false, AuthUserInfo? userInfo})
    : authUserInfo = userInfo ?? const AuthUserInfo();

  final bool isLoggedIn;

  @override
  final AuthUserInfo authUserInfo;

  @override
  bool get emailVerified => false;

  @override
  bool get loggedIn => isLoggedIn;

  @override
  Future<void> delete() async {}

  @override
  Future<void> updateEmail(String email) async {}

  @override
  Future<void> sendEmailVerification() async {}
}

Stream<BaseAuthUser> simpleAuthUserStream() {
  final user = SimpleAuthUser();
  currentUser = user;
  return Stream<BaseAuthUser>.value(user).asBroadcastStream();
}
