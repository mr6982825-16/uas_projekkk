import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_helper.dart';

NotificationHelper getNotificationHelper() => MobileNotificationHelper();

class MobileNotificationHelper implements NotificationHelper {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  @override
  Future<void> init() async {
    tz.initializeTimeZones();
    try {
      final int offsetHours = DateTime.now().timeZoneOffset.inHours;
      String timezoneId = 'Asia/Jakarta';
      if (offsetHours == 8) {
        timezoneId = 'Asia/Makassar';
      } else if (offsetHours == 9) {
        timezoneId = 'Asia/Jayapura';
      }
      tz.setLocalLocation(tz.getLocation(timezoneId));
      print('Notification timezone set to $timezoneId based on offset $offsetHours');
    } catch (e) {
      try {
        tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
      } catch (e2) {
        print('Timezone set failed: $e2');
      }
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _plugin.initialize(settings: initializationSettings);

    // Request permissions for Android 13+
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
      await androidImplementation.requestExactAlarmsPermission();
    }
  }

  @override
  Future<void> showInstantNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'adhan_channel',
      'Notifikasi Adzan',
      channelDescription: 'Saluran untuk notifikasi waktu shalat',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(presentSound: true),
    );

    await _plugin.show(
      id: 0,
      title: title,
      body: body,
      notificationDetails: platformDetails,
    );
  }

  @override
  Future<void> schedulePrayerNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final now = DateTime.now();
    if (scheduledTime.isBefore(now)) return;

    final prefs = await SharedPreferences.getInstance();
    final soundId = prefs.getString('selectedAdhanSoundId') ?? 'makkah';
    
    final bool isSubuh = id == 1 || title.toLowerCase().contains('subuh');
    // Select raw audio resource based on settings and prayer time
    final String soundFileName = isSubuh ? 'azan2' : 'azan_$soundId';

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'adhan_channel_scheduled_$soundFileName',
      'Notifikasi Adzan Jadwal',
      channelDescription: 'Saluran untuk jadwal notifikasi waktu shalat',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(soundFileName),
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentSound: true,
        sound: '$soundFileName.mp3',
      ),
    );

    // Convert DateTime to TZDateTime using timezone local location
    final scheduledTZ = tz.TZDateTime.from(scheduledTime, tz.local);

    try {
      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledTZ,
        notificationDetails: platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      print('Scheduled notification $id at $scheduledTZ');
    } catch (e) {
      print('Failed to schedule exact prayer notification, falling back to inexact: $e');
      try {
        await _plugin.zonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: scheduledTZ,
          notificationDetails: platformDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
        print('Scheduled inexact prayer notification $id at $scheduledTZ');
      } catch (e2) {
        print('Failed to schedule inexact prayer notification: $e2');
      }
    }
  }

  @override
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    required String soundName,
  }) async {
    final scheduledTZ = _nextInstanceOfTime(hour, minute);

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'dzikir_channel_scheduled_$soundName',
      'Pengingat Dzikir',
      channelDescription: 'Saluran untuk pengingat dzikir harian',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(soundName),
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentSound: true,
        sound: '$soundName.mp3',
      ),
    );

    try {
      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledTZ,
        notificationDetails: platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      print('Scheduled daily notification $id at $scheduledTZ with sound $soundName');
    } catch (e) {
      print('Failed to schedule exact daily notification, falling back to inexact: $e');
      try {
        await _plugin.zonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: scheduledTZ,
          notificationDetails: platformDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
        );
        print('Scheduled inexact daily notification $id at $scheduledTZ with sound $soundName');
      } catch (e2) {
        print('Failed to schedule inexact daily notification: $e2');
      }
    }
  }

  @override
  Future<void> cancel(int id) async {
    await _plugin.cancel(id: id);
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  @override
  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }
}
