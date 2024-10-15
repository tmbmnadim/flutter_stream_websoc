import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:stream_websoc_test/sources.dart';

class VM {
  Future<(IO.Socket, StreamController<String>)> initSocketIOVM() async {
    return await StreamSocket().initSocketIO();
    // return await TestSource().initWebSocket();
  }

  Future<void> sendMessageVM(IO.Socket socket, String message) async {
    return StreamSocket().addResponseSrc(socket, message);
  }
}
