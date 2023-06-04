import 'package:audioplayers/audioplayers.dart';

late AudioPlayerHandler audioPlayerHandler;

class AudioPlayerHandler{
  late AudioPlayer audioPlayer;
  AudioPlayerHandler(){
    audioPlayer = AudioPlayer();
  }

  void playMusic(String path) async {
    await audioPlayer.play(DeviceFileSource(path));
  }
}
