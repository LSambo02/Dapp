import 'package:despensa/main.dart';
import 'package:despensa/services/auth_service.dart';
import 'package:despensa/services/notification_service.dart';
import 'package:despensa/utils/AppPhoneSize.dart';
import 'package:despensa/utils/GetIt.dart';
import 'package:despensa/utils/constantes.dart';
import 'package:despensa/widgets/dapp_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:universal_platform/universal_platform.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  NotificationService notificationService = NotificationService();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  SystemUiOverlayStyle _currentStyle = SystemUiOverlayStyle.dark;
  @override
  void initState() {
    if (!UniversalPlatform.isWeb) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher',
                ),
              ));
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('A new onMessageOpenedApp event was published!');
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Text(notification.title!),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(notification.body!)],
                    ),
                  ),
                );
              });
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: _currentStyle,
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage('assets/bg/grocery.png'),
                    fit: BoxFit.cover,
                  )),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: heightScreen(context) / 4,
                  ),
                  DappText(),
                  SizedBox(
                    height: heightScreen(context) / 6,
                  ),
                  // Form(
                  //     child: Column(
                  //   children: [
                  //     Container(
                  //       width: widthScreen(context) / 1.2,
                  //       child: TextFormField(
                  //         controller: emailController,
                  //         decoration: InputDecoration(
                  //           border: OutlineInputBorder(),
                  //           labelText: "Email",
                  //         ),
                  //       ),
                  //     ),
                  //     Container(
                  //       margin: EdgeInsets.only(top: 10),
                  //       width: widthScreen(context) / 1.2,
                  //       child: TextFormField(
                  //         controller: passwordController,
                  //         decoration: InputDecoration(
                  //             border: OutlineInputBorder(), labelText: "Password"),
                  //       ),
                  //     ),
                  //   ],
                  // )),
                  // SizedBox(
                  //   height: 30,
                  // ),
                  // Container(
                  //   width: 150,
                  //   margin: EdgeInsets.only(bottom: 15),
                  //   child: ElevatedButton(
                  //     child: Text(
                  //       'ENTRAR',
                  //       style: TextStyle(color: Colors.blueGrey[400]),
                  //     ),
                  //     onPressed: () => getIt<AuthService>()
                  //         .signIn(emailController.text, passwordController.text)
                  //         .whenComplete(() {})
                  //         .then((value) {
                  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //         content: Text(value),
                  //       ));
                  //
                  //       notificationService.askPermission();
                  //       if (getIt<AuthService>().isEmailVerified())
                  //         Navigator.pushNamed(context, family_screen);
                  //     }),
                  //     style: ElevatedButton.styleFrom(
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Text("OR"),
                  Container(
                      child: Text(
                    'Bem-vindo ao Dapp,\nNunca foi tão prático manter despensa organizada',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  )),
                  Center(
                    child: Container(
                      width: widthScreen(context) / 1.5,
                      margin: EdgeInsets.only(top: 15),
                      child: SignInButton(
                        Buttons.Google,
                        onPressed: () => kIsWeb
                            ? getIt<AuthService>()
                                .signInWithGoogleWeb()
                                .whenComplete(() {})
                                .then((value) {
                                print(value);
                                setState(() {
                                  // _isLoadingGSignIn = false;
                                  // _isDoneSignIn = true;
                                  // _message = value;
                                });
                                notificationService.askPermission();
                                value.contains('Erro ao autenticar conta')
                                    ? null
                                    : goToFamilyScreen();
                              })
                            : getIt<AuthService>()
                                .signInWithGoogle()
                                .whenComplete(() {})
                                .then((value) {
                                print(value);
                                setState(() {
                                  // _isLoadingGSignIn = false;
                                  // _isDoneSignIn = true;
                                  // _message = value;
                                });
                                notificationService.askPermission();
                                goToFamilyScreen();
                              }),
                        text: 'ENTRAR COM GOOGLE',
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  // TextButton(
                  //     onPressed: () => Navigator.pushNamed(context, signup_screen),
                  //     child: Text(
                  //       'Not Registered yet? Sign Up!',
                  //       style: TextStyle(color: Colors.black45),
                  //     ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  goToFamilyScreen() {
    Navigator.pushNamed(context, dashboard_screen);
  }
}
