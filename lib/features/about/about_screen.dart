import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/config/developer_info.dart';
import '../home/widgets/home_reveal.dart';
import 'package:kidsacademybangla/core/config/app_urls.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const Color _accent = Color(0xFFFF7F50);
  static const Color _ink = Color(0xFF3D2A1E);

  static const String _story =
      'কিডস একাডেমি বাংলা শুরু হয়েছে একটি ছোট্ট স্বপ্ন থেকে — আমাদের শিশুরা যেন '
      'বাংলা, ইংরেজি, আরবি আর ইসলামের প্রথম পাঠ খেলার ছলে, আনন্দের সাথে শিখতে পারে।\n\n'
      'স্ক্রিনে সময় কাটানো এখন প্রায় অনিবার্য। তাই আমরা চেয়েছি সেই সময়টুকু যেন '
      'হয় শেখার সময় — রঙিন ছবি, মজার শব্দ আর নিজের নাম-পরিচয় শেখার মধ্য দিয়ে।\n\n'
      'এই অ্যাপ আপনার সন্তানের জন্য, আপনাদের ভালোবাসা আর পরামর্শ নিয়েই এগিয়ে চলছে। '
      'ভালো লাগলে রেটিং দিয়ে পাশে থাকুন। ❤️';

  Future<void> _open(BuildContext context, String url) async {
    final ok = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('খোলা যায়নি')));
    }
  }

  Future<void> _rate(BuildContext context) async {
    final market = Uri.parse(
      AppUrls.playStoreMarket(DeveloperInfo.playStorePackage),
    );
    if (await launchUrl(market, mode: LaunchMode.externalApplication)) return;
    if (!context.mounted) return;
    await _open(context, AppUrls.playStoreWeb(DeveloperInfo.playStorePackage));
  }

  @override
  Widget build(BuildContext context) {
    final contacts = <_Contact>[
      if (DeveloperInfo.email.isNotEmpty)
        _Contact(
          Icons.mail_rounded,
          'ইমেইল',
          DeveloperInfo.email,
          'mailto:${DeveloperInfo.email}?subject=Kids Academy Bangla',
        ),
      if (DeveloperInfo.phone.isNotEmpty)
        _Contact(
          Icons.call_rounded,
          'ফোন',
          DeveloperInfo.phone,
          'tel:${DeveloperInfo.phone}',
        ),
      if (DeveloperInfo.whatsapp.isNotEmpty)
        _Contact(
          Icons.chat_rounded,
          'হোয়াটসঅ্যাপ',
          DeveloperInfo.phone,
          AppUrls.whatsApp(DeveloperInfo.whatsapp),
        ),
      if (DeveloperInfo.facebookUrl.isNotEmpty)
        _Contact(
          Icons.facebook_rounded,
          'ফেসবুক',
          'আমাদের পেজে যান',
          DeveloperInfo.facebookUrl,
        ),
      if (DeveloperInfo.websiteUrl.isNotEmpty)
        _Contact(
          Icons.language_rounded,
          'ওয়েবসাইট',
          DeveloperInfo.websiteUrl,
          DeveloperInfo.websiteUrl,
        ),
      if (DeveloperInfo.otherAppsUrl.isNotEmpty)
        _Contact(
          Icons.apps_rounded,
          'আরও অ্যাপ',
          'ডেভেলপারের অন্যান্য অ্যাপ দেখুন',
          DeveloperInfo.otherAppsUrl,
        ),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'ডেভেলপার সম্পর্কে',
          style: TextStyle(fontWeight: FontWeight.bold, color: _ink),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.white.withValues(alpha: .3)),
          ),
          SafeArea(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                _reveal('hero', _hero()),
                _reveal('story', _storyCard()),
                _reveal('rate', _rateCard(context)),
                if (contacts.isNotEmpty)
                  _reveal('contact', _contactCard(context, contacts)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _reveal(String key, Widget child) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: HomeReveal(revealKey: 'about_$key', child: child),
  );

  BoxDecoration get _glass => BoxDecoration(
    color: Colors.white.withValues(alpha: 0.4),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 3),
    boxShadow: [
      BoxShadow(
        color: _accent.withValues(alpha: 0.18),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
    ],
  );

  Widget _sectionTitle(String title) => Row(
    children: [
      Container(
        width: 6,
        height: 22,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFB074), _accent],
          ),
        ),
      ),
      const SizedBox(width: 10),
      Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: _ink,
        ),
      ),
    ],
  );

  Widget _hero() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: _glass,
      child: Column(
        children: [
          Container(
            width: 104,
            height: 104,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.8),
              border: Border.all(
                color: _accent.withValues(alpha: 0.5),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: _accent.withValues(alpha: 0.3),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/logo_no_text.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Kids Academy Bangla',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DeveloperInfo.tagline,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.brown.shade400),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFFFFB074), _accent],
              ),
            ),
            child: Text(
              'by ${DeveloperInfo.name}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _storyCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _glass,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('অ্যাপের গল্প'),
          const SizedBox(height: 12),
          Text(
            _story,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.brown.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _rateCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _glass,
      child: Column(
        children: [
          const Text(
            'অ্যাপটি কেমন লাগছে?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _ink,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (_) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFFA928),
                  size: 36,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          PressScale(
            onTap: () => _rate(context),
            child: Container(
              width: double.infinity,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFB074), _accent],
                ),
                boxShadow: [
                  BoxShadow(
                    color: _accent.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                'Play Store-এ রেট করুন',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactCard(BuildContext context, List<_Contact> contacts) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _glass,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('যোগাযোগ'),
          const SizedBox(height: 8),
          for (final c in contacts)
            PressScale(
              onTap: () => _open(context, c.url),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _accent.withValues(alpha: 0.15),
                      ),
                      child: Icon(c.icon, color: _accent, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _ink,
                            ),
                          ),
                          Text(
                            c.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.brown.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: _accent),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Contact {
  final IconData icon;
  final String title;
  final String subtitle;
  final String url;
  const _Contact(this.icon, this.title, this.subtitle, this.url);
}
