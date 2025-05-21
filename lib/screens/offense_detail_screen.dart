import 'package:flutter/material.dart';
import '../services/api_services.dart';

class OffenseDetailScreen extends StatefulWidget {
  final Map<String, dynamic> record;

  const OffenseDetailScreen({super.key, required this.record});

  @override
  State<OffenseDetailScreen> createState() => _OffenseDetailScreenState();
}

class _OffenseDetailScreenState extends State<OffenseDetailScreen> {
  Map<String, dynamic>? fineDetails;
  bool isLoading = true;

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchFineDetails();
  }

  Future<void> _fetchFineDetails() async {
    final fineId = widget.record["fineManagementId"];
    print('fine id: $fineId');
    if (fineId != null) {
      final fine = await _apiService.getFineById(fineId);
      setState(() {
        fineDetails = fine;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf7f7f7),
      appBar: AppBar(
        title: const Text("Offense Details"),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Card(
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Offense Information",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Record fields
                        ...widget.record.entries
                            .where((entry) =>
                                entry.key != "_id" &&
                                entry.key != "policeId" &&
                                entry.key != "fineManagementId" &&
                                entry.key != "__v")
                            .map((entry) =>
                                _buildInfoRow(entry.key, entry.value)),

                        const SizedBox(height: 20),

                        // Fine details if available
                        if (fineDetails != null) ...[
                          const Divider(thickness: 1.5),
                          const SizedBox(height: 10),
                          const Text(
                            "Fine Details",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...fineDetails!.entries.map((entry) {
                            return _buildInfoRow(entry.key, entry.value);
                          }),
                        ],

                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 10),
                          ),
                          child: const Text(
                            "Back to List",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildInfoRow(String key, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.teal, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "${_formatKey(key)}: ${value ?? 'N/A'}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatKey(String key) {
    final regex = RegExp(r'(?<=[a-z])[A-Z]');
    return key
        .replaceAllMapped(regex, (match) => ' ${match.group(0)}')
        .capitalize();
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
