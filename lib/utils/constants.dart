// Constants for the Simple Sheet Editor app

class Constants {
  // App name
  static const String appName = 'Simple Sheet Editor';

  // Field configuration
  static const int maxFieldNameLength = 50;
  static const int maxDescriptionLength = 1000;

  // Validation messages
  static const String fieldNameRequired = 'Please select a field';
  static const String descriptionRequired = 'Please enter some text';
  static const String saveSuccess = 'Data saved successfully!';
  static const String saveError = 'Failed to save data';

  // Sheet configuration
  static const String defaultFieldName = 'Basic Text';

  // Animation durations
  static const int dialogAnimationDuration = 200;
  static const int snackBarDuration = 2000;
}

// Field options for the simple editor
class FieldOptions {
  // List of available field names
  static const List<String> fieldNames = [
    'Basic Text',
    'Description',
    'Notes',
    'Title',
    'Content',
    'Simple Text',
    'Main Text',
    'Body',
    'Details',
    'Info',
    'Summary',
  ];
}

// Validation rules for user input
class ValidationRules {
  // Allowed input characters (basic letters, numbers, and spaces)
  static const String allowedCharacters = r'^[a-zA-Z0-9\s.,!?\-\'"@]+$';

  // Maximum field lengths
  static const int nameMinLength = 1;
  static const int nameMaxLength = 100;
  static const int descriptionMinLength = 1;
  static const int descriptionMaxLength = 1000;
}