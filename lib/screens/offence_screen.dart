import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'offense_detail_screen.dart';
import '../services/api_services.dart';

class OffenseListScreen extends StatefulWidget {
  const OffenseListScreen({super.key});

  @override
  State<OffenseListScreen> createState() => _OffenseListScreenState();
}

class _OffenseListScreenState extends State<OffenseListScreen> {
  late Future<List<Map<String, dynamic>>?> _finesFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _finesFuture = _loadFines();
  }

  Future<List<Map<String, dynamic>>?> _loadFines() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');

    if (userDataString == null) {
      // No user data stored
      return null;
    }

    final Map<String, dynamic> userData = jsonDecode(userDataString);
    final String? nic = userData['nicNo'];
    //print(nic);

    if (nic == null || nic.isEmpty) {
      return null;
    }

    // Fetch fines by NIC from API
    final List<Map<String, dynamic>>? a = await _apiService.getFinesByNIC(nic);
    print('User Data: $a');
    return a;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFebcec7),
      appBar: AppBar(
        title: const Text("Offense List"),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: _finesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading indicator
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show error message
            return Center(
                child: Text('Error loading offenses: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            // No offenses found
            return const Center(child: Text('No offenses found.'));
          }

          final offenseRecords = snapshot.data!;

          final Map<String, int> statePriority = {
            "New": 0,
            "Pending": 1,
            "Settled": 2,
          };

          offenseRecords.sort((a, b) {
            final aPriority = statePriority[a["State"]] ?? 99;
            final bPriority = statePriority[b["State"]] ?? 99;
            if (aPriority != bPriority) return aPriority.compareTo(bPriority);

            final aDate = DateTime.tryParse(a["Date"] ?? "") ?? DateTime(1970);
            final bDate = DateTime.tryParse(b["Date"] ?? "") ?? DateTime(1970);
            return bDate.compareTo(aDate);
          });

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: offenseRecords.length,
            itemBuilder: (context, index) {
              final record = offenseRecords[index];

              Color tagColor;
              switch (record["State"]) {
                case "Pending":
                  tagColor = Colors.red.shade400;
                  break;
                case "New":
                  tagColor = Colors.amber.shade600;
                  break;
                case "Settled":
                  tagColor = Colors.green.shade600;
                  break;
                default:
                  tagColor = Colors.grey.shade400;
              }

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    "NIC: ${record["civilNIC"] ?? 'N/A'}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Date: ${record["Date"] ?? 'N/A'}\nOffense: ${record["Offense"] ?? 'N/A'}",
                    style: const TextStyle(height: 1.4),
                  ),
                  trailing: Chip(
                    label: Text(
                      record["type"] ?? "",
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: tagColor,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OffenseDetailScreen(record: record),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
