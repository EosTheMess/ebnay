import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const _scopes = [
    'https://www.googleapis.com/auth/spreadsheets',
    'https://www.googleapis.com/auth/drive.file',
  ];

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: _scopes,
    serverClientId: const String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID'),
  );

  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static Future<bool> isSignedIn() async {
    final account = await _googleSignIn.currentUser;
    if (account != null) {
      final token = await _storage.read(key: 'access_token');
      return token != null;
    }
    return false;
  }

  static Future<void> signIn() async {
    final account = await _googleSignIn.signIn();
    if (account == null) {
      throw Exception('Sign in cancelled');
    }

    final auth = await account.authentication;
    if (auth.accessToken == null) {
      throw Exception('Failed to get access token');
    }

    await _storage.write(key: 'access_token', value: auth.accessToken);
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _storage.delete(key: 'access_token');
  }

  static Future<AuthClient> getAuthClient() async {
    final token = await _storage.read(key: 'access_token');
    if (token == null) {
      throw Exception('Not authenticated');
    }
    return clientViaAccessToken(
      http.Client(),
      AccessCredentials(
        AccessToken('Bearer', token, DateTime.now().add(const Duration(hours: 1))),
        null,
        _scopes,
      ),
    );
  }

  static Future<void> refreshToken() async {
    final account = await _googleSignIn.currentUser;
    if (account == null) throw Exception('Not signed in');
    
    final auth = await account.authentication;
    if (auth.accessToken != null) {
      await _storage.write(key: 'access_token', value: auth.accessToken);
    }
  }
}
