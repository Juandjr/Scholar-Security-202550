import 'package:flutter/material.dart';
import 'package:flutter_maps_adv/widgets/custom_bottom_navigation.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AcercadeScreen extends StatelessWidget {
  static const salesroute = 'acercade';

  const AcercadeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Center(
                child: Text(
                  'Sobre la aplicación',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 16),
              const Text(
                'Esta aplicación permite a los usuarios reportar y observar emergencias en las Unidades Educativas “Puerto Limón” y “El Esfuerzo”.',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              const Text(
                'Desarrollada con Flutter y MongoDB, y alojada en el servidor de la Universidad de las Fuerzas Armadas ESPE.',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 270,
                height: 270,
                child: SvgPicture.asset(
                  'assets/iconvinculacion/logo_movil.svg',
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          const CustomBottomNavigation(), // Asegúrate de que esta clase esté definida e importada correctamente
    );
  }
}
