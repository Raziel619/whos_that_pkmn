import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';

//Note: please pay attention to the method descriptions, with great power comes great responsibility
class AudioService {
  //region Private Properties
  AudioPlayer? _playerMain;
  bool _pausedOnBackground = false;
  bool _isMuted = false;
  final _volume = 0.7;

  //endregion

  //region Public Accessors
  bool get isMuted => _isMuted;

  //endregion

  AudioService() {
    _playerMain = AudioPlayer();
  }

  /// Plays an audio file. Use playOneShot if a single quick clip with no succession
  /// is to be played
  /// Make sure to manually call dispose if this method is used
  Future<void> play(String audio, {bool loop = false}) async {
    if (_isMuted) {
      return;
    }
    // first check if an audio is currently playing and stop it if so
    if (_playerMain!.playing) {
      await _playerMain!.stop();
    }

    // play audio on main player, expect caller to dispose
    _playerMain = AudioPlayer();
    await _playerMain!.setAsset(audio);
    await _playerMain!.load();
    await _playerMain!.setLoopMode(loop ? LoopMode.all : LoopMode.off);

    await _playerMain!.play();
  }

  /// Plays audio on one shot player and auto dispose when done
  Future<void> playOneShot(String audio) async {
    if (_isMuted) {
      return;
    }
    var _playerOneShot = AudioPlayer();
    await _playerOneShot.setAsset(audio);
    await _playerOneShot.setVolume(_volume);
    await _playerOneShot.load();
    await _playerOneShot.play();
    await _playerOneShot.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {

    // check if the app is backgrounded while an audio was playing, if so, set flag and stop audio
    if (state != AppLifecycleState.resumed && _playerMain!.playing) {
      _pausedOnBackground = true;
      _playerMain!.stop();
    }
    // check if flag was previously set and app has resumed, if so, restart audio
    // sounded is restarted from beginning to release resources while backgrounded
    else if (_pausedOnBackground && state == AppLifecycleState.resumed) {
      _pausedOnBackground = false;
      _playerMain!.play();
    }
  }

  Future<void> pause() async {
    await _playerMain?.pause();
  }

  Future<void> resume() async {
    await _playerMain?.play();
  }

  Future<void> stop() async {
    await _playerMain?.stop();
  }

  bool toggleMute() {
    _isMuted = !_isMuted;
    if (_isMuted) {
      stop();
    }
    return _isMuted;
  }

  void dispose() {
    _playerMain
      ?..stop()
      ..dispose();
  }
}
