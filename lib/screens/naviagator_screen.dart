import 'package:flutter/material.dart';
import 'package:google_ads_demo/providers/dashboard_provider.dart';
import 'package:google_ads_demo/screens/dashboard_screen.dart';
import 'package:google_ads_demo/screens/old_dashboard.dart';
import 'package:google_ads_demo/widgets/sidebar.dart';
import 'package:provider/provider.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({super.key});

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  @override
  Widget build(BuildContext context) {
    final dashboardProvider =  Provider.of<DashboardProvider>(context);
    return Scaffold(
      body: Row(
        children: [
          Sidebar(),
          Expanded(child: dashboardProvider.newDashboardShown?DashboardScreen():OldDashboardScreen())
        ],
      ),
    );
  }
}
