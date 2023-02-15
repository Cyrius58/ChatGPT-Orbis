import 'package:chatgpt_orbis/constants/constants.dart';
import 'package:chatgpt_orbis/services/api_services.dart';
import 'package:chatgpt_orbis/widgets/chat_widget.dart';
import 'package:chatgpt_orbis/widgets/text_widget.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/widgets/container.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../services/assets_manager.dart';
import '../services/services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final bool _isTyping = true;

  late TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.openaiLogo)),
        title: const Text("ChatGPT"),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showModalSheet(context: context);
            },
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    msg: chatMessages[index]["msg"].toString(),
                    chatIndex:
                        int.parse(chatMessages[index]["chatIndex"].toString()),
                  );
                },
              ),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(
                height: 15,
              ),
              Material(
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: textEditingController,
                          onSubmitted: (value) {
                            //TO DO SEND MESSAGE
                          },
                          decoration: const InputDecoration.collapsed(
                              hintText: "How can I Help you ?",
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            try {
                              await ApiService.getModels();
                            } catch (error) {
                              print("Error $error");
                            }
                          },
                          icon: const Icon(Icons.send, color: Colors.white))
                    ],
                  ),
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}
//https://www.youtube.com/watch?v=oOkviQ-K560&list=PL333BSi_KSQ_AqZQR98tAjxcXYMmPyr8E&index=7