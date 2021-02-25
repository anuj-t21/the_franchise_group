import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:the_franchise_group/providers/user_details.dart';
import 'package:the_franchise_group/screens/edit_user_details.dart';
import 'package:the_franchise_group/screens/home_screen.dart';
import 'package:the_franchise_group/screens/splash_screen.dart';
import './providers/auth.dart';
import 'package:the_franchise_group/screens/auth_screen.dart';
import 'package:the_franchise_group/screens/intro_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  static const MaterialColor my_color = const MaterialColor(
    0xff3c5f84,
    const <int, Color>{
      50: const Color(0xff3c5f84),
      100: const Color(0xff3c5f84),
      200: const Color(0xff3c5f84),
      300: const Color(0xff3c5f84),
      400: const Color(0xff3c5f84),
      500: const Color(0xff3c5f84),
      600: const Color(0xff3c5f84),
      700: const Color(0xff3c5f84),
      800: const Color(0xff3c5f84),
      900: const Color(0xff3c5f84),
    },
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, UserDetails>(
          update: (ctx, auth, previousAddress) => UserDetails(
            auth.userId,
            previousAddress == null ? null : previousAddress.user,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorObservers: [routeObserver],
          title: 'The Franchise Group',
          theme: ThemeData(
            primarySwatch: MyApp.my_color,
            accentColor: Color(0xfff1bc4d),
            indicatorColor: Color(0xffe77805),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home:
//          !auth.isFirst
//              ?
              auth.isAuth
                  ? FutureBuilder(
                      future: auth.tryIntro(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : auth.isFirst
                                  ? IntroScreen()
                                  : HomeScreen())
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen()
//                          auth.isFirst
//                                  ? IntroScreen()
//                                  : AuthScreen(),
                      )
//              : IntroScreen()
          ,
          routes: {
            HomeScreen.routeName: (ctx) => HomeScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
            EditUserDetailsScreen.routeName: (ctx) => EditUserDetailsScreen(),
          },
        ),
      ),
    );
  }
}
