import 'package:flutter/material.dart';
import '../../../../core/utils/constant.dart';

class ImageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Center(
      child: Column(
        children: [
          SizedBox(height: height * 0.15),
          Container(
            padding: const EdgeInsets.all(8.0),
            height: height * 0.25,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[200],
                      blurRadius: 15.0,
                      offset: Offset(10, 20),
                      spreadRadius: 8.0)
                ]),
            child: Image.asset('assets/images/music.png'),
          ),
          SizedBox(height: height * 0.1),
          Text("Memories - Maroon 5", style: kSongNameStyle),
          SizedBox(height: height * 0.03),
          Text("Maroon 5", style: kSingerNameStyle),
        ],
      ),
    );
  }
}
