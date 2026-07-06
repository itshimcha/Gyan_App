import 'package:flutter/material.dart';
import 'package:gyansutra/extra/com_wid.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StarBg(),
          Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                 color: Colors.black54
              )
          ),

          Center(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/translogo2.png", height: 100,width: 100,),
              Text(
                  "Explore will be introduced soon stay tuned",
                style:TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600
                ),
              )
            ],
          )
        ),]
      ),
    );
  }
}
