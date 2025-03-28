import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:takshasila_app/constants/app_constants.dart';
import 'package:takshasila_app/constants/config.dart';
import 'package:takshasila_app/features/auth/screen/logout.dart';
import 'package:takshasila_app/features/drawermenu/screens/aboutus.dart';
import 'package:takshasila_app/features/drawermenu/screens/calendar_schedule_page.dart';
import 'package:takshasila_app/features/drawermenu/screens/privacypolicy.dart';
import 'package:takshasila_app/features/drawermenu/screens/terms&conditions.dart';
import 'package:takshasila_app/features/performance/screens/custom_peformance_message.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  void _showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                onConfirm(); // Execute the action
              },
              child: Text(
                title, // Button text matches action (Logout/Delete)
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCustomerSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contact Us'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Phone:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(phone_no),
              SizedBox(height: 8),
              Text(
                'Email:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(email_id),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blueGrey[900],
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: AppConstant.cardBackground),
              child: Center(
                child: Image.asset(
                  'assets/images/talentlogo.png',
                  height: 200,
                  width: 200,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(FluentIcons.data_trending_24_regular,color: Colors.white),
              title: const Text('Student Performance Index',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      //builder: (context) => StudentPerformanceIndex()),
                      builder: (context) => CustomPeformanceMessage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(FluentIcons.timeline_24_regular,color: Colors.white),
              title: const Text('Timeline',
               style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CalendarSchedulePage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline,color: Colors.white),
              title: const Text('About Us', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.article_outlined,color: Colors.white),
              title: const Text('Terms And Conditions', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TermsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined,color: Colors.white),
              title: const Text('Privacy Policy', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacypolicyPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.support_agent,color: Colors.white),
              title: const Text('Customer Support', style: TextStyle(color: Colors.white)),
              onTap: () {
                _showCustomerSupportDialog(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete_forever,color: Colors.white),
              title: const Text('Delete Account', style: TextStyle(color: Colors.white)),
              onTap: () {
                _showConfirmationDialog(
                  context,
                  title: 'Delete Account',
                  content:
                      'Are you sure you want to delete your account? This action cannot be undone.',
                  onConfirm: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Account Deletion Initiated'),
                          content: const Text(
                              'Your account deletion process will be initiated in 24 hours.'),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context), // Close dialog
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout,color: Colors.white),
              title: const Text('Logout', style: TextStyle(color: Colors.white)),
              onTap: () {
                showLogoutDialog(context); // Using the separate logout dialog
              },
            ),
          ],
        ),
      ),
    );
  }
}

