import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';

class TestSource {
  Future<WebSocketChannel?> initWebSocket() async {
    if (await isInternetConnected()) {
      final WebSocketChannel channel =
          WebSocketChannel.connect(Uri.parse("ws://echo.websocket.org"));
      return channel;
    }
    return null;
  }

  Future<Stream<dynamic>?> websock(WebSocketChannel? channel) async {
    if (await isInternetConnected() && channel != null) {
      return channel.stream;
    }
    return null;
  }

  Future<void> sendMessage(WebSocketChannel? channel, String message) async {
    if (await isInternetConnected() && channel != null) {
      channel.sink.add(message);
    }
  }

  Future<bool> isInternetConnected() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}
