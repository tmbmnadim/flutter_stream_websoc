import 'dart:async';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:stream_websoc_test/message_model.dart';
import 'package:stream_websoc_test/view_model.dart';

class TestProvider extends ChangeNotifier {
  late StreamController<MessageModel> _socketResponse;
  IO.Socket? _socket;
  Stream<MessageModel>? _stream;
  final List<MessageModel> _messages = [];

  StreamController<MessageModel>? get socketResponse => _socketResponse;
  IO.Socket? get socket => _socket;
  Stream<MessageModel>? get stream => _stream;
  List<MessageModel> get messages => _messages;

  void addMessage(MessageModel message) {
    _messages.add(message);
  }

  void initWebSocket() async {
    StreamController<MessageModel> socRes;
    IO.Socket soc;
    (soc, socRes) = await VM().initSocketIOVM();

    _socket = soc;
    _socketResponse = socRes;
    getStream();
    notifyListeners();
  }

  void getStream() async {
    _stream = socketResponse?.stream ?? const Stream.empty();
    notifyListeners();
  }

  void sentMessage(MessageModel text) async {
    await VM().sendMessageVM(_socket!, text);
    notifyListeners();
  }
}
