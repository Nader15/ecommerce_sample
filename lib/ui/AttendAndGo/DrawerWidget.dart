
import 'package:ecommerce_sample/ApiFunctions/Api.dart';
import 'package:ecommerce_sample/ApiFunctions/sharedPrefClass.dart';
import 'package:ecommerce_sample/ui/AttendAndGo/AttendListScreen.dart';
import 'package:ecommerce_sample/utils/custom_widgets/cusstom_snackBar.dart';
import 'package:ecommerce_sample/utils/global_vars.dart';
import 'package:ecommerce_sample/utils/navigator.dart';
import 'package:flutter/material.dart';
class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(

      child: Column(
         crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          SizedBox(height: 30,),
         Userattend=='1'?Container():    Card(child: ListTile(onTap: (){
            Api(context).attendAndGo(_scaffoldKey, "start").then((value) {
              setState(() {
                setUserAttend(auth_token: "1").then((value){
                  Userattend="1";
                });
              });
            });
          },title: Text("تسجيل حضور",textAlign: TextAlign.center,),trailing: Icon(Icons.image),)),
          SizedBox(height: 30,),

          Card(child: ListTile(

            onTap: (){

              print("UserattendUserattend:: ${  Userattend}");
              if(  Userattend.isEmpty){
                CustomSnackBar(_scaffoldKey,"من فضلك اولا سجل حضور ");
              }
              else {
                Api(context).attendAndGo(_scaffoldKey, "end").then((value) {
                  setState(() {
                    clearAllData();
                    Userattend="";
                  });
                });
              }
            },
            title: Text("تسجيل انصراف",textAlign: TextAlign.center,),trailing: Icon(Icons.exit_to_app),)),

          SizedBox(height: 30,),

          Card(child: ListTile(
            onTap: (){
              navigateAndKeepStack(context, AttendListScreen());

            },
            title: Text("قائمة الحضور والانصراف",textAlign: TextAlign.center,),trailing: Icon(Icons.list),)),


        ],
      ),
    ),);
  }
}
