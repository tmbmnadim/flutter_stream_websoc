import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:stream_websoc_test/provider.dart";

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<String> _messages = ["----", "===="];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<TestProvider>(context, listen: false).initWebsSocket();
    Provider.of<TestProvider>(context, listen: false).getStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat UI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<TestProvider>(context, listen: false).getStream();
            },
          ),
        ],
      ),
      body: Consumer<TestProvider>(
        builder: (_, provider, __) {
          return StreamBuilder(
            stream: provider.stream ?? const Stream.empty(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _messages.insert(_messages.length - 1, snapshot.data);
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return _buildMessageItem(_messages[index]);
                      },
                    ),
                  ),
                  _buildMessageInput(),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMessageItem(String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(message),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: _addImage, // Placeholder for image picker functionality
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter a message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      Provider.of<TestProvider>(context, listen: false)
          .sentMessage(_controller.text);
    }
  }

  void _addImage() {
    print("Image icon clicked!");
  }
}
