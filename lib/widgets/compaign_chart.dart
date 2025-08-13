// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../providers/compaign_provider.dart';
// class CampaignChart extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final campaigns = Provider.of<CampaignProvider>(context).campaigns;
//
//     return BarChart(
//       BarChartData(
//         maxY: campaigns.map((c) => c.clicks.toDouble()).reduce((a, b) => a > b ? a : b) + 100,
//         barGroups: campaigns.asMap().entries.map((entry) {
//           int index = entry.key;
//           var campaign = entry.value;
//           return BarChartGroupData(
//             x: index,
//             barRods: [
//               BarChartRodData(  color: Colors.blueAccent, toY: campaign.clicks.toDouble(),),
//             ],
//             showingTooltipIndicators: [0],
//           );
//         }).toList(),
//         titlesData: FlTitlesData(
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (value, meta) {
//                 if (value.toInt() >= campaigns.length) return Text('');
//                 return Text(
//                   campaigns[value.toInt()].name,
//                   style: TextStyle(fontSize: 10),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
