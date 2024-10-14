import 'package:stream_websoc_test/sources.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class VM {
  Future<WebSocketChannel?> initWebSocketVM() async {
    return await TestSource().initWebSocket();
  }

  Future<Stream<dynamic>?> getStreamVM(WebSocketChannel? channel) async {
    return await TestSource().getStreamSrc(channel);
  }

  Future<void> sendMessageVM(WebSocketChannel? channel, String message) async {
    return await TestSource().sendMessage(channel, message);
  }
}
