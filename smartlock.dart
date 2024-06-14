import 'package:flutter/material.dart';

class SmartLock extends StatefulWidget {
  final String smartLockNumber;

  const SmartLock({Key? key, required this.smartLockNumber}) : super(key: key);

  @override
  _SmartLockState createState() => _SmartLockState();
}

class _SmartLockState extends State<SmartLock> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Smart Lock ${widget.smartLockNumber}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Door Type: Wooden',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Fingerprint: Enabled',
            style: TextStyle(fontSize: 16),
          ),
          // Add more information here for other smart lock features
        ],
      ),
    );
  }
}
