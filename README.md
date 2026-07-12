# eBay Sheet Editor

A simple Flutter application for editing Google Sheets data, designed for non-technical users to manage inventory or product listings.

## Features

- **Google Sign-In**: Secure authentication using Google OAuth 2.0
- **Google Sheets Integration**: Read, create, update, and delete items in a Google Sheet
- **Offline Support**: Cached data for viewing when offline
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
   - Set it as a build-time constant or environment variable:
     ```bash
     # Build-time (recommended for CI/CD)
     flutter build apk --release --dart-define=SPREADSHEET_ID=your_sheet_id
     
     # Or set as environment variable for runtime
     export SPREADSHEET_ID=your_sheet_id
     flutter run
     ```

5. **Run the app:**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry point & authentication wrapper
├── models/
│   └── sheet_item.dart       # Data model for sheet items
├── screens/
│   ├── sheet_list_screen.dart   # Main list view with CRUD operations
│   └── edit_item_screen.dart    # Form for adding/editing items
├── services/
│   ├── auth_service.dart        # Google Sign-In & token management
│   └── sheet_service.dart       # Google Sheets API operations
├── utils/
│   └── constants.dart           # App-wide constants
└── widgets/
    └── item_tile.dart           # Reusable list item widget
```

## Building for Release

### Android
```bash
flutter build apk --release --dart-define=SPREADSHEET_ID=your_sheet_id
# or
flutter build appbundle --release --dart-define=SPREADSHEET_ID=your_sheet_id
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
- `intl` - Internationalization
- `flutter_slidable` - Swipe-to-delete list items

## Security

- Access tokens are stored securely using `flutter_secure_storage`
- No credentials are committed to the repository
- Spreadsheet ID is configured via build-time constants or environment variables
- OAuth scopes are limited to Sheets and Drive.file access only

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run `flutter analyze` and `flutter test`
5. Submit a pull request

## Support

For issues and feature requests, please use the GitHub issue tracker.