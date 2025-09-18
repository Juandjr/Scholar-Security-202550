import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_maps_adv/global/environment.dart';
import 'package:flutter_maps_adv/resources/services/auth_provider.dart';

class SosTestHelper {
  /// Método para probar directamente el endpoint de notificaciones SOS
  static Future<Map<String, dynamic>> testSosEndpoint(double lat, double lng) async {
    try {
      print('🧪 === INICIANDO PRUEBA DEL ENDPOINT SOS ===');

      // Obtener token de autenticación
      final token = await AuthService.getToken();
      print('🔐 Token de autorización: ${token != null ? 'Disponible' : 'NO DISPONIBLE'}');

      if (token == null) {
        return {
          'success': false,
          'error': 'No hay token de autenticación',
          'details': 'Usuario no está logueado'
        };
      }

      // Preparar datos
      final data = {
        'lat': lat,
        'lng': lng,
      };

      print('📍 Coordenadas a enviar:');
      print('   - Latitud: $lat');
      print('   - Longitud: $lng');

      // Construir URI
      final uri = Uri.parse('${Environment.apiUrl}/usuarios/notificacion');
      print('🌐 Endpoint: $uri');

      // Realizar petición HTTP
      print('📡 Enviando petición HTTP...');
      final resp = await http.post(
          uri,
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json',
            'x-token': token,
          }
      );

      print('📨 Respuesta recibida:');
      print('   - Status Code: ${resp.statusCode}');
      print('   - Headers: ${resp.headers}');
      print('   - Body: ${resp.body}');

      // Analizar respuesta
      Map<String, dynamic> result = {
        'success': resp.statusCode == 200,
        'statusCode': resp.statusCode,
        'headers': resp.headers,
        'rawBody': resp.body,
      };

      try {
        final responseBody = jsonDecode(resp.body);
        result['parsedBody'] = responseBody;
        print('📋 Body parseado: $responseBody');
      } catch (e) {
        print('⚠️ No se pudo parsear el body como JSON: $e');
        result['parseError'] = e.toString();
      }

      if (resp.statusCode == 200) {
        print('✅ PRUEBA EXITOSA: El endpoint respondió correctamente');
      } else {
        print('❌ PRUEBA FALLIDA: El endpoint devolvió error ${resp.statusCode}');
      }

      print('🧪 === FIN DE LA PRUEBA DEL ENDPOINT SOS ===');

      return result;

    } catch (e) {
      print('💥 ERROR DURANTE LA PRUEBA: $e');
      return {
        'success': false,
        'error': 'Error de conexión',
        'details': e.toString()
      };
    }
  }

  /// Método para verificar la configuración de Firebase
  static void checkFirebaseConfig() {
    print('🔥 === VERIFICANDO CONFIGURACIÓN FIREBASE ===');

    // Verificar si existe el archivo google-services.json
    print('📄 Verificando google-services.json...');
    print('   - Ruta esperada: android/app/google-services.json');
    print('   - Estado: Debe existir para que Firebase funcione');

    print('🔥 === FIN VERIFICACIÓN FIREBASE ===');
  }

  /// Método para mostrar información de debugging completa
  static void showDebugInfo() {
    print('🐛 === INFORMACIÓN DE DEBUG COMPLETA ===');
    print('🌍 Environment:');
    print('   - API URL: ${Environment.apiUrl}');
    print('   - Socket URL: ${Environment.socketUrl}');

    checkFirebaseConfig();

    print('📱 Siguiente paso recomendado:');
    print('   1. Verificar que el backend esté funcionando');
    print('   2. Probar el endpoint con Postman o similar');
    print('   3. Verificar los logs del servidor');
    print('   4. Confirmar que Firebase esté configurado correctamente');

    print('🐛 === FIN DEBUG INFO ===');
  }
}