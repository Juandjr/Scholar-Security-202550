import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps_adv/blocs/auth/auth_bloc.dart';
import 'package:flutter_maps_adv/helpers/mostrar_alerta.dart';
import 'package:flutter_maps_adv/screens/screens.dart';
import 'package:flutter_maps_adv/widgets/boton_login.dart';
import 'package:flutter_maps_adv/widgets/custom_input.dart';
import 'package:flutter_maps_adv/widgets/labels_login.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterScreen extends StatelessWidget {
  static const String registerroute = 'register';

  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              margin: const EdgeInsets.all(30),
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: 170,
                        height: 170,
                        child: SvgPicture.asset(
                          'assets/iconvinculacion/login.svg',
                        )),
                    const _From(),
                    const Labels(
                        ruta: 'login',
                        text: "¿Ya tienes cuenta?",
                        text2: "Ingresa"),
                    const SizedBox(height: 10),
                    const Text("Terminos y condiciones de uso",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(0, 0, 0, 0.782)))
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _From extends StatefulWidget {
  const _From();

  @override
  State<_From> createState() => __FromState();
}

class __FromState extends State<_From> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  bool _obscurePassword = true;
  String? unidadEducativa = '';
  List<DropdownMenuItem<String>> dropdownItems = [];

  AuthBloc authServiceBloc = AuthBloc();

  @override
  void initState() {
    super.initState();
    authServiceBloc = BlocProvider.of<AuthBloc>(context, listen: false);
    _loadInstituciones();
  }

  Future<void> _loadInstituciones() async {
    final institucionesList = await authServiceBloc.obtenerTodasLasInstituciones();
    setState(() {
      dropdownItems = institucionesList.map((institucion) {
        return DropdownMenuItem<String>(
          value: institucion.nombre,
          child: Text(institucion.nombre, style: const TextStyle(color: Colors.black54)),
        );
      }).toList();
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CustonInput(
        icon: Icons.perm_identity,
        placeholder: "Nombres",
        textController: nomController,
      ),
      CustonInput(
        icon: Icons.mail_outline,
        placeholder: "Email",
        keyboardType: TextInputType.emailAddress,
        textController: emailController,
      ),
      CustonInput(
        icon: Icons.lock_outline,
        placeholder: "Password",
        textController: passwordController,
        isPassword: true,
        obscurePassword: _obscurePassword,
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
      Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, offset: Offset(0, 5), blurRadius: 5)
            ]),
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Color(0xFF7ab466)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Color(0xFF7ab466)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Color(0xFF7ab466)),
            ),
            hintText: 'Unidad educativa afiliada',
            labelText: 'Unidad educativa afiliada',
            labelStyle: const TextStyle(color: Colors.black54),
            prefixIcon: const Icon(Icons.person, color: Color(0xFF7ab466)),
          ),
          items: dropdownItems,
          onChanged: (opt) {
            setState(() {
              unidadEducativa = opt;
            });
          },
        ),
      ),
      BotonForm(
        text: "Crear cuenta",
        onPressed: authServiceBloc.isLoggedInTrue
            ? () {}
            : () async {
                FocusScope.of(context).unfocus();

                String nombre = nomController.text.trim();
                String email = emailController.text.trim();
                String password = passwordController.text.trim();

                if (nombre.isEmpty || email.isEmpty || password.isEmpty) {
                  mostrarAlerta(context, 'Campos vacíos',
                      'Todos los campos son obligatorios');
                  return;
                }

                if (!isValidEmail(email)) {
                  mostrarAlerta(context, 'Correo electrónico inválido',
                      'Ingrese un correo electrónico válido');
                  return;
                }

                if (password.length < 6) {
                  mostrarAlerta(context, 'Contraseña inválida',
                      'La contraseña debe tener al menos 6 caracteres');
                  return;
                }

                if (!containsNumber(password)) {
                  mostrarAlerta(context, 'Contraseña inválida',
                      'La contraseña debe contener al menos un número');
                  return;
                }

                if (!containsUppercaseLetter(password)) {
                  mostrarAlerta(context, 'Contraseña inválida',
                      'La contraseña debe contener al menos una letra en mayúscula');
                  return;
                }

                if (unidadEducativa == '') {
                  mostrarAlerta(context, 'Unidad no seleccionada',
                      'Seleccione una unidad educativa afiliada');
                  return;
                }

                final resulta = await authServiceBloc.register(
                    nombre, email, password, unidadEducativa ?? '');

                if (!resulta) {
                  mostrarAlerta(context, 'Correo electrónico en uso',
                      'El correo electrónico ya está en uso');
                  return;
                }

                if (authServiceBloc.isLoggedInTrue) {
                  Navigator.pushReplacementNamed(
                      context, LoadingLoginScreen.loadingroute);
                } else {
                  mostrarAlerta(context, 'Registro incorrecto',
                      'Revise sus credenciales nuevamente');
                }
              },
      )
    ]);
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');

    return emailRegex.hasMatch(email);
  }

  bool containsNumber(String password) {
    return password.contains(RegExp(r'\d'));
  }

  bool containsUppercaseLetter(String password) {
    return password.contains(RegExp(r'[A-Z]'));
  }
}