import 'package:flutter/material.dart';
import 'package:google_ads_demo/providers/compaign_provider.dart';
import 'package:provider/provider.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) {
        final provider = CampaignProvider();
        provider.loadDummyData();
        return provider;
      },
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Google Ads Dashboard (Dummy)',
    theme: ThemeData.dark(),
    home: DashboardScreen(),
    debugShowCheckedModeBanner: false,
  );
}
