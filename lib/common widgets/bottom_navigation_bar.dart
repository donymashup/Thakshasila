import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takshasila_app/constants/app_constants.dart';
import 'package:takshasila_app/features/auth/services/login_service.dart';
import 'package:takshasila_app/features/home/screen/home_screen.dart';
import 'package:takshasila_app/features/live/screen/live_courses.dart';
import 'package:takshasila_app/features/subscribed_courses/screen/my_courses.dart';
import 'package:takshasila_app/features/test_series/screens/test_series.dart';

class CustomBottomNavigation extends StatefulWidget {
  const CustomBottomNavigation({super.key});

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  int _selectedIndex = 0;
  bool isLoading = true;

  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    MyCourses(),
    const LiveClassesScreen(),
    TestSeriesScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null) {
      await AuthService()
          .getUserDetails(userId: userId, context: context)
          .then((value) {
        if (value?.type == "success") {
          setState(() => isLoading = false);
        } else {
          AuthService().logout(context);
        }
      }).catchError((error) {
        AuthService().logout(context);
      });
    } else {
      AuthService().logout(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: isLoading
          ? null
          : BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.school_outlined),
                  label: 'My Courses',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.live_tv),
                  label: 'Live',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FluentIcons.clipboard_task_list_16_regular),
                  label: 'Test Series',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: AppConstant.primaryColor,
              unselectedItemColor: Colors.grey,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppConstant.cardBackground,
              showUnselectedLabels: true,
            ),
    );
  }
}
