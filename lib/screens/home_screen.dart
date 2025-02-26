import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_event_management/blocs/auth_bloc/auth_bloc.dart';
import 'package:student_event_management/blocs/auth_bloc/auth_event.dart';
import 'package:student_event_management/blocs/profile_bloc/profile_bloc.dart';
import 'package:student_event_management/blocs/profile_bloc/profile_event.dart';
import 'package:student_event_management/repositories/profile_repository.dart';
import 'package:student_event_management/screens/login_screen.dart';
import 'package:student_event_management/screens/profile/profile_screen.dart';
import 'package:student_event_management/widgets/custom_button.dart';
import 'package:student_event_management/widgets/theme.dart';

import 'events/event.dart';
import 'notification/notification.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  String? regno;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  void _fetchUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        regno = user.uid;
      });
    }
  }

  List<Widget> _buildScreens() {
    return [
      HomePageContent(),
      UnderMaintenanceScreen(),
      EmptyNotificationsScreen(),
      ProfileScreen(userId: regno!),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: regno == null
          ? Center(child: CircularProgressIndicator())
          : BlocProvider(
              create: (context) =>
                  ProfileBloc(profileRepository: ProfileRepository())
                    ..add(LoadUserProfile(regno!)),
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: _buildScreens(),
              ),
            ),
      bottomNavigationBar: regno == null
          ? null
          : CustomBottomNavigationBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
      elevation: AppTheme.lightTheme.appBarTheme.elevation,
      title: Text(
        'Welcome',
        style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.logout, color: AppTheme.red),
          onPressed: () => _showLogoutConfirmation(context),
        ),
      ],
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            'Logout',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancel', style: TextStyle(color: AppTheme.grey)),
            ),
            TextButton(
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(AuthLogout());
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              },
              child: Text('Logout', style: TextStyle(color: AppTheme.red)),
            ),
          ],
        );
      },
    );
  }
}

class HomePageContent extends StatefulWidget {
  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: 'hero-image',
            child: Image.network(
              'https://cdn-icons-png.flaticon.com/512/2952/2952380.png',
              width: 120,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Welcome to the Student Career Guidance APP!',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontFamily: 'MoonWalk'),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class EventPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Event Page',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
