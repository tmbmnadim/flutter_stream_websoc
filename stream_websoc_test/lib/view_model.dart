import 'dart:async';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:stream_websoc_test/message_model.dart';
import 'package:stream_websoc_test/sources.dart';

class VM {
  Future<(IO.Socket, StreamController<MessageModel>)> initSocketIOVM() async {
    return await StreamSocket().initSocketIO();
    // return await TestSource().initWebSocket();
  }

  Future<void> sendMessageVM(IO.Socket socket, MessageModel message) async {
    String messageJson = jsonEncode(message.toJson());
    return StreamSocket().addResponseSrc(socket, messageJson);
  }
}
