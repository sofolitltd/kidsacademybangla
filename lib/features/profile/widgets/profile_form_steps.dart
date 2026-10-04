import 'package:flutter/material.dart';
import '../widgets/profile_form_fields.dart';

class ProfileFormSteps extends StatelessWidget {
  final int currentStep;
  final TextEditingController childNameController;
  final TextEditingController nickNameController;
  final TextEditingController dobController;
  final TextEditingController addressController;
  final TextEditingController fatherNameController;
  final TextEditingController fatherMobileController;
  final TextEditingController motherNameController;
  final TextEditingController motherMobileController;
  final TextEditingController dadaNameController;
  final TextEditingController dadiNameController;
  final TextEditingController nanaNameController;
  final TextEditingController naniNameController;
  final List<Map<String, String>> brothers;
  final List<Map<String, String>> sisters;
  final List<String> positionOptions;
  final VoidCallback onSelectDate;
  final void Function(int index, String value) onBrotherNameChanged;
  final void Function(int index, String value) onBrotherPositionChanged;
  final void Function(int index) onBrotherRemoved;
  final VoidCallback onAddBrother;
  final void Function(int index, String value) onSisterNameChanged;
  final void Function(int index, String value) onSisterPositionChanged;
  final void Function(int index) onSisterRemoved;
  final VoidCallback onAddSister;

  const ProfileFormSteps({
    super.key,
    required this.currentStep,
    required this.childNameController,
    required this.nickNameController,
    required this.dobController,
    required this.addressController,
    required this.fatherNameController,
    required this.fatherMobileController,
    required this.motherNameController,
    required this.motherMobileController,
    required this.dadaNameController,
    required this.dadiNameController,
    required this.nanaNameController,
    required this.naniNameController,
    required this.brothers,
    required this.sisters,
    required this.positionOptions,
    required this.onSelectDate,
    required this.onBrotherNameChanged,
    required this.onBrotherPositionChanged,
    required this.onBrotherRemoved,
    required this.onAddBrother,
    required this.onSisterNameChanged,
    required this.onSisterPositionChanged,
    required this.onSisterRemoved,
    required this.onAddSister,
  });

  @override
  Widget build(BuildContext context) {
    switch (currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      case 3:
        return _buildStep4();
      case 4:
        return _buildStep5();
      default:
        return const SizedBox();
    }
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileFormFields.buildSectionTitle(
          'সন্তানের তথ্য',
          Icons.child_care,
          const Color(0xFFFF7F50),
        ),
        const SizedBox(height: 16),
        ProfileFormFields.buildTextField(
          childNameController,
          'পুরোনাম *',
          'যেমন: অবরার ফয়েজ রাফি',
        ),
        const SizedBox(height: 16),
        ProfileFormFields.buildTextField(
          nickNameController,
          'ডাকনাম',
          'যেমন: রাফি',
        ),
        const SizedBox(height: 16),
        ProfileFormFields.buildDateField(dobController, onSelectDate),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileFormFields.buildSectionTitle(
          'বাবা-মা',
          Icons.family_restroom,
          Colors.teal,
        ),
        const SizedBox(height: 16),
        ProfileFormFields.buildTextField(
          fatherNameController,
          'বাবার নাম *',
          'যেমন: মো রহিম উদ্দিন',
        ),
        const SizedBox(height: 16),
        ProfileFormFields.buildTextField(
          motherNameController,
          'মায়ের নাম *',
          'যেমন: সাবরিনা আক্তার',
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileFormFields.buildSectionTitle(
          'ভাই-বোন',
          Icons.people,
          Colors.green,
        ),
        const SizedBox(height: 16),
        ProfileFormFields.buildSectionLabel('ভাইদের নাম', Colors.green),
        const SizedBox(height: 8),
        ...brothers.asMap().entries.map(
          (entry) => ProfileFormFields.buildSiblingEntry(
            entry: entry.value,
            index: entry.key,
            isBrother: true,
            positionOptions: positionOptions,
            onRemove: () => onBrotherRemoved(entry.key),
            onNameChanged: (val) => onBrotherNameChanged(entry.key, val),
            onPositionChanged: (val) =>
                onBrotherPositionChanged(entry.key, val),
          ),
        ),
        const SizedBox(height: 8),
        ProfileFormFields.buildAddSiblingButton(true, onAddBrother),
        const SizedBox(height: 20),
        ProfileFormFields.buildSectionLabel('বোনদের নাম', Colors.green),
        const SizedBox(height: 8),
        ...sisters.asMap().entries.map(
          (entry) => ProfileFormFields.buildSiblingEntry(
            entry: entry.value,
            index: entry.key,
            isBrother: false,
            positionOptions: positionOptions,
            onRemove: () => onSisterRemoved(entry.key),
            onNameChanged: (val) => onSisterNameChanged(entry.key, val),
            onPositionChanged: (val) => onSisterPositionChanged(entry.key, val),
          ),
        ),
        const SizedBox(height: 8),
        ProfileFormFields.buildAddSiblingButton(false, onAddSister),
      ],
    );
  }

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileFormFields.buildSectionTitle(
          'দাদা-দিদি-নানা-নানী',
          Icons.elderly,
          Colors.purple,
        ),
        const SizedBox(height: 16),
        ProfileFormFields.buildTextField(
          dadaNameController,
          'দাদার নাম',
          'পিতার পক্ষ',
        ),
        const SizedBox(height: 16),
        ProfileFormFields.buildTextField(
          dadiNameController,
          'দাদীর নাম',
          'পিতার পক্ষ',
        ),
        const SizedBox(height: 16),
        ProfileFormFields.buildTextField(
          nanaNameController,
          'নানার নাম',
          'মাতার পক্ষ',
        ),
        const SizedBox(height: 16),
        ProfileFormFields.buildTextField(
          naniNameController,
          'নানীর নাম',
          'মাতার পক্ষ',
        ),
      ],
    );
  }

  Widget _buildStep5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileFormFields.buildSectionTitle(
          'যোগাযোগ',
          Icons.contact_phone,
          Colors.orange,
        ),
        const SizedBox(height: 16),
        ProfileFormFields.buildTextField(
          addressController,
          'ঠিকানা',
          'যেমন: ঢাকা, বাংলাদেশ',
        ),
        const SizedBox(height: 16),
        ProfileFormFields.buildTextField(
          fatherMobileController,
          'বাবার মোবাইল',
          'জরুরি পরিস্থিতিতে যোগাযোগের জন্য',
        ),
        const SizedBox(height: 16),
        ProfileFormFields.buildTextField(
          motherMobileController,
          'মায়ের মোবাইল',
          'জরুরি পরিস্থিতিতে যোগাযোগের জন্য',
        ),
      ],
    );
  }
}
