import 'dart:io';

// class Environment {
//   static String apiUrl = Platform.isAndroid
//       ? 'http://192.168.2.104:4444/api/v2'
//       : 'http://localhost:4444/api';
//   static String socketUrl = Platform.isAndroid
//       ? 'http://192.168.2.104:4444'
//       : 'http://localhost:4444';
// }


class Environment {
  static String apiUrl = Platform.isAndroid
      ? 'http://192.188.58.35:3000/api/v2'
      : 'http://localhost:3000/api';
  static String socketUrl = Platform.isAndroid
      ? 'http://192.188.58.35:3000'
      : 'http://localhost:3000';
}

/*class Environment {
  static String apiUrl = Platform.isAndroid
      ? 'https://backend-pract2.onrender.com/api/v2'
      : 'http://192.188.58.35:3000/api/v2';
  static String socketUrl = Platform.isAndroid
      ? 'https://backend-pract2.onrender.com/api/v2'
      : 'http://localhost:3000';
}
*/
/*class Environment {
  static String apiUrl = Platform.isAndroid
      ? 'http://192.168.1.10:3000/api/v2'
      : 'http://10.3.1.203:3000/api/v2';
  static String socketUrl = Platform.isAndroid
      ? 'http://192.168.1.10:3000/api/v2'
      : 'http://localhost:3000';
}*/
