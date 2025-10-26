import 'package:flutter/material.dart';
import 'package:fv2/api/ApiHelper.dart';
import 'package:fv2/models/CommentNotification.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:dio/dio.dart';

class NotificationProvider extends ChangeNotifier {
  List<dynamic> _notifications = [];
  bool isLoading = false;
  List<dynamic> get notifications => _notifications;
  int unread_count = 0;
    bool _disposed = false;
 @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  Future<void> fetchUnreadCount() async {
    try {
      ApiResult result = await Apihelper.post(ApiRequest(path: "/unreadCount"));
      if (result.status) {
        unread_count = result.data["unread_count"] ?? 0;
        notifyListeners();
      } else {
        print("error ${result.message}");
      }
    } catch (e) {
      print("error $e");
    }
  }

  Future<void> markAsRead(String id) async {
    int index = _notifications.indexWhere(
      (notification) => notification.id == id,
    );

    try {
      if (index != -1) {
        _notifications[index].is_read = true;
        notifyListeners();
      }
      ApiResult result = await Apihelper.post(
        ApiRequest(path: "/markAsRead", data: {"notification_id": id}),
      );
      if (result.status) {
        print("notification marked as read");
      } else {
        print("error ${result.message}");
        if (index != -1) {
          _notifications[index].is_read = false;
        }
      }
    } catch (e) {
      print("error $e");
      if (index != -1) {
        _notifications[index].is_read = false;
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading = true;
      notifyListeners();
      ApiResult result = await Apihelper.get(ApiRequest(path: "/notification"));
      if (result.status) {
        if (result.data is List) {
          List<dynamic> data = result.data as List<dynamic>;
          print("fetched ${data.length} notifications");
          final List fetchedNotifications = [];

          for (var Notification in data) {
            if (Notification["type"] == "comment") {
              fetchedNotifications.add(
                CommentNotification.fromMap(
                  Notification as Map<String, dynamic>,
                ),
              );
            }
          }
          _notifications
            ..clear()
            ..addAll(fetchedNotifications);
        } else {
          print("error not a list");
        }
      } else {
        print("error ${result.message}");
      }
    } catch (e) {
      print("error $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
