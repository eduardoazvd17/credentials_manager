library credentials_manager;

export 'models/credential_model.dart';

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'models/credential_model.dart';

/// A library to easy manage your app credentials
class CredentialsManager {
  late final LocalAuthentication _auth;
  late final FlutterSecureStorage _storage;

  /// The identifier of the secure storage.
  final String storageKey;

  CredentialsManager({
    required this.storageKey,
  })  : _auth = LocalAuthentication(),
        _storage = const FlutterSecureStorage();

  /// Returns true if device is capable of checking biometrics.
  Future<bool> canCheckBiometrics() async {
    return await _auth.canCheckBiometrics;
  }

  /// Returns true if device is capable of checking biometrics or is able to
  /// fail over to device credentials.
  Future<bool> isDeviceSupportedByAuth() async {
    return await _auth.isDeviceSupported();
  }

  /// Authenticates the user with biometrics available on the device while also
  /// allowing the user to use device authentication - pin, pattern, passcode.
  ///
  /// [authReasonMessage] is the message to show to user while prompting them
  /// for authentication.
  ///
  /// [biometricOnly] Prevent authentications from using non-biometric
  /// local authentication such as pin, passcode, or pattern.
  ///
  /// [cannotAuthResult] Use this parameter to ignore if the user's device
  /// does not have biometrics available or is not compatible.
  Future<bool> requestAuth({
    String authReasonMessage = 'Please authenticate to continue.',
    bool biometricOnly = false,
    bool cannotAuthResult = false,
  }) async {
    final bool isAvailable = await _auth.canCheckBiometrics;
    final bool isDeviceSupported = await _auth.isDeviceSupported();
    final bool canAuthenticate = isAvailable && isDeviceSupported;

    if (canAuthenticate) {
      try {
        final bool didAuthenticate = await _auth.authenticate(
          localizedReason: authReasonMessage,
          options: AuthenticationOptions(
            biometricOnly: biometricOnly,
          ),
        );
        return didAuthenticate;
      } catch (error) {
        return false;
      }
    }
    return cannotAuthResult;
  }

  /// Save credential in a secure local storage.
  Future<void> saveCredential(CredentialModel credentialModel) async {
    final String? jsonData = await _storage.read(key: storageKey);
    if (jsonData != null) {
      final data = List<Map<String, String?>>.from(jsonDecode(jsonData));
      final List<CredentialModel> credentials =
          data.map((e) => CredentialModel.fromMap(e)).toList();

      if (credentials.contains(credentialModel)) {
        credentials.remove(credentialModel);
      }
      credentials.insert(0, credentialModel);
      _storage.write(key: storageKey, value: credentials.toString());
    } else {
      final List<CredentialModel> credentials = [credentialModel];
      _storage.write(key: storageKey, value: credentials.toString());
    }
  }

  /// Get all saved credentials
  Future<List<CredentialModel>> getSavedCredentials() async {
    final String? jsonData = await _storage.read(key: storageKey);
    if (jsonData != null) {
      final data = List<Map<String, String?>>.from(jsonDecode(jsonData));
      final List<CredentialModel> credentials =
          data.map((e) => CredentialModel.fromMap(e)).toList();
      return credentials;
    } else {
      return [];
    }
  }

  /// Remove a single credential from storage.
  Future<void> removeCredential(CredentialModel credentialModel) async {
    final String? jsonData = await _storage.read(key: storageKey);
    if (jsonData != null) {
      final data = List<Map<String, String?>>.from(jsonDecode(jsonData));
      final List<CredentialModel> credentials =
          data.map((e) => CredentialModel.fromMap(e)).toList();
      if (credentials.contains(credentialModel)) {
        credentials.remove(credentialModel);
      }
      _storage.write(key: storageKey, value: credentials.toString());
    }
  }

  /// Remove all credentials from storage.
  Future<void> removeAllCredentials() async {
    await _storage.delete(key: storageKey);
  }
}
