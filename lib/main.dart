import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; 
import 'package:flutter/cupertino.dart';

void main() {
  runApp(new FriendlychatApp());
}

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

class FriendlychatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Friendlychat",
      theme: defaultTargetPlatform == TargetPlatform.iOS         //new
        ? kIOSTheme                                              //new
        : kDefaultTheme,
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {                     //modified
  @override                                                        //new
  State createState() => new ChatScreenState();                    //new
} 

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {                  //new

  final TextEditingController _textController = new TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("Friendlychat"),
          elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: new Container(
        child: new Column(                                        //modified
          children: <Widget>[                                         //new
            new Flexible(                                             //new
              child: new ListView.builder(                            //new 
                padding: new EdgeInsets.all(8.0),                     //new
                reverse: true,                                        //new
                itemBuilder: (_, int index) => _messages[index],      //new
                itemCount: _messages.length,                          //new
              ),                                                      //new
            ),                                                        //new
            new Divider(height: 1.0),                                 //new
            new Container(                                            //new
              decoration: new BoxDecoration(
                color: Theme.of(context).cardColor),                  //new
              child: _buildTextComposer(),                       //modified
            ),                                                        //new
          ],                                                          //new
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(                                            //new
          children: <Widget>[                                      //new
            new Flexible(                                          //new
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {          //new
                  setState(() {                     //new
                    _isComposing = text.length > 0; //new
                  });                               //new
                },
                onSubmitted: _handleSubmitted,
                decoration: new InputDecoration.collapsed(
                  hintText: "Send a message"),
              ),
            ),
            new Container(                                                 //new
              margin: new EdgeInsets.symmetric(horizontal: 4.0),           //new
              child: Theme.of(context).platform == TargetPlatform.iOS ?  //modified
                new CupertinoButton(                                       //new
                  child: new Text("Send"),                                 //new
                  onPressed: _isComposing                                  //new
                      ? () =>  _handleSubmitted(_textController.text)      //new
                      : null,) :                                           //new
                new IconButton(                                            //modified
                  icon: new Icon(Icons.send),
                  onPressed: _isComposing ?
                      () =>  _handleSubmitted(_textController.text) : null,
                )
            ),                                                        //new
          ],                                                        //new
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {                                                    //new
      _isComposing = false;                                          //new
    });
    ChatMessage message = new ChatMessage(                         //new
      text: text,
      animationController: new AnimationController(                  //new
        duration: new Duration(milliseconds: 400),                   //new
        vsync: this,                                                 //new
      ),                                                   
    );                                                             //new
    setState(() {                                                  //new
      _messages.insert(0, message);                                //new
    });
    message.animationController.forward();
  }

  @override
  void dispose() {                                                   //new
    for (ChatMessage message in _messages)                           //new
      message.animationController.dispose();                         //new
    super.dispose();                                                 //new
  }                                                                  //new
}

const String _name = "Rohan Panda";

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return new SizeTransition(                                    //new
      sizeFactor: new CurvedAnimation(                              //new
          parent: animationController, curve: Curves.easeOut),      //new
      axisAlignment: 0.0,
      child:  new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(child: new Text(_name[0])),
            ),
            new Expanded( 
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(_name, style: Theme.of(context).textTheme.subhead),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
