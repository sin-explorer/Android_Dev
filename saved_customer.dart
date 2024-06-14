import 'package:flutter/material.dart';
import 'package:project/database_helper_customer.dart';

class SavedCustomerPage extends StatefulWidget {
  @override
  _SavedCustomerPageState createState() => _SavedCustomerPageState();
}

class _SavedCustomerPageState extends State<SavedCustomerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Customer Data'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: DatabaseHelper().getAllCustomers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var customer = snapshot.data![index];
                      return ListTile(
                        title: Text(customer['dealer']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name: ${customer['clientName']}'),
                            Text('Address: ${customer['clientAddress']}'),
                            Text('Contact: ${customer['clientContact']}'),
                          ],
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                return const Center(
                  child: Text('No saved data.'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _clearData(context),
              child: const Text('Clear All Data'),
            ),
          ),
        ],
      ),
    );
  }

  void _clearData(BuildContext context) async {
    await DatabaseHelper().clearAllCustomers();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All saved data cleared.'),
      ),
    );
    // Update the UI to show an empty list
    setState(() {});
  }
}
