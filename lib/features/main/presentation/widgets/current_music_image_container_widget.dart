import 'package:earbender/features/main/presentation/bloc/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/constant.dart';

class ImageContainer extends StatefulWidget {
  final BuildContext blocContext;

  ImageContainer({Key key, @required this.blocContext}) : super(key: key);

  @override
  _ImageContainerState createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  String _songName = "Memories - Maroon 5";
  String _artist = "Maroon 5";

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    // A bloc listener is only called once unless forced otherwise
    return BlocListener<MainBloc, MainState>(
      listenWhen: (prevState, current) {
        return true;
      },
      listener: (context, state) {
        if (state is UpdateMusic) {
          // Update current music name when music is updated
          setState(() {
            final String fileName = state.musicPath.split('/').last;
            _songName = state.musicPath
                .split('/')
                .last
                .substring(0, fileName.lastIndexOf('.'));
            _artist = "N/A";
          });
        }
      },
      child: Center(
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
            Text(
              "$_songName",
              style: kSongNameStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: height * 0.03),
            Text(
              "$_artist",
              style: kSingerNameStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
