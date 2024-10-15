import 'dart:async';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:stream_websoc_test/view_model.dart';

class TestProvider extends ChangeNotifier {
  late StreamController<String> _socketResponse;
  IO.Socket? _socket;
  Stream<dynamic>? _stream;
  final List<String> _messages = [];

  StreamController<String>? get socketResponse => _socketResponse;
  IO.Socket? get socket => _socket;
  Stream<dynamic>? get stream => _stream;
  List<String> get messages => _messages;

  void addMessage(String message) {
    _messages.add(message);
  }

  void initWebSocket() async {
    StreamController<String> socRes;
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

  void sentMessage(String text) async {
    await VM().sendMessageVM(_socket!, text);
    notifyListeners();
  }
}
