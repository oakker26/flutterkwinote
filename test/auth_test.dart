import 'package:kwikwinotes/services/auth/auth_exception.dart';
import 'package:kwikwinotes/services/auth/auth_provider.dart';
import 'package:kwikwinotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Auth', () {
    final provider = MockAuthProvider();
    test('Should not initialized to with', () {
      expect(provider.isInitialized, false);
    });
    test('Cannot logout if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });
    test("Should be able to be initialized", () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });
    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });
    test('Should be able to initialize in less than 2 sec', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 3)));
    test('Create User should delegate to login function', () async {
      final badEmailUser = provider.createUser(
        email: 'layjispy@gmail.com',
        password: 'kwikwi',
      );
      expect(
        badEmailUser,
        throwsA(const TypeMatcher<InvalidCredentialAuthException>()),
      );
      final badPasswordUser =
          provider.createUser(email: 'email@gmail.com', password: 'kwikwi123');
      expect(
        badPasswordUser,
        throwsA(const TypeMatcher<InvalidCredentialAuthException>()),
      );
      final user = await provider.createUser(email: 'kwi', password: 'bwi');
      expect(provider.currentUser, user);
      expect(user?.isEmailVerified, false);
    });
    test('Login Uer should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
    test('Should be able to logout and login again', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'email',
        password: 'password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;
  @override
  Future<AuthUser?> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 2));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;
  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 2));
    _isInitialized = true;
  }

  @override
  Future<AuthUser?> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == "layjispy@gmail.com") throw InvalidCredentialAuthException();
    if (password == 'kwikwi123') throw InvalidCredentialAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 2));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
