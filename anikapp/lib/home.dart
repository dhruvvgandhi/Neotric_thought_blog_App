import 'firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'upload.dart';
import 'Posts.dart';
import 'package:firebase_database/firebase_database.dart';

class Home extends StatefulWidget {
  final User user;

  const Home({Key key, this.user}) : super(key: key);
  @override
  _Home createState() => _Home();
}
class _Home extends State<Home> {

  List<Posts> Postslist =[];
  @override
  void initState()
  {
    super.initState();
    DatabaseReference blogref = FirebaseDatabase.instance.reference().child("Posts");
    blogref.once().then((DataSnapshot snap)
    {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      Postslist.clear();
      for(var individualkey in KEYS)
        {
          Posts posts = new Posts
            (
            DATA[individualkey]['image'],
            DATA[individualkey]['title'],
            DATA[individualkey]['Description'],
            DATA[individualkey]['date'],
            DATA[individualkey]['time'],
          );
          Postslist.add(posts);
        }
      setState(()
      {
        print('Length:$Postslist');
      });
    });
  }
  int _page = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: new Container(
        child: Postslist.length == 0 ? new Text("Nothing Is available , You can post first"):new ListView.builder
          (
          itemCount: Postslist.length,
          itemBuilder: (_,index)
            {
              return PostsUI(Postslist[index].image,Postslist[index].title,Postslist[index].Description, Postslist[index].date, Postslist[index].time);
            }
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
          index: 0,
          height: 50.0,
          items: <Widget>[
            new IconButton(
              icon: new Icon(Icons.list, size: 30),
                onPressed: () {
                  _signOut().whenComplete(() {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => FirebaseA()));
                  });
                }
            ),
            new IconButton(
                icon: new Icon(Icons.add, size: 30),
                onPressed: () {
                  Navigator.push
                    (
                      context,
                      MaterialPageRoute(builder: (context){
                        return new upload();
                      })
                  );
                }
            ),
            new IconButton
            (
              icon: new Icon(Icons.perm_identity, size: 30),
                onPressed: () {
                _signOut().whenComplete(() {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => FirebaseA()));
                });
                }
            )
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.orange,
          backgroundColor: Colors.blue,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
        ),
    );
  }
  Widget PostsUI(String image,String title,String Description,String date,String time)
  {
      return new Card(
        elevation: 10.0,
        margin: EdgeInsets.all(15.0),

        child:new Container(
          padding: new EdgeInsets.all(14.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                    date,
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center,
                  ),
                  new Text(
                    time,
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              SizedBox(height: 15.0,),
              new Image.network(image,fit:BoxFit.cover),
              SizedBox(height: 15.0,),
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Text("Title    :-  "),
                  new Text(
                    title,
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: 15.0,),
              new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Text("Description :-  "),
                new Text(
                  Description,
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            ],
            ),
          ),
        );
  }
  Future _signOut() async {
    await _auth.signOut();
  }
}