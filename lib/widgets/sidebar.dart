import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget {
  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String _expandedCategory = '';

  final List<_SidebarCategory> _categories = [
    _SidebarCategory(
      label: 'Overview',
      icon: Icons.dashboard,
      children: [],
    ),
    _SidebarCategory(
      label: 'Recommendations',
      icon: Icons.lightbulb_outline,
      children: [],
    ),
    _SidebarCategory(
      label: 'Campaigns',
      icon: Icons.flag,
      children: ['All Campaigns', 'Paused', 'Deleted'],
    ),
    _SidebarCategory(
      label: 'Ad groups',
      icon: Icons.view_agenda,
      children: ['All Ad Groups', 'Paused', 'Deleted'],
    ),
    _SidebarCategory(
      label: 'Ads & assets',
      icon: Icons.ads_click,
      children: ['Text Ads', 'Responsive Ads', 'Image Ads'],
    ),
    _SidebarCategory(
      label: 'Keywords',
      icon: Icons.search,
      children: ['Search Keywords', 'Negative Keywords'],
    ),
    _SidebarCategory(
      label: 'Audiences',
      icon: Icons.people,
      children: [],
    ),
    _SidebarCategory(
      label: 'Demographics',
      icon: Icons.pie_chart,
      children: ['Age', 'Gender', 'Parental Status'],
    ),
    _SidebarCategory(
      label: 'Reports',
      icon: Icons.bar_chart,
      children: ['Search Terms', 'Landing Pages', 'Devices'],
    ),
    _SidebarCategory(
      label: 'Performance planner',
      icon: Icons.timeline,
      children: [],
    ),
    _SidebarCategory(
      label: 'Tools & settings',
      icon: Icons.settings,
      children: ['Conversions', 'Measurement', 'Setup'],
    ),
    _SidebarCategory(
      label: 'Billing',
      icon: Icons.payment,
      children: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: Color(0xFF202124),
      padding: EdgeInsets.only(top: 40, bottom: 16),
      child: Column(
        children: [
          Text(
            'Google Ads',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: ListView(
              children: _categories.map((category) {
                final isExpanded = _expandedCategory == category.label;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: ListTile(
                        leading: Icon(category.icon, color: Colors.white70),
                        title: Text(category.label,
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight:
                                isExpanded ? FontWeight.bold : FontWeight.normal)),
                        trailing: category.children.isNotEmpty
                            ? Icon(
                          isExpanded
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: Colors.white70,
                        )
                            : null,
                        onTap: () {
                          setState(() {
                            if (isExpanded) {
                              _expandedCategory = '';
                            } else {
                              _expandedCategory = category.label;
                            }
                          });
                        },
                        hoverColor: Colors.white12,
                        dense: true,
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      ),
                    ),
                    if (isExpanded && category.children.isNotEmpty)
                      ...category.children.map(
                            (sub) => Padding(
                          padding: const EdgeInsets.only(left: 60),
                          child: ListTile(
                            title: Text(sub, style: TextStyle(color: Colors.white60)),
                            onTap: () {
                              // Add navigation or actions here
                            },
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 2),
                            hoverColor: Colors.white12,
                          ),
                        ),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarCategory {
  final String label;
  final IconData icon;
  final List<String> children;

  _SidebarCategory(
      {required this.label, required this.icon, required this.children});
}
