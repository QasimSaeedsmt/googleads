import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/compaign.dart';
import '../providers/compaign_provider.dart';

class AddCampaignScreen extends StatefulWidget {
  @override
  _AddCampaignScreenState createState() => _AddCampaignScreenState();
}

class _AddCampaignScreenState extends State<AddCampaignScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  int clicks = 0, impressions = 0, conversions = 0;
  double cost = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Campaign')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(decoration: InputDecoration(labelText: 'Campaign Name'), onSaved: (v) => name = v ?? ''),
            TextFormField(decoration: InputDecoration(labelText: 'Clicks'), keyboardType: TextInputType.number, onSaved: (v) => clicks = int.tryParse(v ?? '0') ?? 0),
            TextFormField(decoration: InputDecoration(labelText: 'Impressions'), keyboardType: TextInputType.number, onSaved: (v) => impressions = int.tryParse(v ?? '0') ?? 0),
            TextFormField(decoration: InputDecoration(labelText: 'Conversions'), keyboardType: TextInputType.number, onSaved: (v) => conversions = int.tryParse(v ?? '0') ?? 0),
            TextFormField(decoration: InputDecoration(labelText: 'Cost'), keyboardType: TextInputType.number, onSaved: (v) => cost = double.tryParse(v ?? '0') ?? 0.0),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _formKey.currentState!.save();
                final newCampaign = Campaign(
                  name: name,
                  clicks: clicks,
                  impressions: impressions,
                  conversions: conversions,
                  cost: cost,
                );
                // Provider.of<CampaignProvider>(context, listen: false).addCampaign(newCampaign);
                Navigator.pop(context);
              },
              child: Text('Save Campaign'),
            )
          ]),
        ),
      ),
    );
  }
}
