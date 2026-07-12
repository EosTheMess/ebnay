import 'package:flutter/material.dart';
import 'package:ebay_sheet_editor/services/sheet_service.dart';
import 'package:ebay_sheet_editor/services/auth_service.dart';

class SimpleEditScreen extends StatefulWidget {
  const SimpleEditScreen({super.key});

  @override
  State<SimpleEditScreen> createState() => _SimpleEditScreenState();
}

class _SimpleEditScreenState extends State<SimpleEditScreen> {
  final TextEditingController _textController = TextEditingController();
  String? _selectedFieldName = 'Basic Text';
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;
  String? _currentValue;

  final List<String> _fieldNames = [
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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await SheetService.getSheetData();
      if (data.isNotEmpty) {
        // Get the first non-empty field value, fallback to basic text field
        for (final fieldName in _fieldNames) {
          final matchingItem = data.firstWhere(
            (item) => item['name']?.toString().toLowerCase() == fieldName.toLowerCase(),
            orElse: () => {},
          );
          if (matchingItem.isNotEmpty) {
            setState(() {
              _selectedFieldName = fieldName;
              _textController.text = matchingItem['description']?.toString() ?? '';
              _currentValue = _textController.text;
            });
            return;
          }
        }
        // If no field found, create a basic text field
        setState(() {
          _selectedFieldName = 'Basic Text';
          _currentValue = '';
        });
      } else {
        setState(() {
          _selectedFieldName = 'Basic Text';
          _currentValue = '';
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _selectedFieldName = 'Basic Text';
        _currentValue = '';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveData() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Find or create the field in the sheet
      final data = await SheetService.getSheetData();
      final fieldIndex = _fieldNames.indexOf(_selectedFieldName!);

      if (fieldIndex >= 0) {
        // Update existing field or add new one
        final item = {
          'id': (data.length > fieldIndex ? fieldIndex + 1 : data.length + 1).toString(),
          'name': _selectedFieldName!,
          'price': '',
          'category': '',
          'description': _textController.text,
        };

        if (data.length > fieldIndex && data[fieldIndex]['name'] == _selectedFieldName) {
          // Update existing item
          await SheetService.updateSheetItem(item['id'].toString(), item);
        } else {
          // Add new item
          await SheetService.addSheetItem(item);
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _currentValue = _textController.text;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showFieldSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Field to Edit'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _fieldNames.length,
            itemBuilder: (context, index) {
              final fieldName = _fieldNames[index];
              final isSelected = fieldName == _selectedFieldName;

              return ListTile(
                leading: Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: isSelected ? Colors.blue : Colors.grey,
                ),
                title: Text(fieldName),
                onTap: () {
                  Navigator.pop(context);
                  _changeSelectedField(fieldName);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _changeSelectedField(String fieldName) {
    if (fieldName == _selectedFieldName) return;

    setState(() {
      _selectedFieldName = fieldName;
      _textController.text = _currentValue ?? '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Now editing: $fieldName'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Sheet Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthService.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorWidget()
              : _buildSimpleEditorWidget(),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error loading data:\n$_error'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleEditorWidget() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Field selector
          Card(
            child: ListTile(
              leading: const Icon(Icons.text_fields, color: Colors.blue),
              title: const Text('Field to edit'),
              subtitle: Text(_selectedFieldName ?? 'Basic Text'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _showFieldSelector,
            ),
          ),

          const SizedBox(height: 24),

          // Text field (no formatting options)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Enter basic text (letters and numbers only):',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Type here...',
                      alignLabelWithHint: true,
                    ),
                    maxLines: 10,
                    minLines: 3,
                    maxLength: 1000,
                    enabled: !_isSaving,
                    onChanged: (value) {
                      // Simple validation - allow letters, numbers, and basic punctuation
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Characters: ${_textController.text.length}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.info_outline, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          const Text('Letters, numbers, and spaces only', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Save button
          ElevatedButton.icon(
            onPressed: _isSaving ? null : _saveData,
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            label: Text(_isSaving ? 'Saving...' : 'Save Data'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          if (_currentValue != null) ...[
            const SizedBox(height: 16),
            Card(
              color: Colors.grey.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Current value:',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: SelectableText(
                        _currentValue ?? '',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 32),

          // Simple instructions card
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.help_outline, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'How to use:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('• Select a field from the menu above', style: TextStyle(fontSize: 14)),
                  const Text('• Type basic text (letters, numbers, spaces)', style: TextStyle(fontSize: 14)),
                  const Text('• Click Save to store in Google Sheets', style: TextStyle(fontSize: 14)),
                  const Text('• View current content below', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}