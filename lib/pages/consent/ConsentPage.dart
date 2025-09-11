import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:ilkkam/models/consent/ConsentModel.dart';
import 'package:ilkkam/pages/register/RegisterInfoInputPage.dart';
import 'package:ilkkam/widgets/consent/ConsentDialog.dart';
import 'package:ilkkam/utils/constants.dart';


class ConsentPage extends StatefulWidget {
  const ConsentPage({super.key});

  static const routeName = '/consent';

  @override
  State<ConsentPage> createState() => _ConsentPageState();
}

class _ConsentPageState extends State<ConsentPage> {
  bool _allAgreed = false;

  final Map<String, bool> _agreedStatus = {};

  @override
  void initState() {
    super.initState();
    for (var element in AppConstants.agreements) {
      _agreedStatus[element.title] = false;
    }
  }

  // --- Logic Handlers ---

  Future<void> _showConsentDialog(ConsentModel consent) async {
    // Avoid showing a dialog if there's no content to show
    if (consent.content.isEmpty) return;
    
    await showDialog(
      context: context,
      builder: (context) => ConsentDialog(
        title: consent.title,
        content: consent.content,
      ),
    );
  }

  void _onItemToggled(String title, bool? value) {
    setState(() {
      _agreedStatus[title] = value ?? false;
      // Save marketing consent when the marketing consent checkbox is toggled
      if (title == '광고성 정보 수신 동의 (선택)') {
        _saveMarketingConsent(value ?? false);
      }
      // If any item is unchecked, the "all agreed" is false.
      // If all items are checked, "all agreed" is true.
      _allAgreed = _agreedStatus.values.every((v) => v);
    });
  }

  Future<void> _saveMarketingConsent(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('marketingConsent', value);
  }

  // MODIFIED: This function is now async to handle showing dialogs sequentially.
  Future<void> _onAllChecked(bool? value) async {
    final isCheckingAll = value ?? false;

    // First, update the state for immediate UI feedback.
    setState(() {
      _allAgreed = isCheckingAll;
      _agreedStatus.updateAll((key, _) => _allAgreed);
    });

    // Save marketing consent when "Agree to All" is toggled
    // FIX: Save marketing consent based on the actual marketing consent checkbox status
    final marketingConsentStatus = _agreedStatus['광고성 정보 수신 동의 (선택)'] ?? false;
    await _saveMarketingConsent(marketingConsentStatus);

    // If agreeing to all, show each consent dialog sequentially.
    if (isCheckingAll) {
      for (final consent in AppConstants.agreements) {
        // The 'await' ensures dialogs are shown one after another.
        await _showConsentDialog(consent);
      }
    }
  }

  // --- UI Builder Methods ---

  @override
  Widget build(BuildContext context) {
    // Check if all mandatory items are agreed to enable/disable the button
    final allMandatoryAgreed = AppConstants.agreements
        .where((c) => c.isMandatory)
        .every((c) => _agreedStatus[c.title] == true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "Agree to All" Checkbox
            _buildAllAgreeCheckbox(),
            const Divider(height: 32),

            // "Required" Section
            const Text('필수', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...AppConstants.agreements
                .where((c) => c.isMandatory)
                .map((consent) => _buildAgreementTile(consent)),
            
            const SizedBox(height: 24),

            // "Optional" Section
            const Text('선택', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...AppConstants.agreements
                .where((c) => !c.isMandatory)
                .map((consent) => _buildAgreementTile(consent)),
            
            const Spacer(),

            // "Agree" Button
            _buildAgreeButton(allMandatoryAgreed),
          ],
        ),
      ),
    );
  }

  Widget _buildAllAgreeCheckbox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: CheckboxListTile(
        title: const Text(
          '위 모든 약관에 전체 동의합니다.',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        value: _allAgreed,
        onChanged: _onAllChecked, // Calls the updated async function
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: Colors.black,
      ),
    );
  }

  Widget _buildAgreementTile(ConsentModel consent) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero, // Removes default horizontal padding
      title: Text(consent.title, style: TextStyle(color: Colors.grey[700])),
      value: _agreedStatus[consent.title],
      onChanged: (bool? value) async {
        // 1. Update the state of the checkbox.
        _onItemToggled(consent.title, value);

        // 2. If the box is being checked, show the corresponding dialog.
        if (value == true) {
          await _showConsentDialog(consent);
        }
      },
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.black54,
    );
  }

  Widget _buildAgreeButton(bool isEnabled) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isEnabled
            ? () {
                // Navigate to the next page when button is enabled and pressed
                Navigator.of(context).pushReplacementNamed(RegisterInfoInputPage.routeName);
              }
            : null, // Button is disabled if required items are not checked
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFa38a7a), // Brownish color from image
          disabledBackgroundColor: Colors.grey[400],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          '동의',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}