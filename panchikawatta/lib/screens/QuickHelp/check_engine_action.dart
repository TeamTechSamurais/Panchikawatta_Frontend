import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CheckEngineAction extends StatefulWidget {
  const CheckEngineAction({Key? key}) : super(key: key);

  @override
  _CheckEngineActionState createState() => _CheckEngineActionState();
}

class _CheckEngineActionState extends State<CheckEngineAction> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId('https://www.youtube.com/watch?v=39DOGyxK-oE')!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Check Engine Warning',
          style: TextStyle(
            color: Color(0xFFFF5C01),
            fontSize: 27,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Material(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Image.asset(
                    'assets/warning_lights/check_engine.jpg',
                    height: 170,
                    width: 170,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const SizedBox(height: 30),
              const Text(
                'Potential to have an issue with the engine\n\n'
                '1. Pull over safely\n'
                '2. Check the fuel cap is tightened securely.\n'
                '3. Inspect any loose connections in any visible hoses, wires, and connections under the hood.\n'
                '4. If any abnormal sound, performance issue immediately ask for professional help.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 50),
              YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.amber,
                onReady: () {
                  _controller.addListener(() {
                    if (_controller.value.isReady) {
                      // Do something once the player is ready
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}







