import 'package:flutter/material.dart';
import 'package:pilog_idqm/controller/client_mgr_home_controller.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff7165E3),
        elevation: 0,
        centerTitle: true,
        title: const Text('Settings', style: TextStyle(color: Colors.white, fontSize: 22,fontWeight: FontWeight.w600)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SettingsTile(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            trailing: Switch(
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                  // Add logic to toggle dark mode
                });
              },
            ),
          ),
          const Divider(color: Colors.grey),
          SettingsTile(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            onTap: () {
              // Navigate to Privacy Policy screen
            },
          ),
          const Divider(color: Colors.grey),
          SettingsTile(
            icon: Icons.info_outline,
            title: 'About Us',
            onTap: () {
              // Navigate to About Us screen
            },
          ),
          const Divider(color: Colors.grey),
          SettingsTile(
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () {
              // Navigate to Notifications settings
            },
          ),
          const Divider(color: Colors.grey),
          SettingsTile(
            icon: Icons.security,
            title: 'Security',
            onTap: () {
              // Navigate to Security settings
            },
          ),
          const Divider(color: Colors.grey),
          SettingsTile(
            icon: Icons.language,
            title: 'Language',
            onTap: () {
              // Navigate to Language settings
            },
          ),
          const Divider(color: Colors.grey),
          SettingsTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              // Navigate to Help & Support screen
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

  SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      leading: Icon(icon, color: const Color(0xff7165E3)),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, color: Color(0xff7165E3), size: 16),
      onTap: onTap,
    );
  }
}
