import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NowPlaying extends StatefulWidget {
  @override
  _NowPlayingState createState() => _NowPlayingState();

  static _NowPlayingState of(BuildContext context) =>
      context.findAncestorStateOfType<_NowPlayingState>();
}

class _NowPlayingState extends State<NowPlaying>
    with SingleTickerProviderStateMixin {
  static const Duration toggleDuration = Duration(milliseconds: 250);
  static const double maxSlide = 225;
  static const double minDragStartEdge = 60;
  static const double maxDragStartEdge = maxSlide - 16;
  AnimationController _animationController;
  bool _canBeDragged = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _NowPlayingState.toggleDuration,
    );
  }

  void close() => _animationController.reverse();

  void open() => _animationController.forward();

  void toggleDrawer() => _animationController.isCompleted ? close() : open();

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: AnimatedBuilder(
        animation: _animationController,
        child: mainScreen(),
        builder: (context, child) {
          double animValue = _animationController.value;
          final slideAmount = maxSlide * animValue;
          final contentScale = 1.0 - (0.3 * animValue);
          return Stack(
            children: <Widget>[
              MyDrawer(),
              Transform(
                transform: Matrix4.identity()
                  ..translate(slideAmount)
                  ..scale(contentScale, contentScale),
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: _animationController.isCompleted ? close : null,
                  child: child,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = _animationController.isDismissed &&
        details.globalPosition.dx < minDragStartEdge;
    bool isDragCloseFromRight = _animationController.isCompleted &&
        details.globalPosition.dx > maxDragStartEdge;

    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta / maxSlide;
      _animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    double _kMinFlingVelocity = 365.0;

    if (_animationController.isDismissed || _animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;

      _animationController.fling(velocity: visualVelocity);
    } else if (_animationController.value < 0.5) {
      close();
    } else {
      open();
    }
  }

  Widget mainScreen() {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      elevation: 4.0,
      child: SafeArea(
        child: Stack(
          children: [
            BackgroundColors(),
            customBar(MediaQuery.of(context).size.height,
                MediaQuery.of(context).size.width),
            ImageContainer(),
            PlayingPanel(),
          ],
        ),
      ),
    );
  }

  Widget customBar(double height, double width) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: Icon(
                Icons.menu,
                size: height * 0.03,
                color: Colors.grey[500],
              ),
              onPressed: () {
                toggleDrawer();
              }),
          Text(
            'Now Playing',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
                letterSpacing: 2.0,
                fontSize: height * 0.022),
          ),
          IconButton(
              icon: Icon(
                Icons.favorite_border,
                size: height * 0.03,
                color: Colors.grey[500],
              ),
              onPressed: () {})
        ],
      ),
    );
  }
}

class BackgroundColors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        children: [
          ColoredTiles(tileColor: Colors.grey[50]),
          ColoredTiles(tileColor: Colors.white),
          ColoredTiles(tileColor: Colors.white),
          ColoredTiles(tileColor: Colors.grey[50]),
          ColoredTiles(tileColor: Colors.grey[50]),
          ColoredTiles(tileColor: Colors.white),
        ],
      ),
    );
  }
}

class ColoredTiles extends StatelessWidget {
  final Color tileColor;
  ColoredTiles({this.tileColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: tileColor,
    );
  }
}

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
          Text("Janam Fida-e-Haideri",
              style: GoogleFonts.lato(
                color: Colors.grey[600],
                fontSize: height * 0.03,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w500,
              )),
          SizedBox(height: height * 0.03),
          Text("Shahab Hussain",
              style: GoogleFonts.lato(
                color: Colors.grey[400],
                fontSize: height * 0.015,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w500,
              )),
        ],
      ),
    );
  }
}

class PlayingPanel extends StatefulWidget {
  @override
  _PlayingPanelState createState() => _PlayingPanelState();
}

class _PlayingPanelState extends State<PlayingPanel> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: height * 0.33,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[200], offset: Offset(0, 0), blurRadius: 15)
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            )),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Theme(
          data: ThemeData(brightness: Brightness.dark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              ListTile(
                leading: Icon(Icons.new_releases),
                title: Text('News'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
