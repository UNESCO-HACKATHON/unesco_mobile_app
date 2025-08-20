package com.example.unesco_mobile_app

import android.app.*
import android.content.Intent
import android.content.res.Resources
import android.graphics.Bitmap
import android.graphics.PixelFormat
import android.hardware.display.DisplayManager
import android.hardware.display.VirtualDisplay
import android.media.Image
import android.media.ImageReader
import android.media.projection.MediaProjection
import android.media.projection.MediaProjectionManager
import android.os.*
import android.util.Log
import androidx.core.app.NotificationCompat
import java.io.File
import java.io.FileOutputStream
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class ScreenshotService : Service() {

        private var mediaProjection: MediaProjection? = null
        private var virtualDisplay: VirtualDisplay? = null
        private var imageReader: ImageReader? = null
        private var handlerThread: HandlerThread? = null
        private var handler: Handler? = null
        private var timedOut = false

        override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
                startForeground(1, createNotification())

                val resultCode =
                        intent?.getIntExtra("resultCode", Activity.RESULT_CANCELED)
                                ?: return START_NOT_STICKY
                val data = intent.getParcelableExtra<Intent>("data") ?: return START_NOT_STICKY

                val projectionManager =
                        getSystemService(MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
                mediaProjection = projectionManager.getMediaProjection(resultCode, data)

                mediaProjection?.registerCallback(
                        object : MediaProjection.Callback() {
                                override fun onStop() {
                                        Log.d("ScreenshotService", "MediaProjection onStop")
                                        cleanup()
                                }
                        },
                        null
                )

                
                Handler(Looper.getMainLooper()).postDelayed({ takeScreenshotNow() }, 500)
                return START_NOT_STICKY
        }

        private fun createNotification(): Notification {
                val channelId = "screenshot_channel"
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        val channel =
                                NotificationChannel(
                                        channelId,
                                        "Screenshot Service",
                                        NotificationManager.IMPORTANCE_LOW
                                )
                        getSystemService(NotificationManager::class.java)
                                .createNotificationChannel(channel)
                }

                return NotificationCompat.Builder(this, channelId)
                        .setContentTitle("Taking Screenshot")
                        .setContentText("Capturing the screen…")
                        .setSmallIcon(android.R.drawable.ic_menu_camera)
                        .build()
        }

        private fun takeScreenshotNow() {
                
                val metrics = Resources.getSystem().displayMetrics
                val width = metrics.widthPixels
                val height = metrics.heightPixels
                val density = metrics.densityDpi

                
                handlerThread = HandlerThread("ScreenshotThread").apply { start() }
                handler = Handler(handlerThread!!.looper)

                imageReader =
                        ImageReader.newInstance(
                                width,
                                height,
                                PixelFormat.RGBA_8888, 
                                2
                        )

                
                imageReader!!.setOnImageAvailableListener(
                        { reader ->
                                if (timedOut) return@setOnImageAvailableListener
                                val image: Image =
                                        reader.acquireLatestImage()
                                                ?: return@setOnImageAvailableListener
                                try {
                                        val plane = image.planes[0]
                                        val buffer = plane.buffer
                                        val pixelStride = plane.pixelStride
                                        val rowStride = plane.rowStride
                                        val rowPadding = rowStride - pixelStride * width

                                        val bitmap =
                                                Bitmap.createBitmap(
                                                        width + rowPadding / pixelStride,
                                                        height,
                                                        Bitmap.Config.ARGB_8888
                                                )
                                        bitmap.copyPixelsFromBuffer(buffer)

                                        val cropped =
                                                Bitmap.createBitmap(bitmap, 0, 0, width, height)

                                        
                                        val timestamp = SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US).format(Date())
                                        val outFile =
                                                File(
                                                        getExternalFilesDir(
                                                                android.os.Environment
                                                                        .DIRECTORY_PICTURES
                                                        ),
                                                        "screenshot_$timestamp.png"
                                                )
                                        FileOutputStream(outFile).use {
                                                cropped.compress(Bitmap.CompressFormat.PNG, 100, it)
                                        }
                                        Log.d(
                                                "ScreenshotService",
                                                "Screenshot saved: ${outFile.absolutePath}"
                                        )
                                        val broadcastIntent = Intent("SCREENSHOT_TAKEN")
                                        broadcastIntent.putExtra("path", outFile.absolutePath)
                                        sendBroadcast(broadcastIntent) 

                                        
                                } catch (t: Throwable) {
                                        Log.e("ScreenshotService", "Saving screenshot failed", t)
                                        
                                        val broadcastIntent = Intent("SCREENSHOT_TAKEN")
                                        sendBroadcast(broadcastIntent) 
                                } finally {
                                        
                                        try {
                                                image.close()
                                        } catch (_: Throwable) {}
                                        cleanup()
                                }
                        },
                        handler
                )

                
                virtualDisplay =
                        mediaProjection?.createVirtualDisplay(
                                "screenshot",
                                width,
                                height,
                                density,
                                DisplayManager.VIRTUAL_DISPLAY_FLAG_AUTO_MIRROR,
                                imageReader!!.surface,
                                null,
                                null
                        )

                
                handler?.postDelayed(
                        {
                                if (virtualDisplay != null && imageReader != null) {
                                        timedOut = true
                                        Log.w(
                                                "ScreenshotService",
                                                "Timed out waiting for first frame; cleaning up."
                                        )
                                        cleanup()
                                }
                        },
                        3000
                )
        }

        private fun cleanup() {
                try {
                        virtualDisplay?.release()
                } catch (_: Throwable) {}
                virtualDisplay = null

                try {
                        imageReader?.close()
                } catch (_: Throwable) {}
                imageReader = null

                try {
                        mediaProjection?.stop()
                } catch (_: Throwable) {}
                mediaProjection = null

                try {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                                stopForeground(Service.STOP_FOREGROUND_REMOVE)
                        } else {
                                @Suppress("DEPRECATION") stopForeground(true)
                        }
                } catch (_: Throwable) {}

                try {
                        handlerThread?.quitSafely()
                } catch (_: Throwable) {}
                handler = null
                handlerThread = null

                stopSelf()
        }

        override fun onBind(intent: Intent?) = null
}
