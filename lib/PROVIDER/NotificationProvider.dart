import 'package:ecommerce_customer/MODELS/notification.dart';
import 'package:ecommerce_customer/SERVICES/dioclient.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  List _logs = [];
  bool _isLoading = false;
  int _unreadCount = 0;

  List get logs => _logs;
  bool get isLoading => _isLoading;

  int get unreadCount => _unreadCount;

  bool get hasUnread => _unreadCount > 0;

  void incrementUnread() {
    _unreadCount++;
    notifyListeners();
  }

  void setUnreadCount(int count) {
    _unreadCount = count;
    notifyListeners();
  }

  void clearUnread() {
    _unreadCount = 0;
    notifyListeners();
  }

  void markAsRead(int count) {
    _unreadCount = (_unreadCount - count).clamp(0, double.infinity).toInt();
    notifyListeners();
  }
  Future<void> fetchNotifications() async {
    _isLoading = true;
    notifyListeners();
    try {
      final r = await Dioclient.dio.get('/notifications');
      if (r.statusCode == 200 || r.statusCode == 201) {
        _logs.clear();
        final re = r.data;
        final notif = re['notification'];
        _logs = notif.map((ele) => MyNotification.fromJson(ele)).toList();
      } else {
        _logs = [];
      }
    } catch (e) {
      print("There is error in fetching the notification ${e}");
    }
    _isLoading = false;
    notifyListeners();
  }
}
