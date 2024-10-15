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
  void addResponseSrc(IO.Socket socket, String message) {
    print("message sent");
    socket.emit('chat message', message);
  }

  Future<(IO.Socket, StreamController<String>)> initSocketIO() async {
    final socketResponse = StreamController<String>();

    IO.Socket socket = IO.io(
      'http://10.10.9.219:3000',
      IO.OptionBuilder().setTransports(['websocket']).build(),
    );

    socket.onError((data) => print(data));

    socket.onConnect((_) {
      print('Connected');
    });

    //When an event received from server, data is added to the stream
    socket.on(
      'chat message',
      (data) {
        print("message received");
        socketResponse.sink.add(data);
      },
    );

    socket.onDisconnect((_) => print('disconnect'));
    return (socket, socketResponse);
  }

  void dispose(StreamController<String> socketResponse) {
    socketResponse.close();
  }
}
