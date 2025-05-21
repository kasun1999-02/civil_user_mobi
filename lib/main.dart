import 'screens/emergency.dart';
import 'screens/offence_screen.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/profile.dart';
import 'screens/register_screen.dart';
import 'screens/ePenaltyPay_screen.dart';
import 'screens/payment_method.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ePenaltyPay',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/ePenaltyPay': (context) => const ePenaltyPayScreen(),
        '/offense': (context) => const OffenseListScreen(),
        '/payment': (context) => const PaymentMethodScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/emergency': (context) => const EmergencyPage(),
      },
    );
  }
}
