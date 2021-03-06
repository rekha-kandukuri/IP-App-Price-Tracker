import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:price_tracker/screens/Max.dart';
import './Profile.dart';
import './Search.dart';
import 'package:price_tracker/providers/Auth.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class Tracker_screen extends StatefulWidget {
  @override
  Tracker_screenState createState() => Tracker_screenState();
}


class Tracker_screenState extends State<Tracker_screen> 
{
  final GlobalKey<FormState> _formKey = GlobalKey();
   Map<String, String> _userData = {};
   
   final totalcontroller=TextEditingController();
   var _image;
   


   Future<void > submit() async
   {
      _formKey.currentState.save();
      print('one');
     print(_userData);
     try {
      await Provider.of<Auth>(context, listen: false).tracker(_userData);
      totalcontroller.text= Provider.of<Auth>(context, listen: false).total().toString();

    } catch(e)
    {
      print(e);
    }
  }
  Future<void> getImage() async {
  var image = await ImagePicker.pickImage(source: ImageSource.gallery);
  setState(() {
    _image = image;
  });
  try {
      await Provider.of<Auth>(context, listen: false).Upload(_image);

    } catch(e)
    {
      print(e);
    }
}
   List<String> Days = [
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
  'saturday',
  'sunday',
];
String selectedDay;


  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    
    for (String Day in Days) {
      var newItem = DropdownMenuItem(
        child: Text(Day),
        value: Day,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedDay,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedDay = value;
         
          _userData['day']=selectedDay;
          print(selectedDay);
        });
      },
    );
  }
  CupertinoPicker iOSPicker() {
  
    List<Text> pickerItems = [];
    for (String Day in Days) {
      pickerItems.add(Text(Day));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
        setState(() {
          selectedDay = Days[selectedIndex]; 
            _userData['day']=selectedDay;
        });
      },
      children: pickerItems,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
      title:Center(child: Text('Tracker'),),
      actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.perm_identity),
            onPressed: ()  => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (ctx) => Profile(),
                      ),
                      )
            ),
            IconButton(
            icon: const Icon(Icons.search),
            onPressed: ()  => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (ctx) => Search(),
                      ),
                      )
            ),
             IconButton(
            icon: const Icon(Icons.attach_money),
            onPressed: ()  => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (ctx) => Max(),
                      ),
                      )
            ),
            
            ],
      backgroundColor: Colors.teal[800],
      ),
      body:SafeArea(
        child:  Container(
          child:SingleChildScrollView(
            
                      child: Form(
                        key: _formKey,
               child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: 
         <Widget>[ Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(' CHOOSE DAY',
                        style: TextStyle(
                            fontSize:18.0,
                            fontWeight: FontWeight.w800,
                            color:Colors.teal,
                        ),),
                        SizedBox(
                            width:50.0,
                        ),
                     Container(
                    height: 100.0,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(30.0),
                    child: Platform.isIOS ? iOSPicker() : androidDropdown(),
                ),],
    
                ),
    
                SizedBox(
    
                  height: 20.0,
    
                ),
    
                Text(' ENTER AMOUNT SPENT ',
                 style: TextStyle(fontSize: 19.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.teal),),
                               CostInput(text:'Apparel',child: TextFormField( 
                            onSaved: (value){
                              _userData['apparel']=value;},),),
             CostInput(text:'Grocery',child: TextFormField( 
                            onSaved: (value){
                              _userData['grocery']=value;},),),
             CostInput(text:'Medical',child: TextFormField( 
                            onSaved: (value){
                              _userData['medical']=value;},),),
             CostInput(text:'Miscellaneous',child: TextFormField( 
                            onSaved: (value){
                              _userData['miscellaneous']=value;},),),
                              SizedBox(height:15.0),
                              Row(
                                children:<Widget>[
                                 
                              IconButton(
                                icon: Icon(Icons.attach_file),
                               onPressed: getImage ,
                              ),
                               Text('Upload Bills'),
                                ],
                              ),
                       Center(
                         child: MaterialButton(
                        minWidth: 150,
                            height: 50,
                             color: Colors.cyan[100],
                            child: Text(
                              'GET TOTAL',
                              style: TextStyle(
                                color: Colors.teal[700],
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                            ),
                            onPressed: submit,
                      ),
    
                       ),
    
                        CostInput(text:'TOTAL',child: TextField(
                            controller: totalcontroller,
                            onSubmitted: (value){
                              _userData['TOTAL']=value;
                              },
                              ),
                              ),
                                  ],
            ),
                      ),
          ),
          ),
        ),
      ),
      
    );
  }
}
class CostInput extends StatelessWidget {
  CostInput({this.text,this.child,});
  final Widget child;
final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:<Widget>[
                    Text(text,
                    style:TextStyle(
                      color:Colors.teal,
                      fontSize:20.0,
                    ),),
                    SizedBox(width: 100.0),
                    Container(
                      padding: EdgeInsets.only(bottom:20.0),
                      width: 80.0,
                      child:child,
                    )
                  ],
                ),
              );
  }
}
//Future cameraImage() async {
  //var image = await ImagePicker.pickImage(
    //source: ImageSource.camera,
    //maxHeight: 240.0,
    //maxWidth: 240.0,
  //);
//
  //setState(() {
    //_image = image;
  //});
//}


