import 'package:flutter/material.dart';

import '../data/dummy_compaigns.dart';
import '../models/chart_series_entry.dart';

class CampaignProvider extends ChangeNotifier {
  List<ChartSeriesEntry> _seriesData = [];

  List<ChartSeriesEntry> get seriesData => _seriesData;

  void loadDummyData() {
    _seriesData = List.from(dummyCampaigns);
    notifyListeners();
  }
}
