import 'package:flutter/material.dart';
import 'package:project/light.dart';
import 'database_helper_light.dart'; // Ensure you import the main file where LightConfigurationPage is defined

class SavedDataPage extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LightConfigurationPage(option: 'Light'),
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Saved Light Solutions'),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: dbHelper.getLightSolutions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No light solutions saved.'));
            } else {
              final solutions = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: solutions.length,
                      itemBuilder: (context, index) {
                        final solution = solutions[index];
                        return Card(
                          elevation: 4.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Light Solution ${index + 1}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text('Driver Type: ${solution['driverType']}'),
                                SizedBox(height: 8.0),
                                Text('Light Type: ${solution['lightType']}'),
                                SizedBox(height: 8.0),
                                Text(
                                    'Use CCT Dimmer: ${solution['useCCTDimmer'] == 1 ? 'Yes' : 'No'}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _showClearConfirmationDialog(context);
                      },
                      child: Text('Clear Data'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 255, 253, 253), // Background color
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _showClearConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clear Saved Data'),
          content: SingleChildScrollView(
            child: Text('Are you sure you want to clear all saved data?'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _clearAllData(context);
              },
              child: Text('Clear',
                  style: TextStyle(color: Color.fromARGB(255, 254, 0, 0))),
            ),
          ],
        );
      },
    );
  }

  Future<void> _clearAllData(BuildContext context) async {
    await dbHelper.clearLightSolutions();
    Navigator.of(context).pop(); // Dismiss the dialog
    // To refresh the page after clearing the data
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => SavedDataPage()),
    );
  }
}
