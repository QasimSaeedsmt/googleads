import 'package:flutter/material.dart';
import 'package:google_ads_demo/providers/dashboard_provider.dart';
import 'package:google_ads_demo/screens/old_dashboard.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatefulWidget {
  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {

  String _expandedCategory = '';
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);

    final List<_SidebarCategory> _categories = [

      _SidebarCategory(label: 'Overview', icon: Icons.dashboard, children: []),
      _SidebarCategory(
        label: 'Recommendations',
        icon: Icons.lightbulb_outline,
        children: [],
      ),
      _SidebarCategory(
        label: 'Campaigns',
        icon: Icons.flag,
        children: [
          _SidebarChild(label: 'All Campaigns', onTap: () {
            dashboardProvider.showOldDashboard();
          }),
          _SidebarChild(label: 'Paused', onTap: () {}),
          _SidebarChild(label: 'Deleted', onTap: () {}),
        ],
      ),
      _SidebarCategory(
        label: 'Ad groups',
        icon: Icons.view_agenda,
        children: [
          _SidebarChild(label: 'All Ad Groups', onTap: () {
            dashboardProvider.showNewDashboard();

            // DashboardProvider().showNewDashboard();
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OldDashboardScreen()));

          }),
          _SidebarChild(label: 'Paused', onTap: () {}),
          _SidebarChild(label: 'Deleted', onTap: () {}),
        ],
      ),
      _SidebarCategory(
        label: 'Ads & assets',
        icon: Icons.ads_click,
        children: [
          _SidebarChild(label: 'Text Ads', onTap: () {}),
          _SidebarChild(label: 'Responsive Ads', onTap: () {}),
          _SidebarChild(label: 'Image Ads', onTap: () {}),
        ],
      ),
      _SidebarCategory(
        label: 'Keywords',
        icon: Icons.search,
        children: [
          _SidebarChild(label: 'Search Keywords', onTap: () {}),
          _SidebarChild(label: 'Negative Keywords', onTap: () {}),
        ],
      ),
      _SidebarCategory(label: 'Audiences', icon: Icons.people, children: []),
      _SidebarCategory(
        label: 'Demographics',
        icon: Icons.pie_chart,
        children: [
          _SidebarChild(label: 'Age', onTap: () {}),
          _SidebarChild(label: 'Gender', onTap: () {}),
          _SidebarChild(label: 'Parental Status', onTap: () {}),
        ],
      ),
      _SidebarCategory(
        label: 'Reports',
        icon: Icons.bar_chart,
        children: [
          _SidebarChild(label: 'Search Terms', onTap: () {}),
          _SidebarChild(label: 'Landing Pages', onTap: () {}),
          _SidebarChild(label: 'Devices', onTap: () {}),
        ],
      ),
      _SidebarCategory(
        label: 'Performance planner',
        icon: Icons.timeline,
        children: [],
      ),
      _SidebarCategory(
        label: 'Tools & settings',
        icon: Icons.settings,
        children: [
          _SidebarChild(label: 'Conversions', onTap: () {}),
          _SidebarChild(label: 'Measurement', onTap: () {}),
          _SidebarChild(label: 'Setup', onTap: () {}),
        ],
      ),
      _SidebarCategory(label: 'Billing', icon: Icons.payment, children: []),
    ];

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: _isCollapsed ? 70 : 280,
      color: Colors.white,
      padding: EdgeInsets.only(top: 40, bottom: 16),
      child: Column(
        children: [
          // Header and collapse toggle
          Row(
            children: [
              if (!_isCollapsed)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Google Ads',
                    style: TextStyle(
                      color: Color(0xFF202124),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              Spacer(),
              IconButton(
                icon: Icon(
                  _isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                  color: Color(0xFF202124),
                  size: 18,
                ),
                onPressed: () {
                  setState(() {
                    _isCollapsed = !_isCollapsed;
                    _expandedCategory = '';
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 30),
          Expanded(
            child: ListView(
              children:
                  _categories.map((category) {
                    final isExpanded = _expandedCategory == category.label;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: ListTile(
                            leading: Icon(category.icon, color: Color(0xFF202124)),
                            title:
                                _isCollapsed
                                    ? null
                                    : Text(
                                      category.label,
                                      style: TextStyle(
                                        color: Color(0xFF202124),
                                        fontWeight:
                                            isExpanded
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                    ),
                            trailing:
                                !_isCollapsed && category.children.isNotEmpty
                                    ? Icon(
                                      isExpanded
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                      color: Color(0xFF202124),
                                    )
                                    : null,
                            onTap: () {
                              setState(() {
                                if (_isCollapsed) {
                                  _isCollapsed = false;
                                  _expandedCategory = category.label;
                                } else {
                                  _expandedCategory =
                                      isExpanded ? '' : category.label;
                                }
                              });
                            },
                            hoverColor: Colors.white12,
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: _isCollapsed ? 16 : 20,
                              vertical: 4,
                            ),
                          ),
                        ),
                        if (!_isCollapsed &&
                            isExpanded &&
                            category.children.isNotEmpty)
                          ...category.children.map(
                            (sub) => Padding(
                              padding: const EdgeInsets.only(left: 60),
                              child: ListTile(
                                title: Text(
                                  sub.label,
                                  style: TextStyle(color: Color(0xFF202124)),
                                ),
                                onTap: sub.onTap,
                                dense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
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
  final List<_SidebarChild> children;

  _SidebarCategory({
    required this.label,
    required this.icon,
    required this.children,
  });
}

class _SidebarChild {
  final String label;
  final VoidCallback onTap;

  _SidebarChild({required this.label, required this.onTap});
}
