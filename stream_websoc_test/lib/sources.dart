import 'dart:async';
import 'dart:io';
import 'package:socket_io_client/socket_io_client.dart' as IO;
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

  Future<Stream<dynamic>?> getStreamSrc(WebSocketChannel? channel) async {
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

class StreamSocket {
  final _socketResponse = StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  Future<void> initSocketIO() async {
    IO.Socket socket = IO.io('http://localhost:3000',
        IO.OptionBuilder().setTransports(['websocket']).build());

    socket.onConnect((_) {
      print('connect');
      socket.emit('msg', 'test');
    });

    //When an event received from server, data is added to the stream
    socket.on('event', (data) => addResponse);
    socket.onDisconnect((_) => print('disconnect'));
  }

  void dispose() {
    _socketResponse.close();
  }
}
