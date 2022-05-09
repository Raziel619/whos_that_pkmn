import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:whos_that_pkmn/constants/app_colors.dart';
import 'package:whos_that_pkmn/services/local_storage.dart';
import 'package:whos_that_pkmn/utils/functions.dart';

class PushNotifications {
  static const String DAILY_ALERT_CHANNEL = "daily_alert_channel";
  static final _notifier = AwesomeNotifications();

  static Future<void> initialize() async {
    _notifier.initialize(
      null,
      [
        NotificationChannel(
          channelKey: DAILY_ALERT_CHANNEL,
          channelName: 'Daily Notifications',
          defaultColor: AppColors.PRIMARY_PINK,
          channelDescription: "Daily Alerts for Who's That Pkmn?!",
        )
      ],
    );
    //_notifier.
  }

  static Future<void> checkPermissions() async {
    _notifier.isNotificationAllowed().then((isAllowed) {
      final alreadyAsked = LocalStorage.retrieveBool(LSKey.requestedPerms);
      if (!isAllowed && !alreadyAsked) {
        AwesomeNotifications().requestPermissionToSendNotifications();
        LocalStorage.saveBool(LSKey.requestedPerms, true);
      }
    });
  }

  static Future<void> setUpScheduledNotifications() async {
    _notifier.cancelAllSchedules();
    final now = DateTime.now();

    for (int i = 0; i < 30; i++) {
      final date = now.add(Duration(days: i));
      final content = NotificationContent(
          id: buildIdIntFromDate(date),
          channelKey: DAILY_ALERT_CHANNEL,
          title: "Who's That Pkmn?!",
          body: 'Quizzes are waiting for you!');
      final schedule = NotificationCalendar(
          year: date.year,
          month: date.month,
          day: date.day,
          hour: 12,
          minute: 0,
          second: 0,
          millisecond: 0);
      await _notifier.createNotification(content: content, schedule: schedule);
    }
  }

  static void cancelTodayNotification() {
    final id = buildIdIntFromDate(DateTime.now());
    _notifier.cancelSchedule(id);
  }
}
