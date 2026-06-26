import 'notification_helper_stub.dart'
    if (dart.library.html) 'notification_helper_web.dart'
    if (dart.library.io) 'notification_helper_mobile.dart';

abstract class NotificationHelper {
  factory NotificationHelper() => getNotificationHelper();

  Future<void> init();
  Future<void> showInstantNotification(String title, String body);
  Future<void> schedulePrayerNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  });
  Future<void> cancelAllNotifications();
}
