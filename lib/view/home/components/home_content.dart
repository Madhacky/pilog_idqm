import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilog_idqm/controller/client_mgr_home_controller.dart';
import 'package:pilog_idqm/global/app_colors.dart';
import 'package:pilog_idqm/view/home/components/home_loading_shimmer.dart';
import 'animated_search_bar.dart';
import 'asset_grid.dart';
import 'welcome_animation.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;

    return PopScope(
        canPop: true,
        child: GetBuilder<ClientMgrHomeController>(
            init: ClientMgrHomeController(),
            builder: (controller) {
              return Scaffold(
                backgroundColor: AppColors.white,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  toolbarHeight: 80,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: SafeArea(
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {Navigator.pop(context);},
                            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                        AnimatedSearchBar(controller: controller),
                      ],
                    ),
                  ),
                ),
                body: Obx(
                  () => controller.isAssetDataLoaded.value
                      ? _buildAssetData(context, isTablet, controller)
                      : const WelcomeAnimation(),
                ),
              );
            }));
  }

  Widget _buildAssetData(
      BuildContext context, bool isTablet, ClientMgrHomeController controller) {
    return FutureBuilder(
      future: controller.getAssetdataFuture,
      initialData: const WelcomeAnimation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingShimmer();
        }

        if (snapshot.hasError) {
          return _buildErrorState();
        }

        return AssetGrid(
          data: snapshot.data,
          isTablet: isTablet,
        );
      },
    );
  }

  Widget _buildLoadingShimmer() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AssetDataCardShimmer(),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return const Center(
      child: Image(
        image: AssetImage('assets/images/not_found.png'),
        fit: BoxFit.contain,
      ),
    );
  }
}
