import 'package:flutter/material.dart';

class GoogleAdsAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isLoading;
  final VoidCallback onRefresh;

  GoogleAdsAppBar({required this.isLoading, required this.onRefresh});

  @override
  _GoogleAdsAppBarState createState() => _GoogleAdsAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (isLoading ? 4 : 0));
}

class _GoogleAdsAppBarState extends State<GoogleAdsAppBar> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late FocusNode _searchFocus;
  final TextEditingController _searchController = TextEditingController();
  OverlayEntry? _overlayEntry;

  final List<String> _dummySearchHistory = [
    'Campaign Q2 Report',
    'Holiday Sale',
    'Brand Awareness',
    'Remarketing Campaign',
    'Black Friday Deals',
    'Spring Promo',
  ];

  List<String> _filteredSuggestions = [];

  final LayerLink _layerLink = LayerLink();

  bool _profileMenuOpen = false;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    if (widget.isLoading) {
      _rotationController.repeat();
    }

    _searchFocus = FocusNode();
    _searchFocus.addListener(() {
      if (_searchFocus.hasFocus) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
      setState(() {}); // To update colors on focus change
    });

    _searchController.addListener(() {
      _updateSuggestions();
    });
  }

  void _updateSuggestions() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSuggestions = _dummySearchHistory
          .where((element) => element.toLowerCase().contains(query))
          .toList();
    });
    if (_searchFocus.hasFocus) {
      _showOverlay();
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
    }
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: 280,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 6),
          child: Material(
            elevation: 4,
            color: Color(0xFF121212),
            borderRadius: BorderRadius.circular(6),
            child: _filteredSuggestions.isEmpty
                ? Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'No recent searches',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: _filteredSuggestions.length,
              itemBuilder: (context, index) {
                final suggestion = _filteredSuggestions[index];
                return InkWell(
                  onTap: () {
                    _searchController.text = suggestion;
                    _searchController.selection = TextSelection.fromPosition(
                      TextPosition(offset: suggestion.length),
                    );
                    _removeOverlay();
                    _searchFocus.unfocus();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Text(
                      suggestion,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _toggleProfileMenu() {
    setState(() {
      _profileMenuOpen = !_profileMenuOpen;
    });
  }

  void _closeProfileMenu() {
    setState(() {
      _profileMenuOpen = false;
    });
  }

  @override
  void didUpdateWidget(covariant GoogleAdsAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !_rotationController.isAnimating) {
      _rotationController.repeat();
    } else if (!widget.isLoading && _rotationController.isAnimating) {
      _rotationController.stop();
      _rotationController.reset();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _searchFocus.dispose();
    _searchController.dispose();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2A2B2F), Color(0xFF202124)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                offset: Offset(0, 1),
                blurRadius: 3,
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none, // Allow overflow
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                titleSpacing: 24,
                title: Text(
                  'Overview',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(0, 1),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                ),
                actions: [
                  Tooltip(
                    message: widget.isLoading ? 'Refreshing...' : 'Refresh',
                    child: InkResponse(
                      radius: 28,
                      splashColor: Colors.blueAccent.withOpacity(0.3),
                      highlightColor: Colors.blueAccent.withOpacity(0.1),
                      onTap: widget.isLoading ? null : widget.onRefresh,
                      child: RotationTransition(
                        turns: CurvedAnimation(
                          parent: _rotationController,
                          curve: Curves.easeInOut,
                        ),
                        child: Icon(Icons.refresh, color: Colors.white70),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  CompositedTransformTarget(
                    link: _layerLink,
                    child: Container(
                      width: 280,
                      height: 40,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocus,
                        cursorColor: Colors.white70,
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Search campaigns',
                          hintStyle: TextStyle(
                            color: _searchFocus.hasFocus ? Colors.white38 : Colors.white24,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: _searchFocus.hasFocus ? Colors.white38 : Colors.white24,
                          ),
                          filled: true,
                          fillColor: Color(0xFF121212),
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Profile avatar with dropdown menu
                  GestureDetector(
                    onTap: _toggleProfileMenu,
                    child: Tooltip(
                      message: 'User Account',
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          'U',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              ),
              // Profile dropdown menu positioned outside AppBar but inside Stack
              if (_profileMenuOpen)
                Positioned(
                  right: 20,
                  top: kToolbarHeight + 8,
                  child: Material(
                    color: Color(0xFF202124),
                    elevation: 5,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 220,
                      padding: EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User Name',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'user@example.com',
                            style: TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                          Divider(color: Colors.white12, height: 20),
                          InkWell(
                            onTap: () {
                              // Dummy sign out action
                              _closeProfileMenu();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Signed out')),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'Sign out',
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (widget.isLoading)
          LinearProgressIndicator(
            backgroundColor: Colors.transparent,
            color: Colors.blueAccent,
            minHeight: 3,
          ),
      ],
    );
  }
}
