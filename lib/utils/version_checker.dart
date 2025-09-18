import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionChecker {
  static const String _playStoreUrl = 'https://play.google.com/store/apps/details?id=com.cleansolution.illkam';
  static const String _appStoreUrl = 'https://apps.apple.com/app/id6743198587';
  static const String _apiUrl = 'https://api.ilkkam.com/api/app/version/check';

  static Future<void> checkVersion(BuildContext context) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;
    print('Current app version: $currentVersion');

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'currentVersion': currentVersion}),
      );
      print('API response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final bool updateAvailable = data['updateAvailable'];
        print('Update available: $updateAvailable');

        if (updateAvailable) {
          _showUpdateDialog(context);
        }
      } else {
        print('API request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error checking version: $e');
    }
  }

  static void _showUpdateDialog(BuildContext context) {
    print('Showing update dialog');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7F5), // A very light pink
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '최신 버전으로 업데이트하신 후 이용해 주세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: _launchURL,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 24.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF85C06),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Text(
                      '업데이트',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void _launchURL() async {
    final url = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}