import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/blocs.dart';
import 'package:flutter_maps_adv/screens/screens.dart';
import 'package:flutter_maps_adv/widgets/custom_bottom_navigation.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fluttertoast/fluttertoast.dart'; // Asegúrate de importar los paquetes necesarios

class HomeScreen extends StatefulWidget {
  static const String homeroute = 'home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime currentBackPressTime = DateTime.now();

  // Método para manejar la lógica de doble presión
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Presiona nuevamente para salir");
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final publicationBloc = BlocProvider.of<PublicationBloc>(context);
    BlocProvider.of<AuthBloc>(context);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop:
          onWillPop, // Llamamos al método onWillPop definido anteriormente
      child: Scaffold(
        body: Stack(
          children: [
            // Añade el saludo "Hola" aquí:

            const Positioned(
              top: 90,
              left: 16,
              child: SizedBox(
                width: 330,
                height: 270,
                child: Text(
                  'Desarrollada con Flutter y MongoDB, y alojada en el servidor de la Universidad de las Fuerzas Armadas ESPE.', // Añade el saludo aquí
                  style: TextStyle(
                    fontSize: 20,

                    color: Colors.black,

                    // Cambia el color según tu preferencia
                  ),
                ),
              ),
            ),
            Positioned(
              top: 60, // Ajusta la posición vertical según sea necesario
              left: 45,
              child: SizedBox(
                width: 270,
                height: 800,
                child: SvgPicture.asset(
                  'assets/iconvinculacion/logo_movil.svg',
                  // Ajusta el tamaño según sea necesario
                ),
              ),
            ),

            BlocBuilder<NavigatorBloc, NavigatorStateInit>(
              builder: (context, state) {
                return IndexedStack(
                  index: state.index,
                  children: [
                    // Si tu counterBloc está activo, puedes agregar aquí el widget correspondiente
                    // Center(child: Text("Home")),
                    const LoadingMapScreen(),
                    NewsScreen(onNewPublication: () async {
                      await publicationBloc.getNextPublicaciones();
                    }),

                    // GruposScreen(),
                    const RoomsScreen(),
                    const PerfilScreen(),

                    // Center(
                    //     child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [ConfigScreen()])),
                  ],
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: const CustomBottomNavigation(),
      ),
    );
  }
}
