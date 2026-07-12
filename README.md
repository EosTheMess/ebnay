# Simple Sheet Editor

A simplified Flutter application for non-technical users to edit a single field in a Google Sheet. This app is designed for ease of use with no complex options or settings.

## Features

- **Simple One-Field Editing**: Edit just one text field in your Google Sheet
- **Google Sign-In**: Secure authentication (handled automatically)
- **Google Sheets Integration**: Read and save data to your Google Sheet
- **No Formatting Options**: Clean, simple interface with plain text input only
- **Cross-Platform**: Works on Android, iOS, Web, Windows, macOS, and Linux
- **Material Design 3**: Modern, clean UI following Material Design guidelines

## Prerequisites

- Flutter SDK 3.19.0 or higher
- Dart SDK 3.3.0 or higher
- Google Cloud Console project with:
  - Google Sheets API enabled
  - Google Drive API enabled
  - OAuth 2.0 credentials configured

## Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/ebnay.git
   cd ebnay
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Google Cloud credentials:**
   - Create a project in [Google Cloud Console](https://console.cloud.google.com/)
   - Enable the Google Sheets API and Google Drive API
   - Create OAuth 2.0 credentials (Client ID for Android, iOS, and Web)
   - Add the credentials to the platform-specific configuration files:
     - **Android**: `android/app/src/main/res/values/strings.xml`
     - **iOS**: `ios/Runner/Info.plist`
     - **Web**: `web/index.html`

4. **Set the Spreadsheet ID:**
   - Find your Google Sheet ID from the URL: `https://docs.google.com/spreadsheets/d/{SPREADSHEET_ID}/edit`
   - Set it as a build-time constant:
     ```bash
     # Build-time (recommended for CI/CD)
     flutter build apk --release --dart-define=SPREADSHEET_ID=your_sheet_id
     ```

5. **Run the app:**
   ```bash
   flutter run
   ```

## How to Use

1. **Sign in with Google**: The app will automatically ask you to sign in with your Google account
2. **Select your field**: Choose from a dropdown menu of available fields in your sheet
3. **Edit text**: Type or modify the text (letters, numbers, and spaces only)
4. **Save**: Click the Save button to store your changes in Google Sheets
5. **View updates**: The app shows the current content below the editor

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/
│   └── simple_edit_screen.dart   # Simple single-field editor
├── services/
│   ├── auth_service.dart        # Google Sign-In & token management
│   └── sheet_service.dart       # Google Sheets API operations
├── utils/
│   └── constants.dart           # App-wide constants
└── models/
    └── sheet_item.dart         # Data model for sheet items
```

## Building for Release

### Android
```bash
flutter build apk --release --dart-define=SPREADSHEET_ID=your_sheet_id
```

### iOS
```bash
flutter build ios --release --no-codesign --dart-define=SPREADSHEET_ID=your_sheet_id
```

### Web
```bash
flutter build web --release --dart-define=SPREADSHEET_ID=your_sheet_id
```

## CI/CD

This project includes GitHub Actions workflows for automatic building:

- **Android**: Builds release APK on push to main
- **iOS**: Builds unsigned iOS app on push to main

The workflows use the `SPREADSHEET_ID` secret from GitHub repository settings.

## Dependencies

- `google_sign_in` - Google authentication
- `googleapis` & `googleapis_auth` - Google Sheets & Drive API access
- `flutter_secure_storage` - Secure token storage
- `http` - HTTP client for API requests
- `shared_preferences` - Local preferences
- `path_provider` - File system access

## Security

- Access tokens are stored securely using `flutter_secure_storage`
- No credentials are committed to the repository
- Spreadsheet ID is configured via build-time constants
- OAuth scopes are limited to Sheets and Drive.file access only

## License

This project is licensed under the MIT License - see the LICENSE file for details.