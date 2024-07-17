import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class EngineTempAction extends StatefulWidget {
  const EngineTempAction({super.key});

  @override
  _EngineTempActionState createState() => _EngineTempActionState();
}

class _EngineTempActionState extends State<EngineTempAction> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId('https://www.youtube.com/watch?v=igNZUdU4Jj4')!,
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
          'Engine Temperature Warning',
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
                    'assets/warning_lights/engine_temp.jpg',
                    height: 200,
                    width: 200,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              const Text(
                'The engine is overheated\n\n'
                '1. Pull over safely\n'
                '2. Turn off engine and allow to cool.\n'
                '3. Check coolant levels when safe.\n'
                '4. Seek professional help if issue persists.',
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
