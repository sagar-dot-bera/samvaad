package com.example.samvaad

import android.content.Context
import android.media.AudioDeviceInfo
import android.media.AudioManager
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers

class MainActivity : FlutterActivity() {
  private val CHANNEL = "com.samvaad.audio_manager"
  private val TAG = "MainActivity"
  private val scope = CoroutineScope(Dispatchers.IO)

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call,
            result ->
      Log.d(TAG, "method channel called")
      if (call.method == "enableSpeaker") {
        enableSpeaker()
        result.success("audio set to speaker")
      } else if (call.method == "enableEarpiece") {
        Log.d(TAG, "enable earpiece called")
        val answer = enableEarpiece()
        if (answer) {
          Log.d(TAG, "audio device set")
          result.success(true)
        } else {
          Log.d(TAG, "unable to set audio to earpiece")
          result.error("", "Unable to set audio device", "")
        }
      } else if (call.method == "setMuteOn") {
        Log.d(TAG, "set mute called called")
        setMuteOn()
        result.success(true)
      } else if (call.method == "setMuteOff") {
        Log.d(TAG, "set mute called called")
        setMuteOff()
        result.success(true)
      }
    }
  }

  private fun enableSpeaker(): Boolean {
    val audioManager: AudioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
    val devices = getAudioDevices()
    var speakerDevice: AudioDeviceInfo? = null

    for (deviceInfo in devices) {
      if (deviceInfo.type == AudioDeviceInfo.TYPE_BUILTIN_SPEAKER) {
        speakerDevice = deviceInfo
        audioManager.setCommunicationDevice(speakerDevice)
        return true
      }
    }
    return false
  }

  private fun setMuteOn() {
    val audioManager: AudioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager

    audioManager.setMicrophoneMute(true)
  }

  private fun setMuteOff() {
    val audioManager: AudioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager

    audioManager.setMicrophoneMute(false)
  }

  fun getAudioDevices(): List<AudioDeviceInfo> {
    Log.d(TAG, "getting available audio device")
    val audioManager: AudioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
    val devices: List<AudioDeviceInfo> = audioManager.getAvailableCommunicationDevices()

    return devices
  }

  private fun enableEarpiece(): Boolean {
    Log.d(TAG, "set audio to earpiece invoked")
    val audioManager: AudioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
    audioManager.setMode(AudioManager.MODE_IN_COMMUNICATION)
    val devices = getAudioDevices()
    var earpiece: AudioDeviceInfo? = null

    for (deviceInfo in devices) {

      if (deviceInfo.type == AudioDeviceInfo.TYPE_BUILTIN_EARPIECE) {
        Log.d(TAG, "setting audio input to earpiece")
        earpiece = deviceInfo
        Log.d(TAG, "device information ${deviceInfo.id}")
        Log.d(TAG, "audio mode ${audioManager.mode}")
        Log.d(TAG, "isSpeakeron ${audioManager.isSpeakerphoneOn}")
        audioManager.setCommunicationDevice(earpiece)
        return true
      } else {
        Log.d(TAG, "Unable to find earpiece")
        return false
      }
    }

    return false
  }
}
