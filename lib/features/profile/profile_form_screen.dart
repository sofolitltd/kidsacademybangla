import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/profile_service.dart';
import '../profile/widgets/profile_form_steps.dart';
import '../profile/widgets/profile_progress_indicator.dart';
import '../profile/widgets/profile_navigation_buttons.dart';

class ProfileFormScreen extends StatefulWidget {
  final String? profileId;

  const ProfileFormScreen({super.key, this.profileId});

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  int _currentStep = 0;
  bool _isLoading = false;
  bool _isEditing = false;

  final _childNameController = TextEditingController();
  final _nickNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _fatherMobileController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _motherMobileController = TextEditingController();
  final _dadaNameController = TextEditingController();
  final _dadiNameController = TextEditingController();
  final _nanaNameController = TextEditingController();
  final _naniNameController = TextEditingController();

  final List<Map<String, String>> _brothers = [];
  final List<Map<String, String>> _sisters = [];
  final List<String> _positionOptions = ['বড়', 'মেজো', 'সোজা', 'ছোট'];

  @override
  void initState() {
    super.initState();
    if (widget.profileId != null) {
      _isEditing = true;
      _loadProfile();
    }
  }

  Future<void> _loadProfile() async {
    final profile = await ProfileService.getProfile(widget.profileId!);
    if (profile != null && mounted) {
      setState(() {
        _childNameController.text = profile.childName;
        _nickNameController.text = profile.nickName;
        _dobController.text = profile.dob;
        _addressController.text = profile.address;
        _fatherNameController.text = profile.fatherName;
        _fatherMobileController.text = profile.fatherMobile;
        _motherNameController.text = profile.motherName;
        _motherMobileController.text = profile.motherMobile;
        _dadaNameController.text = profile.dadaName;
        _dadiNameController.text = profile.dadiName;
        _nanaNameController.text = profile.nanaName;
        _naniNameController.text = profile.naniName;
        if (profile.brothers.isNotEmpty) {
          _brothers.clear();
          for (final entry
              in profile.brothers
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)) {
            final parts = entry.split(':');
            _brothers.add({
              'name': parts[0].trim(),
              'position': parts.length > 1 ? parts[1].trim() : 'ছোট',
            });
          }
        }
        if (profile.sisters.isNotEmpty) {
          _sisters.clear();
          for (final entry
              in profile.sisters
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)) {
            final parts = entry.split(':');
            _sisters.add({
              'name': parts[0].trim(),
              'position': parts.length > 1 ? parts[1].trim() : 'ছোট',
            });
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _childNameController.dispose();
    _nickNameController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _fatherNameController.dispose();
    _fatherMobileController.dispose();
    _motherNameController.dispose();
    _motherMobileController.dispose();
    _dadaNameController.dispose();
    _dadiNameController.dispose();
    _nanaNameController.dispose();
    _naniNameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 5),
      firstDate: DateTime(2015),
      lastDate: now,
      helpText: 'জন্মদিন নির্বাচন করুন',
    );
    if (picked != null) {
      setState(() {
        _dobController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _save() async {
    if (_fatherNameController.text.trim().isEmpty ||
        _motherNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('বাবা ও মায়ের নাম লিখুন')));
      return;
    }

    setState(() => _isLoading = true);

    final id = _isEditing
        ? widget.profileId!
        : DateTime.now().millisecondsSinceEpoch.toString();
    final profile = ChildProfile(
      id: id,
      childName: _childNameController.text.trim(),
      nickName: _nickNameController.text.trim(),
      dob: _dobController.text.trim(),
      address: _addressController.text.trim(),
      fatherName: _fatherNameController.text.trim(),
      fatherMobile: _fatherMobileController.text.trim(),
      motherName: _motherNameController.text.trim(),
      motherMobile: _motherMobileController.text.trim(),
      dadaName: _dadaNameController.text.trim(),
      dadiName: _dadiNameController.text.trim(),
      nanaName: _nanaNameController.text.trim(),
      naniName: _naniNameController.text.trim(),
      brothers: _brothers
          .map((b) => '${b['name']}:${b['position']}')
          .join(', '),
      sisters: _sisters.map((s) => '${s['name']}:${s['position']}').join(', '),
    );

    await ProfileService.saveProfile(profile);
    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'তথ্য আপডেট হয়েছে!' : 'প্রোফাইল সংরক্ষিত হয়েছে!',
          ),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                _buildProgressIndicator(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: _buildCurrentStep(),
                  ),
                ),
                _buildNavigationButtons(),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(child: CircularProgressIndicator()),
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
      title: Text(
        _isEditing ? 'তথ্য সম্পাদনা' : 'নতুন প্রোফাইল',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return ProfileProgressIndicator(currentStep: _currentStep);
  }

  Widget _buildCurrentStep() {
    return ProfileFormSteps(
      currentStep: _currentStep,
      childNameController: _childNameController,
      nickNameController: _nickNameController,
      dobController: _dobController,
      addressController: _addressController,
      fatherNameController: _fatherNameController,
      fatherMobileController: _fatherMobileController,
      motherNameController: _motherNameController,
      motherMobileController: _motherMobileController,
      dadaNameController: _dadaNameController,
      dadiNameController: _dadiNameController,
      nanaNameController: _nanaNameController,
      naniNameController: _naniNameController,
      brothers: _brothers,
      sisters: _sisters,
      positionOptions: _positionOptions,
      onSelectDate: _selectDate,
      onBrotherNameChanged: (i, v) => _brothers[i]['name'] = v,
      onBrotherPositionChanged: (i, v) => _brothers[i]['position'] = v,
      onBrotherRemoved: (i) => setState(() => _brothers.removeAt(i)),
      onAddBrother: () =>
          setState(() => _brothers.add({'name': '', 'position': 'ছোট'})),
      onSisterNameChanged: (i, v) => _sisters[i]['name'] = v,
      onSisterPositionChanged: (i, v) => _sisters[i]['position'] = v,
      onSisterRemoved: (i) => setState(() => _sisters.removeAt(i)),
      onAddSister: () =>
          setState(() => _sisters.add({'name': '', 'position': 'ছোট'})),
    );
  }

  Widget _buildNavigationButtons() {
    return ProfileNavigationButtons(
      currentStep: _currentStep,
      isEditing: _isEditing,
      isLoading: _isLoading,
      onPrev: _prevStep,
      onNext: _nextStep,
      onSave: _save,
    );
  }
}
