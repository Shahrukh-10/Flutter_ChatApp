import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsup/AuthFunctions/auth.dart';
import 'package:whatsup/Databasemethod/database_Method.dart';
import 'package:whatsup/Functions/sharedPreferenceStoreUserDetails.dart';
import 'package:whatsup/Screens/ChatScreen/chatScreen.dart';
import 'package:whatsup/Screens/SplashScreen/splashScreen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchUsername = TextEditingController();
  bool isSearching = false;
  Stream usersStream, chatroomStream;
  String myName, myProfilePic, myuserName, myemail;

  getMyInfofromSharedPreferences() async {
    myName = await SharedPreferenceStoreUserDetails().getDisplayName();
    myProfilePic = await SharedPreferenceStoreUserDetails().getUserProfileUrl();
    myuserName = await SharedPreferenceStoreUserDetails().getUserName();
    myemail = await SharedPreferenceStoreUserDetails().getUserEmail();
    print(myuserName);
    print(myemail);
  }

  getChatRoomIdbyUserNames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }

  searchButtonClick() async {
    isSearching = true;
    setState(() {});
    usersStream =
        await DatabaseMethods().getUserByUserName(searchUsername.text);
  }

  Widget saerchUsersList() {
    return StreamBuilder(
        stream: usersStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];

                    return searchUserTile(
                        profileUrl: ds['imageUrl'],
                        name: ds['name'],
                        email: ds['email'],
                        username: ds['username']);
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  Widget searchUserTile({String profileUrl, name, email, username}) {
    return GestureDetector(
      onTap: () {
        var chatRoomId = getChatRoomIdbyUserNames(username, myuserName);
        Map<String, dynamic> chatRoomInfoMap = {
          'users': [myuserName, username]
        };
        DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(username, name)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
        child: Row(
          children: [
            SizedBox(
              width: 14,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                profileUrl,
                height: 50,
                width: 50,
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                Text(
                  email,
                  style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatroomStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return ChatRoomListTile(
                        ds["lastMessage"], ds.id, myuserName);
                  })
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  getchatRooms() async {
    chatroomStream = await DatabaseMethods().getChatRooms();
    setState(() {});
  }

  onScreenLoad() async {
    await getMyInfofromSharedPreferences();
    getchatRooms();
  }

  @override
  void initState() {
    // TODO: implement initState
    onScreenLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xff075e54),
          title: Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Text(
              'WhatsUp',
              style: GoogleFonts.londrinaSolid(
                textStyle: TextStyle(
                    color: Colors.white, fontSize: 30, letterSpacing: 1.2),
              ),
            ),
          ),
          actions: [
            Container(
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                    onTap: () async {
                      await AuthMethods().signOut().then((value) =>
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SplashScreen())));
                    },
                    child: Icon(Icons.more_vert)),
              ),
            )
          ],
        ),
        body: Container(
          color: Colors.teal[900],
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  isSearching
                      ? Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSearching = false;
                                  searchUsername.text = '';
                                });
                              },
                              child: Icon(Icons.arrow_back)),
                        )
                      : Container(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            color: Color(0xff075e54),
                            border: Border.all(
                                color: Colors.white,
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(24)),
                        child: Expanded(
                          child: TextField(
                            controller: searchUsername,
                            cursorColor: Colors.teal,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "USERNAME",
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    color: Colors.white,
                                    fontSize: 18),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (searchUsername.text != '') {
                                          searchButtonClick();
                                        }
                                        isSearching = true;
                                      });
                                    },
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ))),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              isSearching ? saerchUsersList() : chatRoomList()
            ],
          ),
        ),
      ),
    );
  }
}

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId, myUsername;
  ChatRoomListTile(this.lastMessage, this.chatRoomId, this.myUsername);

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = "", name = "", username = "";

  getThisUserInfo() async {
    username =
        widget.chatRoomId.replaceAll(widget.myUsername, "").replaceAll("_", "");
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserInfo('srukh8197');
    print(
        "${querySnapshot.docs[0].id} ${querySnapshot.docs[0]["name"]}  ${querySnapshot.docs[0]["imgUrl"]}");
    name = '${querySnapshot.docs[0]['name']}';
    profilePicUrl = "${querySnapshot.docs[0]["imageUrl"]}";
    print(name);
    setState(() {});
  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(username, name)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                profilePicUrl,
                height: 40,
                width: 40,
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 3),
                Text(widget.lastMessage)
              ],
            )
          ],
        ),
      ),
    );
  }
}
