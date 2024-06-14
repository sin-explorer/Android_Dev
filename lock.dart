import 'package:flutter/material.dart';
import 'package:project/database_helper.dart';
import 'package:project/saved.dart';

class SmartLockConfigurationPage extends StatefulWidget {
  final String option;

  const SmartLockConfigurationPage({Key? key, required this.option})
      : super(key: key);

  @override
  _SmartLockConfigurationPageState createState() =>
      _SmartLockConfigurationPageState();
}

class _SmartLockConfigurationPageState
    extends State<SmartLockConfigurationPage> {
  List<Map<String, dynamic>> smartLockConfigs = [];
  bool showSubmitButton = false;
  double totalPrice = 0; // Total price initialized to 0

  void _smartLockOption() {
    setState(() {
      smartLockConfigs.add({
        'doorType': 'Wooden',
        'fingerprint': false,
        'otp': false,
        'card': false,
        'key': false,
      });
      showSubmitButton = true;
    });
  }

  void _submitConfigurationSmartLock() async {
    // Iterate over smartLockConfigs to submit each configuration
    for (var config in smartLockConfigs) {
      int id = await DatabaseHelper().insertSmartLock({
        'doorType': config['doorType'],
        'fingerprint': config['fingerprint'] ? 1 : 0,
        'otp': config['otp'] ? 1 : 0,
        'card': config['card'] ? 1 : 0,
        'keyLock': config['key'] ? 1 : 0,
      });

      if (id != 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Smart lock configuration saved')),
        );
      }
    }
  }

  void _displaySavedOptions() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SavedOptionsPage()),
    );
  }

  // Function to calculate total price based on selected options
  void _calculateTotalPrice() {
    double basePrice = 100; // Base price for wooden door type
    double pricePerOption = 50; // Price for each additional option

    setState(() {
      totalPrice = basePrice; // Initialize total price with base price

      // Add price for each selected option
      for (var config in smartLockConfigs) {
        if (config['fingerprint']) totalPrice += pricePerOption;
        if (config['otp']) totalPrice += pricePerOption;
        if (config['card']) totalPrice += pricePerOption;
        if (config['key']) totalPrice += pricePerOption;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Smart Lock Configuration',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.bold,
            ),
          ),
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
              const SizedBox(height: 20.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: smartLockConfigs.length,
                itemBuilder: (context, index) {
                  return SmartLock(
                    smartLockNumber: index + 1,
                    onSubmit: (doorType, fingerprint, otp, card, key) {
                      // Update the configuration in the list
                      setState(() {
                        smartLockConfigs[index]['doorType'] = doorType;
                        smartLockConfigs[index]['fingerprint'] = fingerprint;
                        smartLockConfigs[index]['otp'] = otp;
                        smartLockConfigs[index]['card'] = card;
                        smartLockConfigs[index]['key'] = key;

                        _calculateTotalPrice(); // Recalculate total price
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _smartLockOption,
                child: const Text('+ Smart Locks'),
              ),
              if (showSubmitButton) ...[
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _submitConfigurationSmartLock,
                  child: const Text('Submit'),
                ),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: _displaySavedOptions,
                  child: const Text('Display Saved Options'),
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Total Price: \Rs${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class SmartLock extends StatefulWidget {
  final int smartLockNumber;
  final Function(String, bool, bool, bool, bool) onSubmit;

  const SmartLock({
    Key? key,
    required this.smartLockNumber,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _SmartLockState createState() => _SmartLockState();
}

class _SmartLockState extends State<SmartLock> {
  String doorType = 'Wooden';
  bool fingerprint = false;
  bool otp = false;
  bool card = false;
  bool key = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Smart Lock ${widget.smartLockNumber}',
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10.0),
        Row(
          children: [
            Text(
              'Door Type:',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10.0),
            DropdownButton<String>(
              value: doorType,
              onChanged: (value) {
                setState(() {
                  doorType = value!;
                });
                widget.onSubmit(doorType, fingerprint, otp, card, key);
              },
              items: [
                'Wooden',
                'Glass',
                'Aluminum',
              ].map((e) {
                return DropdownMenuItem<String>(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        Text(
          'Opening Methods',
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Fingerprint'),
            Checkbox(
              value: fingerprint,
              onChanged: (value) {
                setState(() {
                  fingerprint = value!;
                });
                widget.onSubmit(doorType, fingerprint, otp, card, key);
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('OTP'),
            Checkbox(
              value: otp,
              onChanged: (value) {
                setState(() {
                  otp = value!;
                });
                widget.onSubmit(doorType, fingerprint, otp, card, key);
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Card'),
            Checkbox(
              value: card,
              onChanged: (value) {
                setState(() {
                  card = value!;
                });
                widget.onSubmit(doorType, fingerprint, otp, card, key);
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Key'),
            Checkbox(
              value: key,
              onChanged: (value) {
                setState(() {
                  key = value!;
                });
                widget.onSubmit(doorType, fingerprint, otp, card, key);
              },
            ),
          ],
        ),
      ],
    );
  }
}
