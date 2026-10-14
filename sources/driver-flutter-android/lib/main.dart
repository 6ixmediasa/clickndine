import 'dart:async';
import 'package:stackfood_multivendor_driver/feature/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor_driver/feature/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_driver/common/controllers/theme_controller.dart';
import 'package:stackfood_multivendor_driver/feature/notification/domain/models/notification_body_model.dart';
import 'package:stackfood_multivendor_driver/helper/notification_helper.dart';
import 'package:stackfood_multivendor_driver/helper/route_helper.dart';
import 'package:stackfood_multivendor_driver/theme/dark_theme.dart';
import 'package:stackfood_multivendor_driver/theme/light_theme.dart';
import 'package:stackfood_multivendor_driver/util/app_constants.dart';
import 'package:stackfood_multivendor_driver/util/messages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'helper/get_di.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(const DriverBootstrapApp());
}

class DriverBootstrapApp extends StatefulWidget {
  const DriverBootstrapApp({super.key});

  @override
  State<DriverBootstrapApp> createState() => _DriverBootstrapAppState();
}

class _DriverBootstrapAppState extends State<DriverBootstrapApp> {
  Map<String, Map<String, String>>? _languages;
  NotificationBodyModel? _body;
  String? _startupError;
  bool _ready = false;
  bool _starting = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    if (_starting) return;
    setState(() {
      _starting = true;
      _startupError = null;
    });

    try {
      final languages = await di.init().timeout(const Duration(seconds: 15));

      try {
        await Firebase.initializeApp().timeout(const Duration(seconds: 8));
      } catch (e) {
        debugPrint('Firebase startup warning: $e');
      }

      NotificationBodyModel? body;
      try {
        if (GetPlatform.isMobile && Firebase.apps.isNotEmpty) {
          final RemoteMessage? remoteMessage = await FirebaseMessaging.instance
              .getInitialMessage()
              .timeout(const Duration(seconds: 4), onTimeout: () => null);
          if (remoteMessage != null) {
            body = NotificationHelper.convertNotification(remoteMessage.data);
          }
          await NotificationHelper.initialize(flutterLocalNotificationsPlugin)
              .timeout(const Duration(seconds: 4));
          FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
        }
      } catch (e) {
        debugPrint('Notification startup warning: $e');
      }

      if (!mounted) return;
      setState(() {
        _languages = languages;
        _body = body;
        _ready = true;
        _starting = false;
      });
    } catch (e, stack) {
      debugPrint('ClicKnDine Driver startup failed: $e\n$stack');
      if (!mounted) return;
      setState(() {
        _startupError = e.toString();
        _starting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ready && _languages != null) {
      return MyApp(languages: _languages, body: _body);
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'ClicKnDine Driver',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFED1C24),
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_startupError == null) ...[
                    const CircularProgressIndicator(color: Color(0xFFED1C24)),
                    const SizedBox(height: 18),
                    const Text(
                      'Starting driver app…',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black87),
                    ),
                  ] else ...[
                    const Icon(Icons.error_outline, color: Color(0xFFED1C24), size: 42),
                    const SizedBox(height: 12),
                    const Text(
                      'The driver app could not finish startup.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      _startupError!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                    const SizedBox(height: 18),
                    FilledButton(
                      onPressed: _starting ? null : _start,
                      style: FilledButton.styleFrom(backgroundColor: const Color(0xFFED1C24)),
                      child: const Text('Retry'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>>? languages;
  final NotificationBodyModel? body;
  const MyApp({super.key, required this.languages, required this.body});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return GetBuilder<SplashController>(builder: (splashController) {
          return GetMaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            navigatorKey: Get.key,
            theme: themeController.darkTheme ? dark : light,
            locale: localizeController.locale,
            translations: Messages(languages: languages),
            fallbackLocale: Locale(AppConstants.languages[0].languageCode!, AppConstants.languages[0].countryCode),
            initialRoute: RouteHelper.getSplashRoute(body),
            getPages: RouteHelper.routes,
            defaultTransition: Transition.topLevel,
            transitionDuration: const Duration(milliseconds: 500),
            builder: (BuildContext context, widget) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                child: Material(
                  color: Colors.white,
                  child: SafeArea(
                    top: false,
                    bottom: GetPlatform.isAndroid,
                    child: Stack(children: [widget!]),
                  ),
                ),
              );
            },
          );
        });
      });
    });
  }
}
