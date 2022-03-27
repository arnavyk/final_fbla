import 'package:beamer/src/beamer.dart';
import 'package:final_fbla/constants/constants.dart';
import 'package:final_fbla/constants/style_constants.dart';
import 'package:final_fbla/providers/auth_provider.dart';
import 'package:final_fbla/screens/screens.dart';
import 'package:final_fbla/services/auth_service.dart';
import 'package:final_fbla/widgets/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

// The first screen the user is taken to as soon as the open the app
class RootScreen extends StatelessWidget {
  static const String route = '/';
  bool _initialized = false;
  RootScreen({Key? key}) : super(key: key) {}

  void init(BuildContext context) {
    _initialized = true;
    AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);
    if (provider.user != null && !provider.user!.emailVerified) {
      AuthService.logout().then((value) {
        FlutterNativeSplash.remove();
        context.beamToNamed(Login.route);
      });
    } else {
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        FlutterNativeSplash.remove();

        if (provider.isAuthenticated) {
          context.beamToNamed(HomeScreen.route);
        } else if (!provider.isLoggedIn) {
          context.beamToNamed(Login.route);
        } else {
          context.beamToNamed(VerifyEmail.route);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!StyleConstants.initialized) {
      StyleConstants().init(context);
    }
    if (!_initialized) {
      init(context);
    }

    return Screen(
      left: false,
      right: false,
      top: false,
      bottom: false,
      includeHeader: false,
      includeBottomNav: false,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.shade400,
              Colors.green.shade800,
            ],
          ),
        ),
      ),
    );
  }
}
