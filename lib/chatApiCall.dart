import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<BotResponse> responseFromBot(String sender, String message) async {

  final http.Response response = await http.post(
    'http://127.0.0.1:5005/webhooks/rest/webhook',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'sender': sender,
       'message': message
    }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return BotResponse.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // return default Message

    BotResponse errorResponse = BotResponse(recipientId: 'sampleRecipient',text: 'sampleText');

    return errorResponse;
  }
}

class BotResponse {
  final String recipientId;
  final String text;

  BotResponse({this.recipientId, this.text});

  factory BotResponse.fromJson(List<dynamic> json) {

    Map<String, dynamic> firstElement = json[0];

    return BotResponse(
      recipientId: firstElement['recipient_id'],
      text: firstElement['text']
     );
  }
}