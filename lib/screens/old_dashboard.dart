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
      backgroundColor: Colors.white,
      appBar: GoogleAdsAppBar(isLoading: _isRefreshing, onRefresh: _handleRefresh),
      body: provider.seriesData.isEmpty
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
            SizedBox(
              height: 155,  // fixed height enough to hold MetricCards

              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 800),
                child: Row(
                  key: ValueKey(provider.seriesData),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: MetricCard(
                        changePercentage: "+17",
                        isBackgroundWhite:false,
                        backgroundColor: Color(0xFF3672e8)
                       , selectedMetric: 'Clicks',
                        value: _formatNumber(_getTotal(provider.seriesData, 'Clicks').toDouble()),
                        color: Colors.white70,
                        dropdownItems: ['Clicks', 'Impressions', 'Conversions', 'Cost'],
                        onMetricChanged: (newMetric) {
                          // Update selection
                        },
                      ),
                    ),
                    Expanded(
                      child: MetricCard(
                        changePercentage: "+99",
                        isBackgroundWhite: false,
                        backgroundColor: Color(0xffda2f23),
                        selectedMetric: 'Impressions',
                        value: _formatNumber(_getTotal(provider.seriesData, 'Impressions').toDouble()),
                        color: Colors.white70,
                        dropdownItems: ['Clicks', 'Impressions', 'Conversions', 'Cost'],
                        onMetricChanged: (newMetric) {},
                      ),
                    ),
                    Expanded(
                      child: MetricCard(
                        isBackgroundWhite: true,
                        changePercentage: "-8",

                        backgroundColor: Color(0xfff7ac00),
                        selectedMetric: 'Conversions',
                        value: _formatNumber(_getTotal(provider.seriesData, 'Conversions').toDouble()),
                        color: Colors.black,
                        dropdownItems: ['Clicks', 'Impressions', 'Conversions', 'Cost'],
                        onMetricChanged: (newMetric) {},
                      ),
                    ),
                    Expanded(
                      child: MetricCard(
                        changePercentage: "+81",
                        isBackgroundWhite: true,
                        backgroundColor: Color(0xff1e8e40),
                        selectedMetric: 'Cost',
                        value: "\$ ${_formatNumber(_getTotal(provider.seriesData, 'Cost').toDouble())}",
                        color: Colors.black,
                        dropdownItems: ['Clicks', 'Impressions', 'Conversions', 'Cost'],
                        onMetricChanged: (newMetric) {},
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width*0.20,)
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SfCartesianChart(
                backgroundColor: Colors.white70,
                primaryXAxis: CategoryAxis(
                  labelStyle: TextStyle(color: Color(0xFF121212)),
                  majorGridLines: MajorGridLines(width: 0),
                ),
                primaryYAxis: NumericAxis(
                  labelStyle: TextStyle(color: Color(0xFF121212)),
                  majorGridLines: MajorGridLines(color: Colors.grey[900]!),
                ),
                legend: Legend(
                    isVisible: true,
                    textStyle: TextStyle(color: Color(0xFF121212))),
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
      )
    );
  }
  String _formatNumber(double value) {
    if (value >= 1000) {
      double divided = value / 1000;
      String formatted = divided.toStringAsFixed(3); // e.g., 1.234

      // Remove trailing zeros (e.g., 1.500 → 1.5, 11.000 → 11)
      formatted = formatted.replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');

      return formatted + 'K';
    } else {
      return value.toInt().toString();
    }
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