import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pilog_idqm/controller/parametric_search_controller.dart';
import 'package:pilog_idqm/global/app_styles.dart';
import 'package:pilog_idqm/view/home/components/asset_data_card.dart';
import 'package:pilog_idqm/view/home/components/home_loading_shimmer.dart';

class ParametricSearchResultScreen extends StatefulWidget {
  const ParametricSearchResultScreen({super.key});

  @override
  State<ParametricSearchResultScreen> createState() =>
      _ParametricSearchResultScreenState();
}

class _ParametricSearchResultScreenState
    extends State<ParametricSearchResultScreen> {
  ParametricSearchController? controller;
  @override
  void initState() {
    controller = Get.find<ParametricSearchController>();
    controller?.getParametricSearchResultFuture=controller!.parametricSearch();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(  appBar: AppBar(
        title: Text("Parametric Search Results",   style: AppStyles.black_20_600,),
        backgroundColor: const Color(0xff7165E3),
      ),
        body: FutureBuilder<List<AssetDataCard>>(
      future: controller?.getParametricSearchResultFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: loadingShimmer());
        } else if (snapshot.hasError) {
          return const Center(
              child: Image(image: AssetImage('assets/images/not_found.png')));
        } else {
          return ListView(
            children: snapshot.data!.map<Widget>((item) {
              return GestureDetector(
                onTap: () {},
                child: DelayedDisplay(
                  child: Column(
                    children: [item],
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    ));
  }

  Widget loadingShimmer() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(child: AssetDataCardShimmer()),
          SizedBox(child: AssetDataCardShimmer()),
          SizedBox(child: AssetDataCardShimmer()),
        ],
      ),
    );
  }
}
