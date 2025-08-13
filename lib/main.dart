import 'package:flutter/material.dart';
import 'package:google_ads_demo/providers/compaign_provider.dart';
import 'package:google_ads_demo/providers/dashboard_provider.dart';
import 'package:google_ads_demo/screens/naviagator_screen.dart';
import 'package:google_ads_demo/screens/old_dashboard.dart';
import 'package:provider/provider.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) {
          final provider = CampaignProvider();
          provider.loadDummyData();
          return provider;
        },
      ),
ChangeNotifierProvider(create: (context) => DashboardProvider(),)
    ],        child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Google Ads Dashboard (Dummy)',
    theme: ThemeData.dark(),
    home: NavigatorScreen(),
    debugShowCheckedModeBanner: false,
  );
}
