// ignore: file_names
import 'package:flutter/material.dart';
import 'package:project/customer.dart';
// Import the home screen file

class FirstPage extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const FirstPage({Key? key});

  void _onFabPressed(BuildContext context) {
    // Navigate to the Home screen when FAB is pressed
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const CustomerDetailPage()), // Assuming HomeScreen is the name of your home.dart file's class
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi5Ai Retina Pvt Ltd',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Timesnewroman',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Survey App',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Timesnewroman',
                ),
              ),
            ],
          ),
        ),
        // body: const Center(
        //   child: Text('Press the button below!'),
        // ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _onFabPressed(context),
          backgroundColor: Colors.blue, // Pass the context to _onFabPressed
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
