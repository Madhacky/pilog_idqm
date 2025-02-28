import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pilog_idqm/controller/floc_controller.dart';
import 'package:pilog_idqm/controller/parametric_search_controller.dart';
import 'package:pilog_idqm/global/app_colors.dart';
import 'package:pilog_idqm/view/home/components/asset_data_card.dart';
import 'package:pilog_idqm/view/home/components/home_loading_shimmer.dart';

class FlocSearchResultScreen extends StatefulWidget {
  final String flocID;
  const FlocSearchResultScreen({super.key, required this.flocID});

  @override
  State<FlocSearchResultScreen> createState() => _FlocSearchResultScreenState();
}

class _FlocSearchResultScreenState extends State<FlocSearchResultScreen> {
  FlocController? controller;
  @override
  void initState() {
    controller = Get.find<FlocController>();
    controller?.getFlocSearchResultFuture =
        controller!.getFlocData(widget.flocID);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.white,
        appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading:     IconButton(
                            onPressed: () {Navigator.pop(context);},
                            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: const Text('FLOC Search Results',
            style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w600)),
      ),
        body: FutureBuilder<List<AssetDataCard>>(
          future: controller!.getFlocSearchResultFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: loadingShimmer());
            } else if (snapshot.hasError) {
              return const Center(
                  child:
                      Image(image: AssetImage('assets/images/not_found.png')));
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
