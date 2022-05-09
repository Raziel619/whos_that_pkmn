import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:whos_that_pkmn/constants/app_colors.dart';
import 'package:whos_that_pkmn/services/local_storage.dart';

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
            importance: NotificationImportance.High)
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
}
