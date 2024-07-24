import 'package:artgallery/models/artist.dart';
import 'package:artgallery/utilities/enums.dart';

class DirectMessage {
  Artist msgSender;
  Artist msgReceiver;
  DateTime? msgSent;
  DateTime? msgReceived;
  MessageType msgType;
  String msgMessage;
  bool msgIsRead;
  bool msgIsDelete;

  DirectMessage({
    required this.msgSender,
    required this.msgReceiver,
    this.msgSent,
    this.msgReceived,
    this.msgType = MessageType.msgText,
    this.msgMessage = '',
    this.msgIsRead = false,
    this.msgIsDelete = false,
  });
}
