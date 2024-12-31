import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pilog_idqm/controller/client_mgr_home_controller.dart';
import 'package:pilog_idqm/global/app_colors.dart';
import 'package:pilog_idqm/view/home/asset_detail/tabs/pdf_summary_extractor.dart';
import 'tabs/information_tab.dart';
import 'tabs/attachments_tab.dart';
import 'widgets/asset_detail_app_bar.dart';

class AssetDetailScreen extends StatefulWidget {
  final String? classTerm;
  final String? recordNo;
  final String? shortDescription;
  final String? longDesc;
  final String? status;
  final String? imageName;
  final String? equipmentNo;
  final String? techID;
  final String? lat;
  final String? lng;

  const AssetDetailScreen({
    super.key,
    this.recordNo,
    this.classTerm,
    this.shortDescription,
    this.longDesc,
    this.status,
    this.imageName,
    this.equipmentNo,
    this.techID,
    this.lat,
    this.lng,
  });

  @override
  State<AssetDetailScreen> createState() => _AssetDetailScreenState();
}

class _AssetDetailScreenState extends State<AssetDetailScreen> with SingleTickerProviderStateMixin {
  final ClientMgrHomeController controller = Get.find<ClientMgrHomeController>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.absoluteWhite,
      appBar: AssetDetailAppBar(
        title: widget.classTerm ?? "Asset Details",
        tabController: _tabController,
      ),
      body: LoaderOverlay(
        useDefaultLoading: true,
        child: TabBarView(
          controller: _tabController,
          children: [
            InformationTab(
              classTerm: widget.classTerm,
              recordNo: widget.recordNo,
              equipmentNo: widget.equipmentNo,
              techID: widget.techID,
              shortDescription: widget.shortDescription,
              longDesc: widget.longDesc,
              status: widget.status,
            ),
            AttachmentsTab(
              recordNo: widget.recordNo ?? '',
              controller: controller,
            ),
             PdfSummaryScreen()
          ],
        ),
      ),
    );
  }
}