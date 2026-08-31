import 'package:flutter/material.dart';

enum Gender {
  male('男性'),
  female('女性'),
  other('その他'),
  unanswered('回答しない');

  const Gender(this.label);
  final String label;
}

/// 入力値の判定だけを担当する、状態を持たないシングルトンです。
class OfficialIdentificationValidator {
  OfficialIdentificationValidator._();
  static final _instance = OfficialIdentificationValidator._();
  factory OfficialIdentificationValidator() => _instance;

  bool isNameValid(String value) => value.trim().isNotEmpty;

  bool isPhoneNumberValid(String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    return RegExp(r'^0\d{9,10}$').hasMatch(digits);
  }

  bool isComplete({
    required String familyName,
    required String givenName,
    required String phoneNumber,
    required DateTime? birthDate,
    required Gender? gender,
  }) =>
      isNameValid(familyName) &&
      isNameValid(givenName) &&
      isPhoneNumberValid(phoneNumber) &&
      birthDate != null &&
      gender != null;
}

class OfficialIdentificationWidget extends StatefulWidget {
  const OfficialIdentificationWidget({super.key});
  @override
  State<OfficialIdentificationWidget> createState() =>
      _OfficialIdentificationWidgetState();
}

class _OfficialIdentificationWidgetState
    extends State<OfficialIdentificationWidget> {
  final _formKey = GlobalKey<FormState>();
  final _familyNameController = TextEditingController();
  final _givenNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _validator = OfficialIdentificationValidator();
  DateTime? _birthDate;
  Gender? _gender;

  @override
  void dispose() {
    _familyNameController.dispose();
    _givenNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  int? get _age {
    final birth = _birthDate;
    if (birth == null) return null;
    final today = DateUtils.dateOnly(DateTime.now());
    var value = today.year - birth.year;
    if (today.month < birth.month ||
        (today.month == birth.month && today.day < birth.day)) {
      value--;
    }
    return value;
  }

  Future<void> _selectBirthDate(FormFieldState<DateTime> field) async {
    final today = DateUtils.dateOnly(DateTime.now());
    final selected = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(today.year - 30),
      firstDate: DateTime(1900),
      lastDate: today,
      helpText: '生年月日を選択',
      cancelText: 'キャンセル',
      confirmText: '決定',
    );
    if (selected != null) {
      setState(() => _birthDate = selected);
      field.didChange(selected);
    }
  }

  void _submit() {
    final fieldsAreValid = _formKey.currentState?.validate() ?? false;
    setState(() {});
    final complete = _validator.isComplete(
      familyName: _familyNameController.text,
      givenName: _givenNameController.text,
      phoneNumber: _phoneController.text,
      birthDate: _birthDate,
      gender: _gender,
    );
    if (!fieldsAreValid || !complete) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('入力内容を確認しました')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF12372A),
        foregroundColor: Colors.white,
        title: const Text(
          '本人情報の入力',
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: .5),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.only(bottom: 40),
                children: [
                  Semantics(
                    image: true,
                    label: '自治体の本人確認手続きの案内画像',
                    child: AspectRatio(
                      aspectRatio: 16 / 7,
                      child: Image.asset(
                        'images/official_identification.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '申請者情報',
                          style: TextStyle(
                            color: Color(0xFF12372A),
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '住民票に記載されている内容をご入力ください。',
                          style: TextStyle(
                            color: Color(0xFF52615B),
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 28),
                        const _SectionLabel(number: '01', label: 'お名前'),
                        const SizedBox(height: 14),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final family = _textField(
                              key: const Key('familyNameField'),
                              controller: _familyNameController,
                              label: '名字',
                              hint: '例）山田',
                            );
                            final given = _textField(
                              key: const Key('givenNameField'),
                              controller: _givenNameController,
                              label: '名前',
                              hint: '例）太郎',
                            );
                            if (constraints.maxWidth < 420) {
                              return Column(
                                children: [
                                  family,
                                  const SizedBox(height: 12),
                                  given,
                                ],
                              );
                            }
                            return Row(
                              children: [
                                Expanded(child: family),
                                const SizedBox(width: 12),
                                Expanded(child: given),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 28),
                        const _SectionLabel(number: '02', label: '連絡先'),
                        const SizedBox(height: 14),
                        _textField(
                          key: const Key('phoneNumberField'),
                          controller: _phoneController,
                          label: '電話番号',
                          hint: '例）090-1234-5678',
                          keyboardType: TextInputType.phone,
                          validator: (value) =>
                              _validator.isPhoneNumberValid(value ?? '')
                              ? null
                              : '正しい電話番号を入力してください',
                        ),
                        const SizedBox(height: 28),
                        const _SectionLabel(number: '03', label: '基本情報'),
                        const SizedBox(height: 14),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _birthDateField()),
                            const SizedBox(width: 12),
                            SizedBox(width: 96, child: _ageField()),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _genderField(),
                        const SizedBox(height: 36),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: FilledButton.icon(
                            key: const Key('submitButton'),
                            onPressed: _submit,
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFC65D32),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(Icons.arrow_forward, size: 20),
                            label: const Text(
                              '入力内容を確認する',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Center(
                          child: Text(
                            '※ この画面はテスト用のMockです',
                            style: TextStyle(
                              color: Color(0xFF718079),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _textField({
    required Key key,
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) => TextFormField(
    key: key,
    controller: controller,
    keyboardType: keyboardType,
    textInputAction: TextInputAction.next,
    decoration: _decoration(label: label, hint: hint),
    validator:
        validator ??
        (value) =>
            _validator.isNameValid(value ?? '') ? null : '$labelを入力してください',
  );

  Widget _birthDateField() => FormField<DateTime>(
    key: const Key('birthDateField'),
    validator: (_) => _birthDate == null ? '生年月日を選択してください' : null,
    builder: (field) {
      final date = _birthDate;
      final text = date == null
          ? '年 / 月 / 日'
          : '${date.year}年${date.month}月${date.day}日';
      return InkWell(
        onTap: () => _selectBirthDate(field),
        borderRadius: BorderRadius.circular(8),
        child: InputDecorator(
          decoration: _decoration(
            label: '生年月日',
            hint: '',
            errorText: field.errorText,
            suffixIcon: const Icon(Icons.calendar_month_outlined),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: date == null
                  ? const Color(0xFF7B8882)
                  : const Color(0xFF1B2923),
            ),
          ),
        ),
      );
    },
  );

  Widget _ageField() => InputDecorator(
    decoration: _decoration(label: '年齢', hint: ''),
    child: Text(_age == null ? '—' : '$_age 歳', key: const Key('ageText')),
  );

  Widget _genderField() => FormField<Gender>(
    key: const Key('genderField'),
    validator: (_) => _gender == null ? '性別を選択してください' : null,
    builder: (field) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '性別',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: Gender.values
              .map(
                (gender) => ChoiceChip(
                  key: Key('gender-${gender.name}'),
                  label: Text(gender.label),
                  selected: _gender == gender,
                  onSelected: (_) {
                    setState(() => _gender = gender);
                    field.didChange(gender);
                  },
                  selectedColor: const Color(0xFFDCEAE2),
                  side: BorderSide(
                    color: _gender == gender
                        ? const Color(0xFF39745C)
                        : const Color(0xFFC8D0CC),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              )
              .toList(),
        ),
        if (field.hasError) ...[
          const SizedBox(height: 8),
          Text(
            field.errorText!,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 12,
            ),
          ),
        ],
      ],
    ),
  );

  InputDecoration _decoration({
    required String label,
    required String hint,
    String? errorText,
    Widget? suffixIcon,
  }) => InputDecoration(
    labelText: label,
    hintText: hint,
    errorText: errorText,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: const Color(0xFFFBFCFA),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFC8D0CC)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF39745C), width: 2),
    ),
  );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.number, required this.label});
  final String number;
  final String label;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(
        number,
        style: const TextStyle(
          color: Color(0xFFC65D32),
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
      const SizedBox(width: 10),
      Container(width: 28, height: 1, color: const Color(0xFFC65D32)),
      const SizedBox(width: 10),
      Text(
        label,
        style: const TextStyle(
          color: Color(0xFF24352E),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

/// 以前のサンプル名を参照しているコード向けの互換ウィジェットです。
class MyWidget extends OfficialIdentificationWidget {
  const MyWidget({super.key});
}
