import 'package:artgallery/utilities/enums.dart';

class NotificationMessage {
  String notif_id;
  String notif_message;
  NotificationType notif_type;
  DateTime? notif_datetime;
  bool notif_isRead;

  NotificationMessage({
    this.notif_id = '',
    this.notif_message = '',
    this.notif_type = NotificationType.notifMessage,
    this.notif_datetime,
    this.notif_isRead = false,
  });
}
