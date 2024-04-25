//try nak buat mcm dkt link ni. tapi nanti dulu (mira)
//https://www.youtube.com/watch?v=ucwBcTgxyME

import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Material(
      child: Container(
        width:MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Stack(
              children:[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.6,
                  decoration: BoxDecoration(
                    color:Color(0xFFFFFCF4), //cara nak letak colour yang guna hexa
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.0,
                  decoration: BoxDecoration(
                    color:Color(0xFFECAA00), //cara nak letak colour yang guna hexa
                    borderRadius: 
                      BorderRadius.only(bottomRight: Radius.circular(50)),
                  ),
                  //child: Center(child: Image.asset("images/sport.png", scale:0.8),
                  //),
                ),
              ],
            ),
          ],
        ),     
        ),
    );
  }
}
