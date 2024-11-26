import 'package:flutter/material.dart';
import 'package:pilog_idqm/controller/client_mgr_home_controller.dart';
import 'package:pilog_idqm/helpers/toasts.dart';
import 'package:pilog_idqm/helpers/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff7165E3),
        elevation: 0,
        centerTitle: true,
        title: const Text('Settings',
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          
          SettingsTile(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            onTap: () async {
              await urlLauncher(
                  "https://www.piloggroup.com/privacy-policy.php");
            },
          ),
          const Divider(color: Colors.grey),
          SettingsTile(
            icon: Icons.info_outline,
            title: 'About Us',
            onTap: () async {
              await urlLauncher(
                  "https://www.piloggroup.com");
            },
          ),
          const Divider(color: Colors.grey),
         
          SettingsTile(
            icon: Icons.security,
            title: 'Security',
            onTap: () {
              ToastCustom.infoToast(context, "Coming Soon..\nwe are continously working to enhance security");
            },
          ),
         
          const Divider(color: Colors.grey),
          SettingsTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: ()async {
                   await urlLauncher(
                  "https://www.piloggroup.com/contact.php");
            },
          ),
          SettingsTile(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              ClientMgrHomeController().onLogout(context);
              // Navigate to Help & Support screen
            },
          ),
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsTile({super.key, 
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      leading: Icon(icon, color: const Color(0xff7165E3)),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
      trailing: trailing ??
          const Icon(Icons.arrow_forward_ios,
              color: Color(0xff7165E3), size: 16),
      onTap: onTap,
    );
  }
}
