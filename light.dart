import 'package:flutter/material.dart';
import 'package:project/saved_light.dart';
import 'database_helper_light.dart';

void main() {
  runApp(MaterialApp(
    home: LightConfigurationPage(option: 'Light'),
  ));
}

class LightConfigurationPage extends StatefulWidget {
  final String option;

  const LightConfigurationPage({Key? key, required this.option})
      : super(key: key);

  @override
  _LightConfigurationPageState createState() => _LightConfigurationPageState();
}

class _LightConfigurationPageState extends State<LightConfigurationPage> {
  List<GlobalKey<_LightSolutionState>> lightSolutionKeys = [];
  int solutionCount = 0;
  double totalPrice = 0; // Total price initialized to 0

  void _addLightSolution() {
    setState(() {
      solutionCount++;
      lightSolutionKeys.add(GlobalKey<_LightSolutionState>());
    });
  }

  Future<void> _submitConfigurationLight() async {
    for (var key in lightSolutionKeys) {
      await key.currentState?.saveToDatabase();
    }
    _calculateTotalPrice(); // Calculate total price after saving data
    setState(() {}); // Refresh UI after saving data
  }

  // Function to calculate total price based on selected options
  void _calculateTotalPrice() {
    double basePrice = 50; // Base price for Dimmer + COB
    double pricePerOption = 20; // Price for each additional option

    setState(() {
      totalPrice =
          basePrice * solutionCount; // Initialize total price with base price

      // Add price for each selected option in each solution
      for (var key in lightSolutionKeys) {
        if (key.currentState?._driverType == 'Switch')
          totalPrice += pricePerOption;
        if (key.currentState?._lightType == 'LED Strip')
          totalPrice += pricePerOption;
        if (key.currentState?._useCCTDimmer ?? false)
          totalPrice += pricePerOption; // Use null-aware operator
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Light Configuration - ${widget.option}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${widget.option} Configuration',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 20.0),
            Column(
              children: lightSolutionKeys
                  .map((key) => LightSolution(key: key))
                  .toList(),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _addLightSolution,
              child: Text('+ Add Light Solution'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _submitConfigurationLight,
              child: Text('Save'),
            ),
            SizedBox(height: 20.0),
            if (lightSolutionKeys.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SavedDataPage()),
                  );
                },
                child: Text('Display Saved Data'),
              ),
            SizedBox(height: 20.0),
            Text(
              'Total Price: \Rs${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LightSolution extends StatefulWidget {
  const LightSolution({Key? key}) : super(key: key);

  @override
  _LightSolutionState createState() => _LightSolutionState();
}

class _LightSolutionState extends State<LightSolution> {
  String _driverType = 'Dimmer';
  String _lightType = 'COB';
  bool _useCCTDimmer = false;

  Future<void> saveToDatabase() async {
    final dbHelper = DatabaseHelper();
    Map<String, dynamic> solution = {
      'driverType': _driverType,
      'lightType': _lightType,
      'useCCTDimmer': _useCCTDimmer ? 1 : 0,
    };
    await dbHelper.insertLightSolution(solution);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Light Solution',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.0),
            _buildDropdown('Driver Type', _driverType, [
              'Dimmer',
              'Switch',
              'Transformer',
            ], (value) {
              setState(() {
                _driverType = value;
              });
            }),
            SizedBox(height: 12.0),
            _buildDropdown('Light Type', _lightType, [
              'COB',
              'LED Strip',
              'Bulb',
            ], (value) {
              setState(() {
                _lightType = value;
              });
            }),
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Use CCT Dimmer: '),
                Checkbox(
                  value: _useCCTDimmer,
                  onChanged: (value) {
                    setState(() {
                      _useCCTDimmer = value ?? false;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> options,
      Function(String) onChanged) {
    return Row(
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 12.0),
        DropdownButton<String>(
          value: value,
          onChanged: (newValue) {
            onChanged(newValue!);
          },
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
        ),
      ],
    );
  }
}
