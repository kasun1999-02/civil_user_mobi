import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String? _selectedPaymentMethod;

  // List of existing payment methods
  final List<String> paymentMethods = [
    'Credit Card',
    'Debit Card',
    'PayPal',
    'Google Pay',
    'Apple Pay'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf7f7f7), // Lighter background color
      appBar: AppBar(
        title: const Text("Select Payment Method"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              "Choose your preferred payment method",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 20),

            // List of payment methods with radio buttons
            Expanded(
              child: ListView(
                children: paymentMethods.map((method) {
                  return RadioListTile<String>(
                    title: Text(method, style: TextStyle(fontSize: 18)),
                    value: method,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                    activeColor: Colors.teal,
                  );
                }).toList(),
              ),
            ),

            // Add Payment Method Button
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                onPressed: () async {
                  // Show dialog to add a new payment method
                  String? newPaymentMethod =
                      await _showAddPaymentDialog(context);
                  if (newPaymentMethod != null && newPaymentMethod.isNotEmpty) {
                    setState(() {
                      paymentMethods.add(newPaymentMethod);
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Add Payment Method",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            // Proceed Button
            ElevatedButton(
              onPressed: _selectedPaymentMethod != null
                  ? () {
                      // Handle payment method selection
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Payment Method Selected"),
                          content:
                              Text("You selected: $_selectedPaymentMethod"),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Proceed",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog to add a new payment method
  Future<String?> _showAddPaymentDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    String? newPaymentMethod;

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add New Payment Method"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Enter payment method',
              hintText: 'e.g. MasterCard, Venmo, etc.',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Add"),
              onPressed: () {
                newPaymentMethod = controller.text.trim();
                Navigator.of(context).pop(newPaymentMethod);
              },
            ),
          ],
        );
      },
    );
  }
}
