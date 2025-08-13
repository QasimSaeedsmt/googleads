import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/chart_series_entry.dart';
import '../providers/compaign_provider.dart';
import '../widgets/google_ads_apbar.dart';
import '../widgets/matric_card.dart';
import '../widgets/sidebar.dart';
import 'dart:async';

class OldDashboardScreen extends StatefulWidget {
  @override
  State<OldDashboardScreen> createState() => _OldDashboardScreenState();
}

class _OldDashboardScreenState extends State<OldDashboardScreen> {
  bool _isRefreshing = false;

  void _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(Duration(seconds: 2));
    Provider.of<CampaignProvider>(context, listen: false).loadDummyData();
    setState(() => _isRefreshing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("All campaigns refreshed"), duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CampaignProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: GoogleAdsAppBar(isLoading: _isRefreshing, onRefresh: _handleRefresh),
      body: Expanded(
        child: provider.seriesData.isEmpty
            ? Center(
          child: Text('No data. Tap refresh.',
              style: TextStyle(color: Colors.white70, fontSize: 18)),
        )
            : Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Metric Cards with subtle animation on refresh
              AnimatedSwitcher(
                duration: Duration(milliseconds: 800),
                child: Row(
                  key: ValueKey(provider.seriesData),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MetricCard(
                        label: 'Clicks',
                        value: _getTotal(provider.seriesData, 'Clicks')
                            .toInt()
                            .toString(),
                        color: Colors.blueAccent),
                    MetricCard(
                        label: 'Impressions',
                        value: _getTotal(provider.seriesData, 'Impressions')
                            .toInt()
                            .toString(),
                        color: Colors.greenAccent),
                    MetricCard(
                        label: 'Conversions',
                        value: _getTotal(provider.seriesData, 'Conversions')
                            .toInt()
                            .toString(),
                        color: Colors.orangeAccent),
                    MetricCard(
                        label: 'Cost',
                        value:
                        '\$${_getTotal(provider.seriesData, 'Cost').toStringAsFixed(2)}',
                        color: Colors.redAccent),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: SfCartesianChart(
                  backgroundColor: Color(0xFF121212),
                  primaryXAxis: CategoryAxis(
                    labelStyle: TextStyle(color: Colors.white70),
                    majorGridLines: MajorGridLines(width: 0),
                  ),
                  primaryYAxis: NumericAxis(
                    labelStyle: TextStyle(color: Colors.white70),
                    majorGridLines: MajorGridLines(color: Colors.grey[800]!),
                  ),
                  legend: Legend(
                      isVisible: true,
                      textStyle: TextStyle(color: Colors.white70)),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <LineSeries<ChartSeriesEntry, String>>[
                    LineSeries<ChartSeriesEntry, String>(
                      name: 'Clicks',
                      dataSource: provider.seriesData,
                      xValueMapper: (d, _) => d.date,
                      yValueMapper: (d, _) => d.clicks,
                      color: Colors.blueAccent,
                      width: 2,
                    ),
                    LineSeries<ChartSeriesEntry, String>(
                      name: 'Impressions',
                      dataSource: provider.seriesData,
                      xValueMapper: (d, _) => d.date,
                      yValueMapper: (d, _) => d.impressions,
                      color: Colors.greenAccent,
                      width: 2,
                    ),
                    LineSeries<ChartSeriesEntry, String>(
                      name: 'Conversions',
                      dataSource: provider.seriesData,
                      xValueMapper: (d, _) => d.date,
                      yValueMapper: (d, _) => d.conversions,
                      color: Colors.orangeAccent,
                      width: 2,
                    ),
                    LineSeries<ChartSeriesEntry, String>(
                      name: 'Cost',
                      dataSource: provider.seriesData,
                      xValueMapper: (d, _) => d.date,
                      yValueMapper: (d, _) => d.cost,
                      color: Colors.redAccent,
                      width: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  double _getTotal(List<ChartSeriesEntry> data, String label) {
    switch (label) {
      case 'Clicks':
        return data.fold(0.0, (sum, d) => sum + d.clicks);
      case 'Impressions':
        return data.fold(0.0, (sum, d) => sum + d.impressions);
      case 'Conversions':
        return data.fold(0.0, (sum, d) => sum + d.conversions);
      case 'Cost':
        return data.fold(0.0, (sum, d) => sum + d.cost);
      default:
        return 0.0;
    }
  }
}