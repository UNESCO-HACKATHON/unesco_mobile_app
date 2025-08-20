package com.example.unesco_mobile_app

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.projection.MediaProjectionManager
import android.os.Build // Ensure this import is present
import android.os.Bundle
import android.util.Log // Add for debugging
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL = "screenshot_channel"
        private const val SCREENSHOT_REQUEST_CODE = 1001
        private const val TAG = "MainActivity" // For logs
    }

    private lateinit var projectionManager: MediaProjectionManager
    private var pendingResult: MethodChannel.Result? = null // store flutter result
    private lateinit var screenshotReceiver: BroadcastReceiver

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        projectionManager =
                getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager

        // 🔥 Register receiver to listen for screenshot saved
        screenshotReceiver =
                object : BroadcastReceiver() {
                    override fun onReceive(context: Context?, intent: Intent?) {
                        val path = intent?.getStringExtra("path")
                        Log.d(TAG, "Received broadcast with path: $path") // Debug log
                        if (path != null) {
                            pendingResult?.success(path) // return file path to flutter
                            pendingResult = null
                        } else {
                            // Optional: Handle error if no path
                            pendingResult?.error("SAVE_FAILED", "Screenshot save failed", null)
                            pendingResult = null
                        }
                    }
                }

        val intentFilter = IntentFilter("SCREENSHOT_TAKEN")
        if (Build.VERSION.SDK_INT >= 34) {
            registerReceiver(screenshotReceiver, intentFilter, 2) // 2 == Context.RECEIVER_EXPORTED
        } else {
            registerReceiver(screenshotReceiver, intentFilter)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(screenshotReceiver)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call,
                result ->
            if (call.method == "takeScreenshot") {
                val intent = projectionManager.createScreenCaptureIntent()
                startActivityForResult(intent, SCREENSHOT_REQUEST_CODE)
                pendingResult = result // save flutter callback
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == SCREENSHOT_REQUEST_CODE &&
                        resultCode == Activity.RESULT_OK &&
                        data != null
        ) {
            val serviceIntent = Intent(this, ScreenshotService::class.java)
            serviceIntent.putExtra("resultCode", resultCode)
            serviceIntent.putExtra("data", data)
            startForegroundService(serviceIntent)
        } else {
            pendingResult?.error("PERMISSION_DENIED", "User denied screenshot permission", null)
            pendingResult = null
        }
    }
}