import 'package:flutter/material.dart';
import 'package:flutter_bot/chatApiCall.dart';
import 'package:flutter_bot/facts_message.dart';

import 'package:flutter_dialogflow/dialogflow_v2.dart';

class FlutterFactsChatBot extends StatefulWidget {
  FlutterFactsChatBot({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FlutterFactsChatBotState createState() => new _FlutterFactsChatBotState();
}

class _FlutterFactsChatBotState extends State<FlutterFactsChatBot> {
  final List<Facts> messageList = <Facts>[];
  final TextEditingController _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Chatbot Assistant", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.purple[100],
        elevation: 2,
      ),
      body: Column(children: <Widget>[
        Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true, //To keep the latest messages at the bottom
              itemBuilder: (_, int index) => messageList[index],
              itemCount: messageList.length,
            )),
        _queryInputWidget(context),
      ]),
    );
  }

  Widget _queryInputWidget(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Padding(
        padding: const EdgeInsets.only(left:8.0, right: 8),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _submitQuery,
                decoration: InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(Icons.send, color: Colors.green[400],),
                  onPressed: () => _submitQuery(_textController.text)),

            ),
          ],
        ),
      ),
    );
  }

  void agentResponse(query) async {
    _textController.clear();
    // AuthGoogle authGoogle =
    // await AuthGoogle(fileJson: "assets/NewAgent-81fafa8cda2c.json").build();
    // Dialogflow dialogFlow =
    // Dialogflow(authGoogle: authGoogle, language: Language.english);
    // AIResponse response = await dialogFlow.detectIntent(query);
   BotResponse response =  (await responseFromBot('default', query)) ;

      Facts message = Facts(
      text: response.text,
      name: "Flutter",
      type: false,
    );
    setState(() {
      messageList.insert(0, message);
    });
  }

  void _submitQuery(String text) {
    _textController.clear();
    Facts message = new Facts(
      text: text,
      name: "User",
      type: true,
    );
    setState(() {
      messageList.insert(0, message);
    });
    agentResponse(text);
  }
}