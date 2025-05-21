import 'package:flutter/material.dart';

class ePenaltyPayScreen extends StatefulWidget {
  const ePenaltyPayScreen({super.key});

  @override
  State<ePenaltyPayScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<ePenaltyPayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFebcec7),
      appBar: AppBar(
        title: const Text("ePenaltyPay"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2, // Two columns
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          padding: const EdgeInsets.all(20),
          children: [
            _buildGridItem("Offense", Icons.warning, () {
              Navigator.pushNamed(context, '/offense');
            }),
            _buildGridItem("Profile", Icons.person, () {
              Navigator.pushNamed(context, '/profile');
            }),
            _buildGridItem("Payment Method", Icons.payment, () {
              Navigator.pushNamed(context, '/payment');
            }),
            _buildGridItem("Emergency", Icons.phone, () {
              Navigator.pushNamed(context, '/emergency');
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.blue),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
