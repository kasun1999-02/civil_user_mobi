import 'package:flutter/material.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  // Function to make a phone call
  void _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("Could not launch $phoneNumber");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Contacts"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emergency Title
            Text(
              "In case of emergency, contact:",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 20),

            // Emergency Contacts List
            _buildEmergencyContact("Police", "911"),
            _buildEmergencyContact("Fire Department", "101"),
            _buildEmergencyContact("Ambulance", "102"),
            _buildEmergencyContact("Family Contact", "+1234567890"),

            const SizedBox(height: 30),

            // SOS Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Add SOS alert functionality here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("SOS Alert Sent!")),
                  );
                },
                icon: Icon(Icons.warning, color: Colors.white),
                label: Text("Send SOS Alert"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to create emergency contact list
  Widget _buildEmergencyContact(String name, String phoneNumber) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(Icons.phone, color: Colors.red),
        title: Text(name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(phoneNumber, style: TextStyle(fontSize: 16)),
        trailing: IconButton(
          icon: Icon(Icons.call, color: Colors.green),
          onPressed: () => _makePhoneCall(phoneNumber),
        ),
      ),
    );
  }
}

launchUrl(Uri url) {}

canLaunchUrl(Uri url) {}
