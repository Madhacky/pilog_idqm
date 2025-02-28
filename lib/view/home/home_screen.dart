// import 'package:flutter/material.dart';
// import 'package:pilog_idqm/global/app_styles.dart';
// import 'package:pilog_idqm/helpers/pdf_viewer_goggle_drive_link.dart';
// import 'package:pilog_idqm/helpers/search_stats_manager.dart';
// import 'package:pilog_idqm/view/floc%20search/floc_opreation.dart';
// import 'package:pilog_idqm/view/home/components/home_content.dart';
// import 'package:pilog_idqm/view/parametric%20search/parametric_screen.dart';
// import 'package:pilog_idqm/view/profile/profile.dart';
// import 'package:pilog_idqm/view/profile/settings.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final SearchAnalyticsService analyticsService = SearchAnalyticsService();
//     return Scaffold(
//       persistentFooterButtons: [
//         Center(child: Text('© 2024 PiLog Group. All Rights Reserved'))
//       ],
//       appBar: AppBar(automaticallyImplyLeading: false,
//         title: Text(
//           'DashBoard',
//           style: AppStyles.black_23_600,
//         ),
//         centerTitle: true,
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 10.0),
//             child: IconButton(
//                 onPressed: () {
//                   PDFBottomSheet.show(
//                       context, '1PVeLE8B7TnZrZwv8hHBAXwT7XgWVEPlZ');
//                 },
//                 icon: Icon(Icons.info)),
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           // Padding(
//           //   padding: EdgeInsets.all(16.0),
//           //   child: SizedBox(
//           //       height: 270,
//           //       child:
//           //           SearchAnalyticsChart(analyticsService: analyticsService)),
//           // ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: GridView.count(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 16,
//                 crossAxisSpacing: 16,
//                 children: [
//                   NavigationCard(
//                     iconPath: "assets/icons/general_search.png",
//                     title: 'General Search',
//                     color: Colors.blue,
//                     onTap: () => _navigateToScreen(
//                       context,
//                       HomeContent(
//                         analyticsService: analyticsService,
//                       ),
//                       Offset(1.0, 0.0),
//                     ),
//                   ),
//                   NavigationCard(
//                     title: 'Parametric Search',
//                     // iconHeight: 70,
//                     // iconWidth: 70,
//                     iconPath: "assets/icons/parametric_search.png",
//                     color: Colors.blue,
//                     onTap: () => _navigateToScreen(
//                       context,
//                       const ParametricSearchScreen(),
//                       Offset(1.0, 0.0),
//                     ),
//                   ),
//                   NavigationCard(
//                     title: 'FLOC Search',
//                     iconPath: "assets/icons/functional_location.png",
//                     color: Colors.green,
//                     onTap: () => _navigateToScreen(
//                       context,
//                       const FLOCOperation(),
//                       Offset(0.0, 1.0),
//                     ),
//                   ),
//                   NavigationCard(
//                     iconPath: "assets/icons/profile.png",
//                     title: 'Profile',
//                     color: Colors.purple,
//                     onTap: () => _navigateToScreen(
//                       context,
//                       const ProfileScreen(),
//                       Offset(-1.0, 0.0),
//                     ),
//                   ),
//                   NavigationCard(
//                     iconPath: "assets/icons/settings.png",
//                     title: 'Settings',
//                     color: Colors.orange,
//                     onTap: () => _navigateToScreen(
//                       context,
//                       const SettingsScreen(),
//                       Offset(0.0, -1.0),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _navigateToScreen(BuildContext context, Widget screen, Offset offset) {
//     Navigator.push(
//       context,
//       PageRouteBuilder(
//         pageBuilder: (context, animation, secondaryAnimation) => screen,
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           var tween = Tween(begin: offset, end: Offset.zero)
//               .chain(CurveTween(curve: Curves.easeInOutCubic));

//           return SlideTransition(
//             position: animation.drive(tween),
//             child: FadeTransition(
//               opacity: animation,
//               child: child,
//             ),
//           );
//         },
//         transitionDuration: const Duration(milliseconds: 600),
//       ),
//     );
//   }
// }

// class NavigationCard extends StatefulWidget {
//   final String title;
//   final Color color;
//   final VoidCallback onTap;
//   final String iconPath;
//   final double? iconHeight;
//   final double? iconWidth;

//   const NavigationCard({
//     super.key,
//     required this.title,
//     required this.color,
//     required this.onTap,
//     required this.iconPath,
//     this.iconHeight,
//     this.iconWidth,
//   });

//   @override
//   State<NavigationCard> createState() => _NavigationCardState();
// }

// class _NavigationCardState extends State<NavigationCard>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 200),
//       vsync: this,
//     );
//     _scaleAnimation = Tween<double>(begin: 1, end: 0.95).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: (_) => _controller.forward(),
//       onTapUp: (_) {
//         _controller.reverse();
//         widget.onTap();
//       },
//       onTapCancel: () => _controller.reverse(),
//       child: AnimatedBuilder(
//         animation: _scaleAnimation,
//         builder: (context, child) => Transform.scale(
//           scale: _scaleAnimation.value,
//           child: child,
//         ),
//         child: Card(elevation: 10,
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               // gradient: const LinearGradient(
//               //   begin: Alignment.topLeft,
//               //   end: Alignment.bottomRight,
//               //   colors: [AppColors.blueShadeGradiant, Colors.indigo],
//               // ),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   widget.iconPath,
//                   height: widget.iconHeight ?? 50,
//                   width: widget.iconWidth ?? 50,
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   widget.title,
//                   style: const TextStyle(
//                     color: Colors.black,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pilog_idqm/global/app_colors.dart';
import 'package:pilog_idqm/global/app_styles.dart';

import 'package:pilog_idqm/helpers/mixpanel_manager.dart';
import 'package:pilog_idqm/helpers/pdf_viewer_goggle_drive_link.dart';
import 'package:pilog_idqm/helpers/search_stats_manager.dart';
import 'package:pilog_idqm/helpers/shared_preferences_helpers.dart';
import 'package:pilog_idqm/view/floc%20search/floc_opreation.dart';
import 'package:pilog_idqm/view/home/components/home_content.dart';
import 'package:pilog_idqm/view/parametric%20search/parametric_screen.dart';
import 'package:pilog_idqm/view/profile/profile.dart';
import 'package:pilog_idqm/view/profile/settings.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  Future<String?> username() async {
    return await SharedPreferencesHelper.getUsername();
  }

// Dummy data for recent searches
  final List<String> recentSearches = [
    'Transmitter',
    'Transformer',
    'Pump',
    'Pressure gauge',
  ];


  @override
  Widget build(BuildContext context) {
    final SearchAnalyticsService analyticsService = SearchAnalyticsService();

    return Scaffold(
      // persistentFooterButtons: [
      //   Center(child: Text('© 2024 PiLog Group. All Rights Reserved'))
      // ],
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Text(
      //     'DashBoard',
      //     style: AppStyles.black_23_600,
      //   ),
      //   centerTitle: true,
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.only(right: 10.0),
      //       child: IconButton(
      //           onPressed: () {
      //             PDFBottomSheet.show(
      //                 context, '1PVeLE8B7TnZrZwv8hHBAXwT7XgWVEPlZ');
      //           },
      //           icon: Icon(Icons.info)),
      //     )
      //   ],
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // const SizedBox(
              //   height: 20,
              // ),
              // Hello Username Section
              FutureBuilder<String?>(
                future: username(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Show a loading indicator while fetching the username
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}'); // Handle errors
                  } else {
                    final userName = snapshot.data ??
                        'User'; // Default to 'User' if username is null
                    return Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello',
                                style: GoogleFonts.poppins(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                userName,
                                style: GoogleFonts.poppins(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Make your day easy with our tool',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.grey500,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: IconButton(
                                onPressed: () {
                                  PDFBottomSheet.show(context,
                                      '1PVeLE8B7TnZrZwv8hHBAXwT7XgWVEPlZ');
                                },
                                icon: Icon(
                                  Icons.info_outline_rounded,
                                  size: 32,
                                )),
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
              // General Search Card

              SizedBox(
                width: Get.width * 0.915,
                height: Get.height * 0.15,
                child: NavigationCard(
                  iconPath: "assets/icons/general_search.png",
                  title: 'General Search',
                  color: Colors.blue,
                  onTap: () => _navigateToScreen(
                    context,
                    HomeContent(
                      analyticsService: analyticsService,
                    ),
                    Offset(1.0, 0.0),
                  ),
                ),
              ),
              // Other Cards
              SizedBox(
                height: Get.height * 0.47,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      NavigationCard(
                        title: 'Parametric Search',
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
              ),
              // Recent Search Section
              Padding(
                padding: const EdgeInsets.only(
                    top: 0, left: 16, right: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Recent Search',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            // Navigate to see all recent searches
                          },
                          child: Text(
                            'See All',
                            style: GoogleFonts.poppins(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recentSearches.length,
                      itemBuilder: (context, index) {
                     //   final keyword = recentSearches.keys.elementAt(index);
                    //    final timestamp = recentSearches[keyword];
                        final dateTime = DateTime.parse(DateTime.now().toString());

                        // Manually format DateTime
                        String formattedTime =
                            "${dateTime.day}-${dateTime.month}-${dateTime.year} "
                            "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} "
                            "${dateTime.hour >= 12 ? 'PM' : 'AM'}";

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: ListTile(
                            tileColor: Colors.blue.withOpacity(0.05),
                            leading: Icon(Icons.search),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            title: Text(
                              recentSearches[index],
                              style: GoogleFonts.poppins(),
                            ),
                            trailing: Text(formattedTime),
                            onTap: () {
                              // Handle recent search tap
                            },
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
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
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: widget.color.withOpacity(0.1),
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
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
