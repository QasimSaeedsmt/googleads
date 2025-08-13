import 'package:flutter/material.dart';
import 'package:google_ads_demo/widgets/sidebar.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// ----------- Models -----------
enum CampaignStatus { active, paused, removed }

class Campaign {
  final String name;
  final CampaignStatus status;
  final double budget; // daily budget in $
  final int clicks;
  final int impressions;
  final double avgCpc;
  final int conversions;
  final double cost;
  final String device;
  final String location;
  final List<ChartEntry> trendData;

  Campaign({
    required this.name,
    required this.status,
    required this.budget,
    required this.clicks,
    required this.impressions,
    required this.avgCpc,
    required this.conversions,
    required this.cost,
    required this.device,
    required this.location,
    required this.trendData,
  });

  double get ctr => impressions == 0 ? 0 : clicks / impressions * 100;
}

class ChartEntry {
  final DateTime date;
  final int clicks;
  final int impressions;
  final int conversions;
  final double cost;

  ChartEntry({
    required this.date,
    required this.clicks,
    required this.impressions,
    required this.conversions,
    required this.cost,
  });
}

// ----------- Dashboard Screen -----------
class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Campaign> _campaigns = [];
  DateTimeRange? _selectedDateRange;
  String _selectedDeviceFilter = 'All';
  String _selectedLocationFilter = 'All';
  bool _isRefreshing = false;

  final List<String> devices = ['All', 'Mobile', 'Desktop', 'Tablet'];
  final List<String> locations = ['All', 'USA', 'Canada', 'UK', 'Germany'];

  @override
  void initState() {
    super.initState();
    _generateDummyCampaigns();
    _selectedDateRange = DateTimeRange(
      start: DateTime.now().subtract(Duration(days: 30)),
      end: DateTime.now(),
    );
  }

  void _generateDummyCampaigns() {
    List<DateTime> dates = List.generate(30, (i) => DateTime.now().subtract(Duration(days: 29 - i)));

    List<Campaign> dummyCampaigns = [
      Campaign(
        name: 'Holiday Sale',
        status: CampaignStatus.active,
        budget: 150.0,
        clicks: 1250,
        impressions: 25000,
        avgCpc: 0.75,
        conversions: 130,
        cost: 937.5,
        device: 'Mobile',
        location: 'USA',
        trendData: dates.map((date) {
          return ChartEntry(
            date: date,
            clicks: (20 + (10 * (date.day % 5))).toInt(),
            impressions: 800 + (40 * (date.day % 5)),
            conversions: (date.day % 5) * 2,
            cost: (15.0 + (5 * (date.day % 4))),
          );
        }).toList(),
      ),
      Campaign(
        name: 'Brand Awareness',
        status: CampaignStatus.paused,
        budget: 100.0,
        clicks: 900,
        impressions: 20000,
        avgCpc: 0.65,
        conversions: 80,
        cost: 585,
        device: 'Desktop',
        location: 'Canada',
        trendData: dates.map((date) {
          return ChartEntry(
            date: date,
            clicks: (15 + (5 * (date.day % 6))).toInt(),
            impressions: 600 + (30 * (date.day % 6)),
            conversions: (date.day % 4),
            cost: (10.0 + (4 * (date.day % 3))),
          );
        }).toList(),
      ),
      Campaign(
        name: 'Remarketing Campaign',
        status: CampaignStatus.active,
        budget: 120.0,
        clicks: 1100,
        impressions: 21000,
        avgCpc: 0.70,
        conversions: 120,
        cost: 770,
        device: 'Tablet',
        location: 'UK',
        trendData: dates.map((date) {
          return ChartEntry(
            date: date,
            clicks: (18 + (6 * (date.day % 4))).toInt(),
            impressions: 700 + (35 * (date.day % 4)),
            conversions: (date.day % 3) + 1,
            cost: (12.0 + (3 * (date.day % 2))),
          );
        }).toList(),
      ),
    ];

    setState(() {
      _campaigns = dummyCampaigns;
    });
  }

  Future<void> _refreshData() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(Duration(seconds: 2));
    _generateDummyCampaigns(); // regenerate dummy data
    setState(() => _isRefreshing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Campaign data refreshed')),
    );
  }

  List<Campaign> get _filteredCampaigns {
    var filtered = _campaigns.where((c) {
      if (_selectedDeviceFilter != 'All' && c.device != _selectedDeviceFilter) return false;
      if (_selectedLocationFilter != 'All' && c.location != _selectedLocationFilter) return false;
      return true;
    }).toList();
    return filtered;
  }

  int get totalClicks => _filteredCampaigns.fold(0, (sum, c) => sum + c.clicks);
  int get totalImpressions => _filteredCampaigns.fold(0, (sum, c) => sum + c.impressions);
  int get totalConversions => _filteredCampaigns.fold(0, (sum, c) => sum + c.conversions);
  double get totalCost => _filteredCampaigns.fold(0, (sum, c) => sum + c.cost);
  double get totalBudget => _filteredCampaigns.fold(0, (sum, c) => sum + c.budget);

  List<ChartEntry> get mergedTrendData {
    if (_filteredCampaigns.isEmpty) return [];

    Map<DateTime, ChartEntry> mergedMap = {};
    for (var campaign in _filteredCampaigns) {
      for (var entry in campaign.trendData) {
        var key = DateTime(entry.date.year, entry.date.month, entry.date.day);
        if (!mergedMap.containsKey(key)) {
          mergedMap[key] = ChartEntry(date: key, clicks: 0, impressions: 0, conversions: 0, cost: 0);
        }
        mergedMap[key] = ChartEntry(
          date: key,
          clicks: mergedMap[key]!.clicks + entry.clicks,
          impressions: mergedMap[key]!.impressions + entry.impressions,
          conversions: mergedMap[key]!.conversions + entry.conversions,
          cost: mergedMap[key]!.cost + entry.cost,
        );
      }
    }
    var list = mergedMap.values.toList();
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  void _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              surface: Color(0xFF121212),
              onSurface: Colors.white70,
            ),
            dialogBackgroundColor: Color(0xFF202124),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  Widget _buildDateRangeSelector() {
    final format = DateFormat('MMM d, yyyy');
    String label;
    if (_selectedDateRange == null) {
      label = 'Select date range';
    } else {
      label = '${format.format(_selectedDateRange!.start)} - ${format.format(_selectedDateRange!.end)}';
    }

    return OutlinedButton.icon(
      onPressed: _pickDateRange,
      icon: Icon(Icons.calendar_today, color: Colors.blueAccent),
      label: Text(label, style: TextStyle(color: Colors.white70)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.blueAccent),
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        DropdownButton<String>(
          dropdownColor: Color(0xFF202124),
          value: _selectedDeviceFilter,
          items: devices
              .map((d) => DropdownMenuItem(
            child: Text(d, style: TextStyle(color: Colors.white70)),
            value: d,
          ))
              .toList(),
          onChanged: (v) => setState(() => _selectedDeviceFilter = v ?? 'All'),
          underline: SizedBox(),
        ),
        SizedBox(width: 12),
        DropdownButton<String>(
          dropdownColor: Color(0xFF202124),
          value: _selectedLocationFilter,
          items: locations
              .map((l) => DropdownMenuItem(
            child: Text(l, style: TextStyle(color: Colors.white70)),
            value: l,
          ))
              .toList(),
          onChanged: (v) => setState(() => _selectedLocationFilter = v ?? 'All'),
          underline: SizedBox(),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(8),
      ),
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white70)),
          SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCampaignsTable() {
    return DataTable(
      headingRowColor: MaterialStateProperty.all(Color(0xFF1E1E1E)),
      dataRowColor: MaterialStateProperty.all(Color(0xFF2A2A2A)),
      headingTextStyle: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
      dataTextStyle: TextStyle(color: Colors.white70),
      columns: [
        DataColumn(label: Text('Campaign')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Budget')),
        DataColumn(label: Text('Clicks')),
        DataColumn(label: Text('Impr.')),
        DataColumn(label: Text('CTR %')),
        DataColumn(label: Text('Avg. CPC')),
        DataColumn(label: Text('Conv.')),
        DataColumn(label: Text('Cost')),
      ],
      rows: _filteredCampaigns.map((c) {
        return DataRow(
          cells: [
            DataCell(Text(c.name)),
            DataCell(Text(
              c.status.toString().split('.').last.toUpperCase(),
              style: TextStyle(
                color: c.status == CampaignStatus.active
                    ? Colors.greenAccent
                    : (c.status == CampaignStatus.paused ? Colors.orangeAccent : Colors.redAccent),
              ),
            )),
            DataCell(Text('\$${c.budget.toStringAsFixed(2)}')),
            DataCell(Text('${c.clicks}')),
            DataCell(Text('${c.impressions}')),
            DataCell(Text('${c.ctr.toStringAsFixed(2)}%')),
            DataCell(Text('\$${c.avgCpc.toStringAsFixed(2)}')),
            DataCell(Text('${c.conversions}')),
            DataCell(Text('\$${c.cost.toStringAsFixed(2)}')),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildBudgetProgress() {
    final spendPercent = (totalCost / totalBudget).clamp(0, 1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Budget Spend Progress', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
        SizedBox(height: 6),
        LinearProgressIndicator(
          value: spendPercent.toDouble(),
          backgroundColor: Colors.white12,
          color: spendPercent < 0.7
              ? Colors.greenAccent
              : (spendPercent < 0.9 ? Colors.orangeAccent : Colors.redAccent),
          minHeight: 10,
        ),
        SizedBox(height: 4),
        Text(
          '\$${totalCost.toStringAsFixed(2)} spent of \$${totalBudget.toStringAsFixed(2)} budget',
          style: TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildRecommendations() {
    // Simple static recommendations placeholder
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recommendations', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Your "Holiday Sale" campaign budget is running low. Consider increasing it to maximize reach.',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.thumb_up_alt_rounded, color: Colors.greenAccent),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'The "Remarketing Campaign" is performing well with a high conversion rate.',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    return SfCartesianChart(
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
      series: <LineSeries<ChartEntry, String>>[
        LineSeries<ChartEntry, String>(
          name: 'Clicks',
          dataSource: mergedTrendData,
          xValueMapper: (d, _) => DateFormat.Md().format(d.date),
          yValueMapper: (d, _) => d.clicks,
          color: Colors.blueAccent,
          width: 2,
        ),
        LineSeries<ChartEntry, String>(
          name: 'Impressions',
          dataSource: mergedTrendData,
          xValueMapper: (d, _) => DateFormat.Md().format(d.date),
          yValueMapper: (d, _) => d.impressions,
          color: Colors.greenAccent,
          width: 2,
        ),
        LineSeries<ChartEntry, String>(
          name: 'Conversions',
          dataSource: mergedTrendData,
          xValueMapper: (d, _) => DateFormat.Md().format(d.date),
          yValueMapper: (d, _) => d.conversions,
          color: Colors.orangeAccent,
          width: 2,
        ),
        LineSeries<ChartEntry, String>(
          name: 'Cost',
          dataSource: mergedTrendData,
          xValueMapper: (d, _) => DateFormat.Md().format(d.date),
          yValueMapper: (d, _) => d.cost.toInt(),
          color: Colors.redAccent,
          width: 2,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Ads Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1A1A1A),
        actions: [
          IconButton(
            icon: _isRefreshing
                ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
                : Icon(Icons.refresh, color: Colors.white),
            onPressed: _isRefreshing ? null : _refreshData,
            tooltip: 'Refresh data',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Filters + Date Range
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDateRangeSelector(),
                _buildFilters(),
              ],
            ),
            SizedBox(height: 16),

            // Metric Cards
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildMetricCard('Clicks', totalClicks.toString(), Colors.blueAccent),
                  SizedBox(width: 12),
                  _buildMetricCard('Impressions', totalImpressions.toString(), Colors.greenAccent),
                  SizedBox(width: 12),
                  _buildMetricCard('Conversions', totalConversions.toString(), Colors.orangeAccent),
                  SizedBox(width: 12),
                  _buildMetricCard('Cost', '\$${totalCost.toStringAsFixed(2)}', Colors.redAccent),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Line Chart (expanded)
            Expanded(
              flex: 3,
              child: _filteredCampaigns.isEmpty
                  ? Center(child: Text('No data for selected filters', style: TextStyle(color: Colors.white70)))
                  : _buildLineChart(),
            ),

            SizedBox(height: 20),

            // Budget progress + Recommendations
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Budget progress bar (left)
                Expanded(
                  flex: 1,
                  child: _buildBudgetProgress(),
                ),
                SizedBox(width: 24),

                // Recommendations (right)
                Expanded(
                  flex: 2,
                  child: _buildRecommendations(),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Campaigns Table
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildCampaignsTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
