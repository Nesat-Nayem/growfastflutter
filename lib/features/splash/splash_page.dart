import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grow_first/app/router/app_router_name.dart';
import 'package:grow_first/core/storage/secure_storage.dart';
import 'package:grow_first/core/utils/app_assets.dart';
import 'package:grow_first/features/listing/di/listing_injections.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  @override
  void initState() {
    super.initState();
    _navigateTo();
  }

  Future<void> _navigateTo() async {
    await Future.delayed(const Duration(seconds: 2));

    final isLoggedIn = await sl<ISecureStore>().read("isLoggedIn") == "true";

    if (!mounted) return;

    if (isLoggedIn) {
      context.goNamed(AppRouterNames.home);
    } else {
      context.goNamed(AppRouterNames.signIn);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(AssetImage("assets/svg/splash_logo_png.png"), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentGeometry.centerRight,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFD6FEFF), Color(0xFFFFFFFF)],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          Opacity(
            opacity: 0.07,
            child: Image.asset(
              "assets/images/splash_pattern2.png",
              height: MediaQuery.sizeOf(context).height,
              colorBlendMode: BlendMode.screen,
              fit: BoxFit.fitHeight,
            ),
          ),
          Column(
            crossAxisAlignment: .center,
            mainAxisAlignment: .center,
            children: [
              Center(
                child: Image.asset(
                  "assets/svg/splash_logo_png.png",
                  height: 75,
                ),
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: SvgPicture.asset(
              AppAssets.splashArtSvg,
              alignment: Alignment.centerRight,
            ),
          ),
        ],
      ),
    );
  }
}
