import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../core/services/profile_service.dart';
import '../profile/widgets/profile_info_card.dart';
import '../profile/widgets/profile_bottom_controls.dart';
import '../profile/widgets/profile_items_data.dart';

class ProfileLearnScreen extends StatefulWidget {
  final String profileId;

  const ProfileLearnScreen({super.key, required this.profileId});

  @override
  State<ProfileLearnScreen> createState() => _ProfileLearnScreenState();
}

class _ProfileLearnScreenState extends State<ProfileLearnScreen> {
  ChildProfile? _profile;
  bool _isLoading = true;
  bool _isPlaying = false;
  bool _isSlowMode = false;
  int _currentlyPlayingIndex = -1;
  late FlutterTts _tts;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tts = FlutterTts();
    _initTts();
    _loadProfile();
  }

  Future<void> _initTts() async {
    try {
      await _tts.setLanguage('bn');
      await _tts.setPitch(1.0);
      await _tts.awaitSpeakCompletion(true);
    } catch (e) {
      debugPrint('TTS init error: $e');
    }
  }

  Future<void> _loadProfile() async {
    final profile = await ProfileService.getProfile(widget.profileId);
    if (mounted) {
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tts.stop();
    _tts.awaitSpeakCompletion(false);
    super.dispose();
  }

  List<Map<String, String>> _getProfileItems() {
    return ProfileItemsData.getProfileItems(_profile);
  }

  Color _hexToColor(String hex) {
    return ProfileItemsData.hexToColor(hex);
  }

  Future<void> _speakItem(String label, String value, int index) async {
    try {
      await _tts.stop();
      setState(() => _currentlyPlayingIndex = index);
      _scrollToIndex(index);
      await _tts.setSpeechRate(_isSlowMode ? 0.32 : 0.38);
      await _tts.speak('$label $value');
      if (mounted) setState(() => _currentlyPlayingIndex = -1);
    } catch (e) {
      debugPrint('TTS speak error: $e');
    }
  }

  void _scrollToIndex(int index) {
    if (_scrollController.hasClients) {
      final targetOffset = index * 72.0;
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _playAll() async {
    if (_isPlaying) {
      await _tts.stop();
      setState(() {
        _isPlaying = false;
        _currentlyPlayingIndex = -1;
      });
      return;
    }

    final items = _getProfileItems();
    if (items.isEmpty) return;

    setState(() => _isPlaying = true);
    await _tts.setSpeechRate(_isSlowMode ? 0.32 : 0.38);

    for (int i = 0; i < items.length; i++) {
      if (!_isPlaying) break;
      setState(() => _currentlyPlayingIndex = i);
      await _tts.speak('${items[i]['label']} ${items[i]['value']}');
      if (i < items.length - 1 && _isPlaying) {
        await Future.delayed(Duration(milliseconds: _isSlowMode ? 1000 : 800));
      }
    }

    if (mounted) {
      setState(() {
        _isPlaying = false;
        _currentlyPlayingIndex = -1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
              ),
            ),
            const Center(child: CircularProgressIndicator()),
          ],
        ),
      );
    }

    if (_profile == null) {
      return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
              ),
            ),
            const Center(child: Text('প্রোফাইল পাওয়া যায়নি')),
          ],
        ),
      );
    }

    final items = _getProfileItems();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.white.withValues(alpha: 0.3)),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: items.isEmpty
                      ? const Center(
                          child: Text(
                            'কোনো তথ্য নেই',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : _buildItemsList(items),
                ),
                _buildBottomControls(items),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.white,
      centerTitle: true,
      title: const Text(
        'আমার পরিচয়',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () async {
            await context.push('/profile/form?profileId=${widget.profileId}');
            _loadProfile();
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _confirmDelete(),
        ),
      ],
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('মুছে ফেলুন?'),
        content: Text('${_profile?.childName}-এর প্রোফাইল মুছে ফেলতে চান?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('না'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ProfileService.deleteProfile(widget.profileId);
              if (mounted && context.canPop()) context.pop();
            },
            child: const Text('হ্যাঁ', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(List<Map<String, String>> items) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final color = _hexToColor(item['color']!);
        final isPlaying = _currentlyPlayingIndex == index;
        return ProfileInfoCard(
          item: item,
          color: color,
          isPlaying: isPlaying,
          onTap: () => _speakItem(item['label']!, item['value']!, index),
        );
      },
    );
  }

  Widget _buildBottomControls(List<Map<String, String>> items) {
    return ProfileBottomControls(
      isPlaying: _isPlaying,
      isSlowMode: _isSlowMode,
      isEmpty: items.isEmpty,
      onToggleSlowMode: () => setState(() => _isSlowMode = !_isSlowMode),
      onPlayAll: _playAll,
    );
  }
}
