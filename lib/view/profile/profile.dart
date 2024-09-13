import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff7165E3),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundColor: Color(0xff7165E3),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 110,
                        ),
                      ),                     
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'AJAY_IDAM_CLIENT_MGR',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  ProfileInfoRow(
                    icon: Icons.location_on,
                    label: 'Location',
                    value: 'IN',
                  ),
                  ProfileInfoRow(
                    icon: Icons.language,
                    label: 'Locale',
                    value: 'en_US',
                  ),
                  ProfileInfoRow(
                    icon: Icons.business,
                    label: 'Organization',
                    value: 'RCJY',
                  ),
                  ProfileInfoRow(
                    icon: Icons.account_box,
                    label: 'Org ID',
                    value: 'C1F5CFB03F2E444DAE78ECCEAD80D27D',
                  ),
                  ProfileInfoRow(
                    icon: Icons.person,
                    label: 'Username',
                    value: 'AJAY_IDAM_CLIENT_MGR',
                  ),
                  ProfileInfoRow(
                    icon: Icons.settings_applications,
                    label: 'Instance',
                    value: '100',
                  ),
                  ProfileInfoRow(
                    icon: Icons.work,
                    label: 'Role',
                    value: 'PM_FAR_IDAM_CLIENT_MGR',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  ProfileInfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xff5a55ca), size: 20),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
