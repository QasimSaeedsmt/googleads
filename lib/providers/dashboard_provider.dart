import 'package:flutter/widgets.dart';

class DashboardProvider extends ChangeNotifier{
  bool _newDashboardShown = false;
  bool get newDashboardShown=>_newDashboardShown;
  void showNewDashboard(){
    _newDashboardShown=true;
    notifyListeners();
  }
  void showOldDashboard(){
    _newDashboardShown=false;
    notifyListeners();
  }

}