import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/message_controller_provider.dart';
import '../providers/chat_stream_provider.dart';
import '../providers/send_message_provider.dart';

class ChatPage extends ConsumerWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(messageControllerProvider);
    final chatStream = ref.watch(chatStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
      ),
      body: Center(
        child: chatStream.when(
          data: (messages) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final messageData = messages[index];
                      return messageData['is_me'] as bool
                          ? Align(
                              alignment: Alignment.topRight,
                              child: Card(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  width: 300,
                                  padding: const EdgeInsets.all(10),
                                  child:
                                      Text(messageData['message'].toString()),
                                ),
                              ),
                            )
                          : Align(
                              alignment: Alignment.topLeft,
                              child: Card(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(20),
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  width: 300,
                                  padding: const EdgeInsets.all(10),
                                  child:
                                      Text(messageData['message'].toString()),
                                ),
                              ),
                            );
                    },
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          controller: message,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await ref
                            .read(sendMessageProvider(message.text).future);
                        message.clear();
                        ref.invalidate(chatStreamProvider);
                      },
                      icon: const Icon(Icons.send),
                    ),
                  ],
                )
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Text('Error: $err'),
        ),
      ),
    );
  }
}
