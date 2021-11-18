import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../constant.dart';
import '../../generated/l10n.dart';
import '../controllers/chat_controller.dart';
import '../elements/EmptyMessagesWidget.dart';
import '../elements/MessageItemWidget.dart';
import '../elements/PermissionDeniedWidget.dart';
import '../models/conversation.dart';
import '../repository/user_repository.dart';

class MessagesWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  MessagesWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _MessagesWidgetState createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends StateMVC<MessagesWidget> {
  ChatController _con;

  _MessagesWidgetState() : super(ChatController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForConversations();
    super.initState();
  }

  Widget conversationsList() {
    return StreamBuilder(
      stream: _con.conversations,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var _docs = _con.orderSnapshotByTime(snapshot);
          return ListView.separated(
              itemCount: _docs.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 7);
              },
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                Conversation _conversation = Conversation.fromJSON(_docs[index].data());
                return MessageItemWidget(
                  message: _conversation,
                  onDismissed: (conversation) {
                    setState(() {
                      //_conversationList.conversations.removeAt(index);
                    });
                  },
                );
              });
        } else {
          return EmptyMessagesWidget();
        }
      },
    );
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
              // print(currentUser.value.apiToken);
              // this.connectToServer(currentUser.value.id,currentUser.value.apiToken);
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
      body: currentUser.value.apiToken == null
          ? PermissionDeniedWidget()
          : ListView(
              primary: false,
              children: <Widget>[
                conversationsList(),
              ],
            ),
    );
  }
}
