import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chatgpt_orbis/constants/api_consts.dart';
import 'package:chatgpt_orbis/models/chat_models.dart';
import 'package:chatgpt_orbis/models/models_models.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(
        Uri.parse("$BASE_URL/models"),
        headers: {'Authorization': 'Bearer $API_KEY'},
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        //print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      //print("jsonResponse $jsonResponse");
      List temp = [];
      for (var value in jsonResponse["data"]) {
        temp.add(value);
        //log("temp ${value["id"]}");
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }

  //Send Message using ChatGPT API :

  static List<String> finalContent = [];
  static Future<List<ChatModel>> sendMessageGPT({
    required String message,
    required String modelId,
  }) async {
    try {
      //log("model $modelId");
      var response = await http.post(
        Uri.parse("$BASE_URL/chat/completions"),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          'Content-Type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(
          {
            "model": modelId,
            "messages": [
              {
                "role": "user",
                "content": message,
              },
              for (var content in finalContent) jsonDecode(content)
            ]
          },
        ),
      );

      Map jsonResponse = jsonDecode(response.body);
      //log(jsonResponse['choices'][0]['message'].toString(), name: 'Assistant Message');

      final contentFirstPart = message;
      final contentFirstPartRemastered =
          'Question pr??c??dente de l\'user : $contentFirstPart';

      final contentSecondPart =
          jsonResponse['choices'][0]['message']['content'];
      final contentSecondPartRemastered =
          'R??ponse pr??c??dente de l\'assistant : $contentSecondPart';

      final tempContent =
          '{"role": "user","content":"$contentFirstPartRemastered | $contentSecondPartRemastered"}';
      final finalTempContent = tempContent.replaceAll(RegExp('\n'), '');
      finalContent.add(finalTempContent);
      //print(finalContent);

      if (jsonResponse['error'] != null) {
        //log("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        //log("jsonResponse[choices]text ${jsonResponse["choices"][0]["text"]}");
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
            msg: jsonResponse["choices"][index]["message"]["content"],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }

/*
*
*
*
*
*
*
*
*
*
*
*
**/
  //Send Message Function :
  static Future<List<ChatModel>> sendMessage({
    required String message,
    required String modelId,
  }) async {
    try {
      log("model $modelId");
      var response = await http.post(
        Uri.parse("$BASE_URL/completions"),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": modelId,
            "prompt": message,
            "max_tokens": 100,
          },
        ),
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        //print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        //log("jsonResponse[choices]text ${jsonResponse["choices"][0]["text"]}");
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
            msg: jsonResponse["choices"][index]["text"],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}
