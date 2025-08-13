import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final String selectedMetric; // e.g. "Clicks"
  final String value; // e.g. "1.2K"
  final String? changePercentage; // e.g. "+12.4%" or "-8.3%"
  final Color color;
  final bool isBackgroundWhite;
  final Color backgroundColor;
  final List<String> dropdownItems;
  final ValueChanged<String?>? onMetricChanged;

  const MetricCard({
    Key? key,
    required this.selectedMetric,
    required this.value,
    required this.isBackgroundWhite,
    required this.backgroundColor,
    required this.color,
    required this.dropdownItems,
    this.onMetricChanged,
    this.changePercentage, // Optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine if it's a positive or negative change
    final bool isNegative = changePercentage != null && changePercentage!.startsWith('-');
    final bool isPositive = changePercentage != null && changePercentage!.startsWith('+');

    return Card(
      color: backgroundColor,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top-left dropdown
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 120,
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedMetric,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: isBackgroundWhite ? const Color(0xFF2C2C2C) : Colors.white,
                  ),
                  dropdownColor: Colors.white,
                  underline: const SizedBox(),
                  style: const TextStyle(
                    color: Color(0xFF2C2C2C),
                    fontSize: 14,
                  ),
                  onChanged: onMetricChanged,
                  items: dropdownItems
                      .map(
                        (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ),
                  )
                      .toList(),
                ),
              ),
            ),

            const Spacer(),

            // Main value (e.g. 1.2K)
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),

            // Percentage change (if available)
            if (changePercentage != null) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    isNegative ? Icons.arrow_downward : Icons.arrow_upward,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    changePercentage!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
