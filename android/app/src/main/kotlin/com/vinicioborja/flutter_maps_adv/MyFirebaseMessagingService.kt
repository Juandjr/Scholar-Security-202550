package com.paulogalarza.scholarsecurity

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.media.RingtoneManager
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import org.json.JSONObject

class MyFirebaseMessagingService : FirebaseMessagingService() {

    private val TAG = "FCM Service"

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        Log.d(TAG, "From: ${remoteMessage.from}")

        // Verificar si el mensaje contiene datos
        if (remoteMessage.data.isNotEmpty()) {
            Log.d(TAG, "Message data payload: ${remoteMessage.data}")

            try {
                val dataString = remoteMessage.data["data"]
                if (dataString != null) {
                    val dataJson = JSONObject(dataString)
                    val type = dataJson.optString("type")

                    when (type) {
                        "sos" -> {
                            val usuario = dataJson.optJSONObject("usuarioRemitente")
                            val nombre = usuario?.optString("nombre") ?: "Usuario desconocido"
                            val latitud = dataJson.optDouble("latitud", 0.0)
                            val longitud = dataJson.optDouble("longitud", 0.0)

                            sendSosNotification(nombre, latitud, longitud, dataString)
                        }
                        "publication" -> {
                            // Manejar notificaciones de publicaciones si es necesario
                            sendGenericNotification("Nueva publicación", "Se ha creado una nueva publicación")
                        }
                        "sala" -> {
                            // Manejar notificaciones de sala si es necesario
                            sendGenericNotification("Mensaje de sala", "Nuevo mensaje en sala")
                        }
                    }
                }
            } catch (e: Exception) {
                Log.e(TAG, "Error parsing notification data: ${e.message}")
            }
        }

        // Verificar si el mensaje contiene una notificación
        remoteMessage.notification?.let {
            Log.d(TAG, "Message Notification Body: ${it.body}")
            sendGenericNotification(it.title ?: "Notificación", it.body ?: "Nueva notificación")
        }
    }

    private fun sendSosNotification(nombre: String, latitud: Double, longitud: Double, dataString: String) {
        val intent = Intent(this, MainActivity::class.java)
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
        intent.putExtra("notification_type", "sos")
        intent.putExtra("notification_data", dataString)

        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            intent,
            PendingIntent.FLAG_ONE_SHOT or PendingIntent.FLAG_IMMUTABLE
        )

        val channelId = "sos_notifications"
        val defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)

        val notificationBuilder = NotificationCompat.Builder(this, channelId)
            .setSmallIcon(R.mipmap.launcher_icon)
            .setContentTitle("🚨 ALERTA SOS")
            .setContentText("$nombre necesita ayuda urgente! Toca para ver ubicación")
            .setAutoCancel(true)
            .setSound(defaultSoundUri)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setVibrate(longArrayOf(0, 1000, 500, 1000, 500, 1000))
            .setContentIntent(pendingIntent)
            .setStyle(NotificationCompat.BigTextStyle()
                .bigText("¡EMERGENCIA! $nombre está pidiendo ayuda. Latitud: $latitud, Longitud: $longitud. Toca para ver su ubicación en el mapa."))

        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        // Crear canal de notificación para Android O y versiones superiores
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Notificaciones SOS",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Notificaciones de emergencia SOS"
                enableVibration(true)
                vibrationPattern = longArrayOf(0, 1000, 500, 1000, 500, 1000)
                setSound(defaultSoundUri, null)
            }
            notificationManager.createNotificationChannel(channel)
        }

        notificationManager.notify(System.currentTimeMillis().toInt(), notificationBuilder.build())
    }

    private fun sendGenericNotification(title: String, body: String) {
        val intent = Intent(this, MainActivity::class.java)
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)

        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            intent,
            PendingIntent.FLAG_ONE_SHOT or PendingIntent.FLAG_IMMUTABLE
        )

        val channelId = "general_notifications"
        val defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)

        val notificationBuilder = NotificationCompat.Builder(this, channelId)
            .setSmallIcon(R.mipmap.launcher_icon)
            .setContentTitle(title)
            .setContentText(body)
            .setAutoCancel(true)
            .setSound(defaultSoundUri)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .setContentIntent(pendingIntent)

        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        // Crear canal de notificación para Android O y versiones superiores
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Notificaciones Generales",
                NotificationManager.IMPORTANCE_DEFAULT
            ).apply {
                description = "Notificaciones generales de la aplicación"
            }
            notificationManager.createNotificationChannel(channel)
        }

        notificationManager.notify(0, notificationBuilder.build())
    }

    override fun onNewToken(token: String) {
        Log.d(TAG, "Refreshed token: $token")
        // Aquí podrías enviar el token al servidor si es necesario
        sendRegistrationToServer(token)
    }

    private fun sendRegistrationToServer(token: String) {
        // Implementar envío del token al servidor si es necesario
        Log.d(TAG, "Token sent to server: $token")
    }
}