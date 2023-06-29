# credentials_manager
A library to easy manage your app credentials

## Features
- Login credentials storage;
- Biometrics authentication;

## Getting started
1 - Import library on pubspec.yaml:
```yaml
dependencies:
  credentials_manager: ^1.0.1
```

2 - Configuration for Android devices:

You need to update your MainActivity class to inherit from "FlutterFragmentActivity" instead of "FlutterActivity".

Java (MainActivity.java):
```java
import io.flutter.embedding.android.FlutterFragmentActivity;

public class MainActivity extends FlutterFragmentActivity {
    // ...
}
```

Kotlin (MainActivity.kt):
```kotlin
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity() {
    // ...
} 
```

Update your project's AndroidManifest.xml file to include the USE_BIOMETRIC permissions:
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="com.example.app">
  
  <uses-permission android:name="android.permission.USE_BIOMETRIC"/>

<manifest>
```

3 - Configuration for iOS devices:

Update your info.plist to:
```xml
<key>NSFaceIDUsageDescription</key>
<string>Granting access will allow you to use face id in this application</string>
```

4 - Add import for CredentialsManager package on your file:
```dart
import 'package:credentials_manager/credentials_manager.dart';
```

5 - Usage:
```dart
/// Creating credentials manager instance.
final credentialsManager = CredentialsManager(
  /// The identifier of the secure storage.
  storageKey: 'storage_key',
  /// EncryptedSharedPrefences are only available on API 23 and greater.
  useAndroidEncryptedSharedPreferences: true
);

/// Creating a new credential model.
final credentialModel = CredentialModel(
  id: 'user_id', // REQUIRED
  loginOrEmail: 'user_login', // REQUIRED
  password: 'user_password', // REQUIRED
  name: 'user_name', // OPTIONAL
  imageUrl: 'user_image_url', // OPTIONAL
);

/// Saving credential.
await credentialsManager.saveCredential(credentialModel);

/// Loading all saved credentials.
final List<CredentialModel> savedCredentials = await credentialsManager.getSavedCredentials();

/// Removing a single credential.
await credentialsManager.removeCredential(credentialModel);

/// Removing all saved credentials.
await credentialsManager.removeAllCredentials();

/// Requesting auth.
final bool isAuth = await credentialsManager.requestAuth(
  /// Message to show to user while prompting them for authentication.
  authReasonMessage: 'Please authenticate to continue.',
  /// Prevent authentications from using non-biometric
  /// local authentication such as pin, passcode, or pattern.
  biometricOnly: false,
  /// Use this parameter to ignore if the user's device
  /// does not have biometrics available or is not compatible.
  cannotAuthResult: false,
);
```

