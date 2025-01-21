import 'package:flutter/material.dart';
import 'package:pilog_idqm/global/app_colors.dart';
import 'package:pilog_idqm/global/app_styles.dart';
import 'package:pilog_idqm/view/floc%20search/floc_opreation.dart';
import 'package:pilog_idqm/view/home/components/home_content.dart';
import 'package:pilog_idqm/view/parametric%20search/parametric_screen.dart';
import 'package:pilog_idqm/view/profile/profile.dart';
import 'package:pilog_idqm/view/profile/settings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'iDQM DashBoard',
          style: AppStyles.black_23_600,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            NavigationCard(
              iconPath: "assets/icons/general_search.png",
              title: 'General Search',
              color: Colors.blue,
              onTap: () => _navigateToScreen(
                context,
                const HomeContent(),
                Offset(1.0, 0.0),
              ),
            ),
            NavigationCard(
              title: 'Parametric Search',
              iconHeight: 70,
              iconWidth: 70,
              iconPath: "assets/icons/parametric_search.png",
              color: Colors.blue,
              onTap: () => _navigateToScreen(
                context,
                const ParametricSearchScreen(),
                Offset(1.0, 0.0),
              ),
            ),
            NavigationCard(
              title: 'FLOC Search',
              iconPath: "assets/icons/functional_location.png",
              color: Colors.green,
              onTap: () => _navigateToScreen(
                context,
                const FLOCOperation(),
                Offset(0.0, 1.0),
              ),
            ),
            NavigationCard(
              iconPath: "assets/icons/profile.png",
              title: 'Profile',
              color: Colors.purple,
              onTap: () => _navigateToScreen(
                context,
                const ProfileScreen(),
                Offset(-1.0, 0.0),
              ),
            ),
            NavigationCard(
              iconPath: "assets/icons/settings.png",
              title: 'Settings',
              color: Colors.orange,
              onTap: () => _navigateToScreen(
                context,
                const SettingsScreen(),
                Offset(0.0, -1.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, Widget screen, Offset offset) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween = Tween(begin: offset, end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeInOutCubic));

          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }
}

class NavigationCard extends StatefulWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;
  final String iconPath;
  final double? iconHeight;
  final double? iconWidth;

  const NavigationCard({
    super.key,
    required this.title,
    required this.color,
    required this.onTap,
    required this.iconPath,
    this.iconHeight,
    this.iconWidth,
  });

  @override
  State<NavigationCard> createState() => _NavigationCardState();
}

class _NavigationCardState extends State<NavigationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.blueShadeGradiant, Colors.indigo],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                widget.iconPath,
                height: widget.iconHeight ?? 50,
                width: widget.iconWidth ?? 50,
              ),
              const SizedBox(height: 16),
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
