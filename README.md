# Simple Sheet Editor

A simplified Flutter application for non-technical users to edit a single field in a Google Sheet. This app is designed for ease of use with no complex options or settings.

## Features

- **Simple One-Field Editing**: Edit just one text field in your Google Sheet
- **Google Sign-In**: Secure authentication (handled automatically)
- **Google Sheets Integration**: Read and save data to your Google Sheet
- **No Formatting Options**: Clean, simple interface with plain text input only
- **Cross-Platform**: Works on Android, iOS, Web, Windows, macOS, and Linux
- **Material Design 3**: Modern, clean UI following Material Design guidelines
- **Runtime Spreadsheet Selection**: Change spreadsheet ID without rebuilding the app

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

4. **Set up runtime spreadsheet access:**
   - **Option 1: Environment Variable (Recommended for production)**
     ```bash
     # For local development
     export SPREADSHEET_ID=your_sheet_id
     ```
   
   - **Option 2: Configuration Screen (For user flexibility)**
     The app will include a simple settings screen to enter the spreadsheet ID

   - **Option 3: Build-time with fallback (Current approach)**
     ```bash
     flutter build apk --release --dart-define=SPREADSHEET_ID=your_sheet_id
     ```

5. **Run the app:**
   ```bash
   flutter run
   ```

## How to Use

1. **Sign in** with Google
2. **Edit the text** field (letters, numbers only) 
3. **Click "Save"** to update Google Sheets
4. **View current content** below the editor

To change spreadsheets without rebuilding:

**Option 1 (Recommended for most users):**
- Set the `SPREADSHEET_ID` environment variable before running the app
- **Android**: `adb shell export SPREADSHEET_ID=your_sheet_id && am start -n com.example.app/com.example.app.MainActivity`
- **iOS**: `simctl env SPREADSHEET_ID=your_sheet_id` (for simulator)
- **Web**: Set environment variable in deployment platform (Vercel, Netlify, etc.)

**Option 2 (Built-in settings):**
- A simple settings screen will appear allowing users to enter their spreadsheet ID
- This provides the most user-friendly experience for non-technical users

## Project Structure

```
lib/
├── main.dart              # App entry point & auth wrapper
└── screens/
    └── simple_edit_screen.dart   # Simple editing interface
└── services/
    ├── auth_service.dart         # Google Sign-In & token management
    └── sheet_service.dart       # Google Sheets API with runtime SPREADSHEET_ID support
└── utils/
    └── constants.dart           # App-wide constants
```

## Building for Release

### Android (Build-time configuration still supported)
```bash
flutter build apk --release --dart-define=SPREADSHEET_ID=your_sheet_id
```

### iOS (Build-time configuration still supported)
```bash
flutter build ios --release --no-codesign --dart-define=SPREADSHEET_ID=your_sheet_id
```

### Web (Environment variables for production)
```bash
flutter build web --release --dart-define=SPREADSHEET_ID=your_sheet_id
```

## CI/CD

### GitHub Actions (Build-time configuration)
The workflows can use the `SPREADSHEET_ID` secret from repository settings:

```yaml
env:
  SPREADSHEET_ID: ${{ secrets.SPREADSHEET_ID }}
```

### Future Enhancement (Runtime Configuration)
Future updates could include:
- A settings screen for users to enter their spreadsheet ID
- Support for cloud-based configuration management
- Multi-spreadsheet support for enterprise environments

## Dependencies

- `google_sign_in` - Google authentication
- `googleapis` & `googleapis_auth` - Google Sheets & Drive API access
- `flutter_secure_storage` - Secure token storage
- `http` - HTTP client for API requests
- `shared_preferences` - Local preferences

## Security

- Access tokens are stored securely using `flutter_secure_storage`
- No credentials are committed to the repository
- Spreadsheet ID is configurable at runtime or via environment variables
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