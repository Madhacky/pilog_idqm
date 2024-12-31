import 'package:flutter/material.dart';
import 'package:pilog_idqm/global/app_colors.dart';
import 'package:pilog_idqm/global/app_styles.dart';

class AssetDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TabController tabController;

  const AssetDetailAppBar({
    super.key,
    required this.title,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: AppStyles.black_20_600,
      ),
      backgroundColor: Colors.transparent,
      bottom: TabBar(
        controller: tabController,
        tabs: const [
          Tab(text: "Information"),
          Tab(text: "Attachments"),
          Tab(text: "Pdf Summary Extractor",)
        ],
        labelColor: AppColors.absoluteBlack,
        indicatorColor: AppColors.blueShadeGradiant,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);
}