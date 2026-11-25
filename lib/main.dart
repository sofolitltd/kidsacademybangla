import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '/core/router/router.dart';
import '/core/services/ad_service.dart';
import '/core/services/age_service.dart';

// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // CRITICAL FOR KIDS APPS
  RequestConfiguration configuration = RequestConfiguration(
    ageRestrictedTreatment: AgeRestrictedTreatment.child,
    maxAdContentRating: MaxAdContentRating.g,
    // testDeviceIds: ["YOUR_DEVICE_ADVERTISING_ID"],
  );
  // Set before initialize() so every ad request carries these settings.
  await MobileAds.instance.updateRequestConfiguration(configuration);
  await MobileAds.instance.initialize();

  AdService.instance.init();
  await AgeService.load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Kids Academy Bangla',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.anekBanglaTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
    );
  }
}
