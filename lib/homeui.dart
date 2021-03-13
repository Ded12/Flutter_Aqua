import 'dart:ui';
import 'package:flutter/material.dart';

class HomeUI extends StatefulWidget {
  final String val;

  const HomeUI({Key key, this.val}) : super(key: key);
  @override
  _HomeUIState createState() => _HomeUIState() ;

}

class _HomeUIState extends State<HomeUI> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:SingleChildScrollView(
          // Box decoration takes a gradient

        child: Column(

          children: [
            Container(
              width: double.infinity,
              height: 100.0,
              //margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 35, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20), bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 0.0), //(x,y)
                    blurRadius: 10,
                  ),
                ],

              ),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text('Status  ',
                      // style: Theme.of(context).textTheme.headline4,
                      style: TextStyle(
                        fontFamily: 'assets/fonts/mo_li.ttf',
                        color: Colors.black, fontSize: 20, letterSpacing: .2,)
                  ),

                  Text(
                      '${widget.val}',

                      style: TextStyle(
                       // fontFamily:  'assets/fonts/mo_li.ttf',
                        color: Colors.black, fontSize: 20, letterSpacing: .2,)
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

