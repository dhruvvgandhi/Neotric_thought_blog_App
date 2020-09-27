import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'home.dart';
import 'package:anikapp/home.dart';


class upload extends StatefulWidget
{
  State<StatefulWidget>createState()
  {
    return _upload();
  }
}

class _upload extends State<upload>
{
  int _page = 0;
  final formKey = new GlobalKey<FormState>();
  File sampleImage;
  String _myValue;
  String _myValuee;
  String url;

  Future getImage() async
  {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });
  }
  bool validateandsave()
  {
    final form= formKey.currentState;
    if(form.validate())
    {
      form.save();
      return true;
    }
    else
      {
        return false;
      }
  }
  void uploadstatusimage()async
  {
    if(validateandsave())
      {
        final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Post Images");
        var timeKey =new DateTime.now();
        final StorageUploadTask uploadTask = postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);
        var Imageurl= await (await uploadTask.onComplete).ref.getDownloadURL();
        url =  Imageurl.toString();

        gotohomepage();
        savetodatabase(url);
      }
  }
  void savetodatabase(url)
  {
      var dbTimeKey = new DateTime.now();
      var formateDate = new DateFormat("MM d,yyyy");
      var formateTime = new DateFormat("EEEE,hh:mm aaa");

      String date = formateDate.format(dbTimeKey);
      String time = formateTime.format(dbTimeKey);

      DatabaseReference ref = FirebaseDatabase.instance.reference();
      var data = {
        "image": url,
        "title": _myValuee,
        "Description":_myValue,
        "date": date,
        "time": time,

      };
      ref.child("Posts").push().set(data);
  }
  void gotohomepage()
  {
    Navigator.push
      (context,
        MaterialPageRoute(builder: (Context)
        {
          return new Home();
        }));
  }
  @override
  Widget build(BuildContext context)
  {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Upload Your Status"),
        centerTitle:true,
      ),
      body: new Center
        (
        child: sampleImage == null ? Text("Select an Image"):enableUpload(),
        ),
        floatingActionButton: new FloatingActionButton
          (
          onPressed: getImage,
          tooltip: 'Add Image',
          child: new Icon(Icons.add_a_photo),
        ),
    );
  }
  Widget enableUpload()
  {
    return new Container
      (
      child: new Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Image.file(sampleImage,height: 350.0,width: 650.0,),
            SizedBox(height: 15.0,),
            TextFormField(
              decoration: new InputDecoration(labelText: 'Enter Title of blog'),
              validator: (valuee){
                return valuee.isEmpty ? 'Blog title is required ':null;
              },
              onSaved:(valuee)
              {
                return _myValuee=valuee;
              },
            ),

            SizedBox(height: 15.0,),
            TextFormField(
              decoration: new InputDecoration(labelText: 'Description'),
              validator: (value){
                return value.isEmpty ? 'Blod Description is required ':null;
              },
              onSaved:(value)
              {
                return _myValue=value;
              },
            ),
            SizedBox(height: 15.0,),
            RaisedButton(
              elevation: 10.0,
              child: Text("Upload A Post"),
              textColor: Colors.white,
              color: Colors.orange,
              onPressed:uploadstatusimage,
            )
          ],
        ),
      ),
    );
  }
}