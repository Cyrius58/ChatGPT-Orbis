import 'package:chatgpt_orbis/constants/constants.dart';
import 'package:chatgpt_orbis/services/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key});

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
                const Text("Here will be the message"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
