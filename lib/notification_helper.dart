import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'schedule_models.dart';

/// Kelas utilitas untuk inisialisasi, izin, dan penjadwalan notifikasi lokal.
class NotificationHelper {
  NotificationHelper._();

  static final NotificationHelper instance = NotificationHelper._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Inisialisasi timezone, plugin, dan izin notifikasi.
  Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Notifikasi diklik: ${response.payload}');
      },
    );

    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
      await androidPlugin.requestExactAlarmsPermission();
    }
  }

  /// Menjadwalkan notifikasi satu kali pada [scheduledTime].
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

    if (tzScheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
      debugPrint(
        'Notifikasi id=$id tidak dijadwalkan karena waktu sudah lewat.',
      );
      return;
    }

    await _plugin.cancel(id);

    const androidDetails = AndroidNotificationDetails(
      'daily_schedule_channel',
      'Pengingat Jadwal',
      channelDescription: 'Notifikasi pengingat jadwal harian',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: null,
      payload: 'schedule_$id',
    );

    debugPrint('Notifikasi id=$id dijadwalkan pada $tzScheduledTime');
  }

  Future<void> scheduleEntryNotifications({
    required DayInfo day,
    required ScheduleEntry entry,
  }) async {
    final reminderTime = reminderDateTimeForEntry(
      dayName: day.name,
      start: entry.start,
    );
    final startTime = nextScheduleDateTimeForDay(
      dayName: day.name,
      time: entry.start,
    );

    await scheduleNotification(
      id: notificationIdForEntry(entry),
      title: 'Pengingat: ${entry.subject}',
      body:
          'Dimulai 5 menit lagi (${formatTime(entry.start)}) di ${entry.location}',
      scheduledTime: reminderTime,
    );

    await scheduleNotification(
      id: startNotificationIdForEntry(entry),
      title: 'Waktunya: ${entry.subject}',
      body: 'Jadwal dimulai sekarang di ${entry.location}.',
      scheduledTime: startTime,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
    debugPrint('Notifikasi id=$id dibatalkan.');
  }

  Future<void> cancelEntryNotifications(ScheduleEntry entry) async {
    await cancelNotification(notificationIdForEntry(entry));
    await cancelNotification(startNotificationIdForEntry(entry));
  }

  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
    debugPrint('Semua notifikasi dibatalkan.');
  }
}
