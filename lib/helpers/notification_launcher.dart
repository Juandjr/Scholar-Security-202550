import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_maps_adv/models/notification.dart';

class NotificationLauncher {
  static const MethodChannel _channel =
  MethodChannel('com.paulogalarza.scholarsecurity/notification');

  /// Obtiene los datos de notificación si la app se abrió desde una notificación
  static Future<Map<String, dynamic>?> getInitialNotification() async {
    try {
      final result = await _channel.invokeMethod('getNotificationData');
      if (result != null && result is Map<String, dynamic>) {
        return Map<String, dynamic>.from(result);
      }
    } on PlatformException catch (e) {
      print('Error getting initial notification: ${e.message}');
    }
    return null;
  }

  /// Procesa los datos de notificación SOS y retorna el objeto Notificacione
  static Notificacione? processSosNotification(Map<String, dynamic> notificationData) {
    try {
      final String? type = notificationData['type'];
      final String? dataString = notificationData['data'];

      if (type == 'sos' && dataString != null) {
        final Map<String, dynamic> data = jsonDecode(dataString);

        // Construir el objeto Notificacione desde los datos
        final notificationJson = {
          'tipo': 'sos',
          'usuarioRemitente': data['usuarioRemitente'],
          'mensaje': data['mensaje'] ?? '¡Urgente! Contacto necesita ayuda',
          'latitud': data['latitud'],
          'longitud': data['longitud'],
          'createdAt': data['createdAt'] ?? DateTime.now().toIso8601String(),
          'updatedAt': data['updatedAt'] ?? DateTime.now().toIso8601String(),
          'uid': data['uid'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
          'usuario': data['usuario'],
          'isLeida': false,
        };

        return Notificacione.fromJson(notificationJson);
      }
    } catch (e) {
      print('Error processing SOS notification: $e');
    }
    return null;
  }
}