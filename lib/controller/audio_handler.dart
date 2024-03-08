import 'package:audioplayers/audioplayers.dart';

final player = AudioPlayer();
initAudioPlayer() async {
  await player.setSource(AssetSource('sounds/20_r.mp3'));
}
