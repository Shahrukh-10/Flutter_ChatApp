import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_string/random_string.dart';
import 'package:whatsup/Databasemethod/database_Method.dart';
import 'package:whatsup/Functions/sharedPreferenceStoreUserDetails.dart';

class ChatScreen extends StatefulWidget {
  final String chatWithUserName, name;

  const ChatScreen(this.chatWithUserName, this.name);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chatRoomId, messageId = '';
  Stream messageStream;
  String myName, myProfilePic, myuserName, myemail;
  TextEditingController _msgTobeSend = TextEditingController();

  getMyInfofromSharedPreferences() async {
    myName = await SharedPreferenceStoreUserDetails().getDisplayName();
    myProfilePic = await SharedPreferenceStoreUserDetails().getUserProfileUrl();
    myuserName = await SharedPreferenceStoreUserDetails().getUserName();
    myemail = await SharedPreferenceStoreUserDetails().getUserEmail();

    chatRoomId = getChatRoomIdbyUserNames(widget.chatWithUserName, myuserName);
  }

  getChatRoomIdbyUserNames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }

  getAndSetMessages() async {
    messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  doThisOnLaunch() async {
    await getMyInfofromSharedPreferences();
    getAndSetMessages();
  }

  @override
  void initState() {
    // TODO: implement initState
    doThisOnLaunch();
    super.initState();
  }

  addMessage(bool sendClicked) {
    if (_msgTobeSend.text != '') {
      String message = _msgTobeSend.text;

      var lastMessageTs = DateTime.now();
      Map<String, dynamic> messageInfoMap = {
        'message': message,
        'sendBy': myuserName,
        'ts': lastMessageTs,
      };

      if (messageId == '') {
        messageId = randomAlphaNumeric(12);
      }
      DatabaseMethods()
          .addMessage(chatRoomId, messageId, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          'lastMessage': message,
          'lastMessageSendTs': lastMessageTs,
          'lastMessageSendBy': myuserName,
        };
        DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfoMap);

        if (sendClicked) {
          _msgTobeSend.text = '';
          messageId = '';
        }
      });
    }
  }

  Widget sendButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
          color: Colors.tealAccent[700],
          borderRadius: BorderRadius.circular(30)),
      child: IconButton(
        alignment: Alignment.center,
        onPressed: () {
          addMessage(true);
        },
        icon: Icon(
          Icons.send,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }

  Widget chatmessages() {
    return StreamBuilder(
        stream: messageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  reverse: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return chatMessageTile(
                        ds['message'], myuserName == ds['sendBy']);
                  })
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  Widget chatMessageTile(String message, bool sendByme) {
    return Row(
      mainAxisAlignment:
          sendByme ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: sendByme ? Radius.circular(24) : Radius.circular(0),
              bottomRight: sendByme ? Radius.circular(0) : Radius.circular(24),
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            color: sendByme ? Colors.teal : Colors.grey[800],
          ),
          padding: EdgeInsets.all(10),
          child: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff075e54),
        title: Text(
          widget.name,
          style: GoogleFonts.londrinaSolid(
            textStyle: TextStyle(
                color: Colors.white, fontSize: 30, letterSpacing: 1.2),
          ),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            chatmessages(),
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(bottom: 1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(50)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          controller: _msgTobeSend,
                          onChanged: (value) {
                            addMessage(false);
                          },
                          cursorColor: Colors.teal,
                          decoration: InputDecoration(
                              hintText: 'Type a message',
                              hintStyle: TextStyle(color: Colors.white38),
                              border: InputBorder.none),
                        ),
                      ),
                    )),
                    sendButton()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
