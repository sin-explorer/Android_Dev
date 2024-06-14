import 'package:flutter/material.dart';
import 'package:project/database_helper.dart';

class SavedOptionsPage extends StatefulWidget {
  @override
  _SavedOptionsPageState createState() => _SavedOptionsPageState();
}

class _SavedOptionsPageState extends State<SavedOptionsPage> {
  late Future<List<Map<String, dynamic>>> _smartLocksFuture;

  @override
  void initState() {
    super.initState();
    _smartLocksFuture = _getSmartLocks();
  }

  Future<List<Map<String, dynamic>>> _getSmartLocks() async {
    return await DatabaseHelper().getSmartLocks();
  }

  void _clearSavedOptions() async {
    await DatabaseHelper().clearSmartLocks();
    setState(() {
      _smartLocksFuture = _getSmartLocks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Smart Lock Options'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _smartLocksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            List<Map<String, dynamic>> smartLocks = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: smartLocks.length,
                    itemBuilder: (context, index) {
                      return _buildSmartLockItem(smartLocks[index]);
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: _clearSavedOptions,
                  child: Text('Clear Data'),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: Text('No saved options'));
          }
        },
      ),
    );
  }

  Widget _buildSmartLockItem(Map<String, dynamic> smartLock) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Door Type: ${smartLock['doorType']}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Fingerprint: ${smartLock['fingerprint'] == 1 ? 'Enabled' : 'Disabled'}',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              'OTP: ${smartLock['otp'] == 1 ? 'Enabled' : 'Disabled'}',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              'Card: ${smartLock['card'] == 1 ? 'Enabled' : 'Disabled'}',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              'Key: ${smartLock['keyLock'] == 1 ? 'Enabled' : 'Disabled'}',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
