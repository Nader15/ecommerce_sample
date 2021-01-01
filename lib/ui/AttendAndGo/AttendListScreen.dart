import 'package:ecommerce_sample/ApiFunctions/Api.dart';
import 'package:ecommerce_sample/model/AttendListModel.dart';
import 'package:flutter/material.dart';

class AttendListScreen extends StatefulWidget {
  @override
  _AttendListScreenState createState() => _AttendListScreenState();
}

class _AttendListScreenState extends State<AttendListScreen> {
  AttendListModel attendListModel;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<AttendData> attendaceList = List();
  int productPageIndex = 1;

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(milliseconds: 0), () {
      gettingData();
    });

    super.initState();
  }

  gettingData() {
    Api(context).getAttendanceApi(_scaffoldKey,productPageIndex).then((value) {
      attendListModel = value;
      setState(() {
      attendListModel.success.data.forEach((element) {

          attendaceList.add(element);
        });
      // attendaceList=attendaceList.reversed.toList();

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),

        centerTitle: true,title: Text("الحضور والانصراف",style: TextStyle(color: Colors.black),),),
      key: _scaffoldKey,
      body: Container(
        child: attendaceList.length == 0
            ? Container(
                child: Center(child: Text("No data found")),
              )
            : RefreshIndicator(
              onRefresh: () {
                return Future.delayed(
                    Duration.zero, (){
                  setState(() {
                    attendaceList = List();
                    productPageIndex=1;

                    gettingData();

                  });
                });
              },
              child: ListView.builder(
                  itemCount: attendaceList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(attendaceList[index].type),
                          subtitle: Text("${attendaceList[index].time.split(" ")[0]} ${attendaceList[index].time.split(" ")[1]}"),
                          trailing: attendaceList[index].type=='start'?Icon(Icons.image,color: Colors.green,):Icon(Icons.exit_to_app,color: Colors.red,),
                        ),
                        Divider()
                      ],
                    );
                  }),
            ),
      ),
    );
  }
}
