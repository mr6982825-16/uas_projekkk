import 'dart:html' as html;
import 'notification_helper.dart';

NotificationHelper getNotificationHelper() => WebNotificationHelper();

class WebNotificationHelper implements NotificationHelper {
  @override
  Future<void> init() async {
    try {
      if (html.Notification.permission == 'default') {
        await html.Notification.requestPermission();
      }
    } catch (e) {
      print('Browser notification permission request failed: $e');
    }
  }

  @override
  Future<void> showInstantNotification(String title, String body) async {
    try {
      if (html.Notification.permission == 'granted') {
        html.Notification(title, body: body);
      } else if (html.Notification.permission == 'default') {
        final permission = await html.Notification.requestPermission();
        if (permission == 'granted') {
          html.Notification(title, body: body);
        }
      }
    } catch (e) {
      print('Failed to show browser notification: $e');
    }
  }

  @override
  Future<void> schedulePrayerNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    // Scheduled notifications are handled in the foreground by the app's periodic timer.
    // Web browsers do not natively support exact offline scheduling without Service Workers,
    // so we rely on the foreground timer for the web app.
  }

  @override
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    required String soundName,
  }) async {}

  @override
  Future<void> cancel(int id) async {}

  @override
  Future<void> cancelAllNotifications() async {}
}
