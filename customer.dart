import 'package:flutter/material.dart';
import 'package:project/database_helper_customer.dart';
import 'package:project/saved_customer.dart';
// ignore: unused_import
import 'package:project/home.dart';

class CustomerDetailPage extends StatelessWidget {
  const CustomerDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Customer Details',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Text(
                'Hi5Ai Retina Pvt Ltd',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Timesnewroman',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        body: CustomerDetailForm(),
      ),
    );
  }
}

class CustomerDetailForm extends StatefulWidget {
  const CustomerDetailForm({Key? key}) : super(key: key);

  @override
  _CustomerDetailFormState createState() => _CustomerDetailFormState();
}

class _CustomerDetailFormState extends State<CustomerDetailForm> {
  final TextEditingController _dealerController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _clientAddressController =
      TextEditingController();
  final TextEditingController _clientContactController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: <Widget>[
          const SizedBox(height: 16.0),
          const Text(
            'DEALER',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: _dealerController,
            decoration: const InputDecoration(
              hintText: 'Enter dealer name',
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'CLIENT NAME',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: _clientNameController,
            decoration: const InputDecoration(
              hintText: 'Enter client name',
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'CLIENT ADDRESS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: _clientAddressController,
            decoration: const InputDecoration(
              hintText: 'Enter client address',
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'CLIENT CONTACT',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: _clientContactController,
            decoration: const InputDecoration(
              hintText: 'Enter client contact',
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () => _submitDetails(context),
            child: const Text('Save'),
          ),
          const SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () => _displaySavedData(context),
            child: const Text('Display'),
          ),
          const SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () => _navigateToNext(context),
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }

  void _submitDetails(BuildContext context) async {
    // Getting form data
    String dealer = _dealerController.text;
    String clientName = _clientNameController.text;
    String clientAddress = _clientAddressController.text;
    String clientContact = _clientContactController.text;

    // Prepare data to be inserted
    Map<String, dynamic> customer = {
      'dealer': dealer,
      'clientName': clientName,
      'clientAddress': clientAddress,
      'clientContact': clientContact,
    };

    // Insert data into the database
    int insertedId = await DatabaseHelper().insertCustomer(customer);
    print('Inserted customer with ID: $insertedId');

    // Clear text fields after submission
    _dealerController.clear();
    _clientNameController.clear();
    _clientAddressController.clear();
    _clientContactController.clear();

    // Show a small pop-up message above the app bar to indicate successful submission
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Form data has been saved successfully!'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _displaySavedData(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SavedCustomerPage(),
      ),
    );
  }

  void _navigateToNext(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(),
      ),
    );
  }
}
