import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:ebay_sheet_editor/services/auth_service.dart';

class SheetService {
  static const String? _spreadsheetId = String.fromEnvironment('SPREADSHEET_ID');

  static Future<List<Map<String, dynamic>>> getSheetData() async {
    if (_spreadsheetId == null || _spreadsheetId!.isEmpty) {
      return _getDummyData();
    }

    final authClient = await AuthService.getAuthClient();
    final sheetsApi = sheets.SheetsApi(authClient);

    try {
      final result = await sheetsApi.spreadsheets.values.get(
        _spreadsheetId!,
        'Sheet1!A1:Z1000',
      );

      final values = result.values ?? [];
      return _convertToMapList(values);
    } catch (e) {
      print('Error fetching sheet data: $e');
      return _getDummyData();
    }
  }

  static List<Map<String, dynamic>> _getDummyData() {
    return [
      {
        'id': '1',
        'name': 'Sample Item 1',
        'price': '\$29.99',
        'category': 'Electronics',
        'description': 'Sample electronic item',
      },
      {
        'id': '2',
        'name': 'Vintage T-Shirt',
        'price': '\$49.99',
        'category': 'Clothing',
        'description': 'Authentic vintage style',
      },
    ];
  }

  static List<Map<String, dynamic>> _convertToMapList(List<List<dynamic>> rawData) {
    if (rawData.isEmpty) return _getDummyData();

    final List<Map<String, dynamic>> result = [];
    final headers = rawData[0];

    for (int i = 1; i < rawData.length; i++) {
      final row = rawData[i];
      if (row.isEmpty) continue;

      final rowData = <String, dynamic>{};

      for (int j = 0; j < headers.length; j++) {
        if (j < row.length) {
          rowData[headers[j].toString().toLowerCase().trim()] = row[j];
        }
      }

      rowData['id'] = i.toString();
      result.add(rowData);
    }

    return result;
  }

  static Future<bool> updateSheetData(List<Map<String, dynamic>> data) async {
    if (_spreadsheetId == null || _spreadsheetId!.isEmpty) {
      return false;
    }

    final authClient = await AuthService.getAuthClient();
    final sheetsApi = sheets.SheetsApi(authClient);

    try {
      final values = _convertToTableData(data);
      final valueRange = sheets.ValueRange()
        ..values = values;

      await sheetsApi.spreadsheets.values.update(
        valueRange,
        _spreadsheetId!,
        'Sheet1!A1:Z',
        valueInputOption: 'USER_ENTERED',
      );
      return true;
    } catch (e) {
      print('Error updating sheet: $e');
      return false;
    }
  }

  static List<List<dynamic>> _convertToTableData(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return [];

    final headers = ['ID', 'Name', 'Price', 'Category', 'Description'];
    final values = <List<dynamic>>[headers];

    for (final item in data) {
      final row = <dynamic>[
        item['id'] ?? '',
        item['name'] ?? '',
        item['price'] ?? '',
        item['category'] ?? '',
        item['description'] ?? '',
      ];
      values.add(row);
    }

    return values;
  }

  static Future<bool> addSheetItem(Map<String, dynamic> item) async {
    final data = await getSheetData();
    final newItem = {...item, 'id': (data.length + 1).toString()};
    final updatedData = [...data, newItem];
    return await updateSheetData(updatedData);
  }

  static Future<bool> updateSheetItem(String id, Map<String, dynamic> item) async {
    final data = await getSheetData();
    final index = data.indexWhere((mapItem) => mapItem['id'] == id);
    if (index == -1) return false;

    final updatedData = List<Map<String, dynamic>>.from(data);
    updatedData[index] = {...item, 'id': id};
    return await updateSheetData(updatedData);
  }

  static Future<bool> deleteSheetItem(String id) async {
    final data = await getSheetData();
    final updatedData = data.where((item) => item['id'] != id).toList();
    return await updateSheetData(updatedData);
  }
}
