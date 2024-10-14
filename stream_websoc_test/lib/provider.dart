import 'package:flutter/material.dart';
import 'package:stream_websoc_test/view_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class TestProvider extends ChangeNotifier {
  WebSocketChannel? _channel;
  Stream<dynamic>? _stream;

  WebSocketChannel? get channel => _channel;
  Stream<dynamic>? get stream => _stream;

  void initWebsSocket() async {
    _channel = await VM().initWebSocketVM();
    notifyListeners();
  }

  void getStream() async {
    _stream = await VM().getStreamVM(_channel);
    notifyListeners();
  }

  void sentMessage(String text) async {
    await VM().sendMessageVM(_channel, text);
    notifyListeners();
  }
}
