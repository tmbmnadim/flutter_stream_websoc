import 'dart:async';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:stream_websoc_test/message_model.dart';

class StreamSocket {
  void addResponseSrc(IO.Socket socket, String message) {
    print("message sent:\n $message");
    socket.emit('chat message', message);
  }

  Future<(IO.Socket, StreamController<MessageModel>)> initSocketIO() async {
    final socketResponse = StreamController<MessageModel>();

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
        final messageMap = jsonDecode(data);
        MessageModel messageModel = MessageModel.fromJson(messageMap);

        socketResponse.sink.add(messageModel);
      },
    );

    socket.onDisconnect((_) => print('disconnect'));
    return (socket, socketResponse);
  }

  void dispose(StreamController<String> socketResponse) {
    socketResponse.close();
  }
}
