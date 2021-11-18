import 'dart:async';

import 'package:flutter/material.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../constant.dart';
import '../../generated/l10n.dart';
import '../controllers/chat_controller.dart';
import '../elements/ChatMessageListItemWidget.dart';
import '../models/chat.dart';
import '../models/conversation.dart';
import '../models/route_argument.dart';
import '../repository/user_repository.dart';

class ChatWidget extends StatefulWidget {
  final RouteArgument routeArgument;
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  ChatWidget({Key key, this.parentScaffoldKey, this.routeArgument}) : super(key: key);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends StateMVC<ChatWidget> {
  final _myListKey = GlobalKey<AnimatedListState>();
  final myController = TextEditingController();

  ChatController _con;
  Timer timer;
  _ChatWidgetState() : super(ChatController()) 
  {
    _con = controller;
  }

  @override
  void initState() {
    _con.conversation = widget.routeArgument != null ? widget.routeArgument.param as Conversation : null;
    if (_con.conversation != null && _con.conversation.id != null) {
      _con.listenForChats(_con.conversation);
    }
    this.connectToServer(currentUser.value.id, currentUser.value.apiToken);    
    super.initState();

    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      
        _con.getConversation();    
      
    });
    
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    timer?.cancel();
    myController.dispose();
    super.dispose();
  }

  Widget chatList() {
    return ListView.builder(
                key: _myListKey,
                reverse: true,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                itemCount: _con.chats.length,
                shrinkWrap: false,
                primary: true,
                itemBuilder: (context, index) {
                  Chat _chat = _con.chats.elementAt(_con.chats.length-1-index);
                  // _chat.user = _con.conversation.users.firstWhere((_user) => _user.id == _chat.sender);
                  return ChatMessageListItem(
                    chat: _chat,
                  );
                });
    
    // StreamBuilder(
    //   stream: _con.chats,
    //   builder: (context, snapshot) {
    //     return snapshot.hasData
    //         ? ListView.builder(
    //             key: _myListKey,
    //             reverse: true,
    //             physics: const AlwaysScrollableScrollPhysics(),
    //             padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    //             itemCount: snapshot.data.documents.length,
    //             shrinkWrap: false,
    //             primary: true,
    //             itemBuilder: (context, index) {
    //               print(snapshot.data.documents[index].data());
    //               Chat _chat = Chat.fromJSON(snapshot.data.documents[index].data());
    //               // _chat.user = _con.conversation.users.firstWhere((_user) => _user.id == _chat.sender);
    //               return ChatMessageListItem(
    //                 chat: _chat,
    //               );
    //             })
    //         : EmptyMessagesWidget();
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          icon:  Icon(Icons.arrow_back_ios_rounded),
            color: Constants.primaryColor,
            // Within the SecondRoute widget
            onPressed: () {
              Navigator.of(context).pop();
            }
            // currentUser.value.apiToken
            // widget.parentScaffoldKey.currentState.openDrawer();             
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).messages,
          overflow: TextOverflow.fade,
          maxLines: 1,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: [
          IconButton(
            onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
            color: Constants.primaryColor,
            icon: Icon(Icons.person),
            iconSize: 35,
          )
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Image.asset(
              "assets/img/icons-cote-.png",
              color: Colors.grey[300],
              fit: BoxFit.contain,
            ),
          ),
          
          Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: chatList(),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.10), offset: Offset(0, -4), blurRadius: 10)],
                ),
                child: TextField(
                  controller: myController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    hintText: S.of(context).typeToStartChat,
                    hintStyle: TextStyle(color: Theme.of(context).focusColor.withOpacity(0.8)),
                    suffixIcon: IconButton(
                      padding: EdgeInsets.only(right: 30),
                      onPressed: () {
                        _con.sendMessage(_con.conversation,myController.text);
                        _con.getConversation();
                        //_con.addMessage(_con.conversation, myController.text);
                        Timer(Duration(milliseconds: 100), () {
                          myController.clear();
                        });
                      },
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).accentColor,
                        size: 30,
                      ),
                    ),
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              )
            ],
          ),
            ])
    );
  }


 void connectToServer(id,apiToken) {
    // print("pressed !");
    try {
      // Configure socket transports must be sepecified
      // Create echo instance
      var url  ='http://admin.webiliapp.com:6001';
      
      //var _token = 'Pcxne6W2BWM9Z9BuHYnSJTyr3mTqmjfVLKvM9POVt81NRGS2tg97E42JvrZS';
      Echo echo = new Echo(
        {
          'broadcaster': 'socket.io',
          'client': IO.io,
          'authEndpoint': "/api/broadcasting/auth",
          'namespace': "App.Events",
          'host': url,
          'auth': {
            'headers': {
              'Authorization': "Bearer " + apiToken,
            },
          }
        });

      //print('App.User.'+id);
        
      //echo.connector.socke(url);
      //log(echo.sockedId());
      // Connect to websocket
      //socket.connect();

      //echo.connect();

      echo.socket.on('connect', (_) {
        print('connected');
        //_con.getMessages();
      });
      
      echo.socket.on('.new.message', (_) {
        print('new message');
      });

      echo.private('App.User.'+id).listen('App.Events.new.message', (e) {
        print(e.message.toString());
      });

      echo.socket.on('disconnect', (_) => print('disconnected'));

    } catch (e) {
      print("xrxrxr");
      print(e.toString());
    }


  }


}
