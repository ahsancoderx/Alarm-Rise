package com.example.flutter_application_1

import android.content.Context
import android.media.AudioManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlin.math.roundToInt

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "risequest/audio")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setAlarmVolume" -> {
                        val fraction = (call.argument<Double>("volume") ?: 0.0).coerceIn(0.0, 1.0)
                        try {
                            val am = getSystemService(Context.AUDIO_SERVICE) as AudioManager
                            val max = am.getStreamMaxVolume(AudioManager.STREAM_ALARM)
                            am.setStreamVolume(AudioManager.STREAM_ALARM, (fraction * max).roundToInt(), 0)
                            result.success(true)
                        } catch (e: Exception) {
                            result.success(false)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }
}