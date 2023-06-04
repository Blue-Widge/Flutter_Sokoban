import 'package:audioplayers/audioplayers.dart';

late AudioPlayerHandler audioPlayerHandler;

class AudioPlayerHandler{
  late AudioPlayer audioPlayer;
  late AudioPlayer secondaryAudioPlayer;
  AudioPlayerHandler(){
    audioPlayer = AudioPlayer();
    secondaryAudioPlayer = AudioPlayer();
  }

  void playMusic(String path) async
  {
    await audioPlayer.play(DeviceFileSource(path));
  }

  void playSound(String path) async
  {
    await secondaryAudioPlayer.play(DeviceFileSource(path));
  }
}
