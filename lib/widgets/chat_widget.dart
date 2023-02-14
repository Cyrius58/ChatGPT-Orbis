import 'package:chatgpt_orbis/constants/constants.dart';
import 'package:chatgpt_orbis/services/assets_manager.dart';
import 'package:chatgpt_orbis/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'text_widget.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, required this.msg, required this.chatIndex});

  final String msg;
  final int chatIndex;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image.asset(
                  AssetsManager.userImage,
                  height: 30,
                  width: 30,
                ),
                const SizedBox(
                  width: 8,
                ),
                const TextWidget(
                  label: "Hello here our msg!",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}