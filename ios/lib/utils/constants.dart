class Constants {
  // Add your Google Spreadsheet ID here (format: xxxx...xxxx)
  static const String spreadsheetId = String.fromEnvironment('SPREADSHEET_ID', defaultValue: '');

  // Google API scopes for Sheets and Drive access
  static const List<String> googleScopes = [
    'https://www.googleapis.com/auth/spreadsheets',
    'https://www.googleapis.com/auth/drive.file',
  ];

  // Default sheet name
  static const String defaultSheetName = 'Sheet1';
}
