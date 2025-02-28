import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pilog_idqm/global/app_colors.dart';
import 'package:pilog_idqm/view/home/asset_detail/asset_detail_screen.dart';

// Split into separate model class for better organization
class AssetData {
  final String? classTerm, recordNo, shortDescription, longDesc, status;
  final String? imageName, equipmentNumber, techId, lat, long, floc, flocDesc;

  AssetData({
    this.classTerm,
    this.recordNo,
    this.shortDescription,
    this.longDesc,
    this.status,
    this.imageName,
    this.equipmentNumber,
    this.techId,
    this.lat,
    this.long,
    this.floc,
    this.flocDesc,
  });

  Map<String, dynamic> toJson() => {
    'classTerm': classTerm,
    'recordNo': recordNo,
    'techId': techId,
    // ... other fields
  };
}

// Main display widget with multiple layout options
class AssetDataCard extends StatefulWidget {
  final AssetData data;
  final DisplayType displayType;

  const AssetDataCard({
    super.key,
    required this.data,
    this.displayType = DisplayType.list, // Default to list view
  });

  @override
  State<AssetDataCard> createState() => _AssetDataCardState();
}

enum DisplayType { list, grid, table }

class _AssetDataCardState extends State<AssetDataCard> 
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.displayType) {
      case DisplayType.list:
        return _buildListView();
      case DisplayType.grid:
        return _buildGridView();
      case DisplayType.table:
        return _buildTableView();
    }
  }
Widget _buildListView() {
  return InkWell(
      onTap: () => Navigator.push(
        context,
        CupertinoPageRoute<bool>(
          builder: (_) => AssetDetailScreen(
            classTerm: widget.data.classTerm,
            longDesc: widget.data.longDesc,
            recordNo: widget.data.recordNo,
            shortDescription: widget.data.shortDescription,
            status: widget.data.status,
            imageName: widget.data.imageName,
            equipmentNo: widget.data.equipmentNumber,
            techID: widget.data.techId,
            lat: widget.data.lat,
            lng: widget.data.long,
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
            child: Card(
                  color: AppColors.white,
      elevation: 5,shadowColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with gradient background and title
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration:  const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.blueShadeGradiant, Colors.indigo],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        Center(
                          child: Text(
                            widget.data.classTerm ?? "",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffe8e7f4),
                            ),
                          ),
                        ),
                        SizedBox()
                        // IconButton(
                        //   icon: Icon(
                        //     isFavorite
                        //         ? Icons.star
                        //         : Icons.star_border_outlined,
                        //     color: isFavorite ? Colors.amber : Colors.white,
                        //   ),
                        //   onPressed: _saveToFavorites,
                        // ),
                      ],
                    ),
                  ),
                  // Content with information rows
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow("TECH ID", widget.data.techId,16),
                        const SizedBox(height: 5),
                        _buildInfoRow("EQUIPMENT NO", widget.data.equipmentNumber,16),
                        const SizedBox(height: 5),
                        _buildInfoRow("FLOC", widget.data.floc,16),
                         _buildInfoRow("FLOC DESC", widget.data.flocDesc,14),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    
}
  Widget _buildInfoRow(String label, String? value,double fontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Flexible(
            child: Tooltip(
              message: value ?? "",
              child: Text(
                value ?? "",
                style:  TextStyle(
                  fontSize:fontSize,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return GridTile(
      header: GridTileBar(
        title: Text(widget.data.classTerm ?? ''),
        backgroundColor: Colors.black45,
        trailing: IconButton(
          icon: Icon(isFavorite ? Icons.star : Icons.star_border),
          onPressed: () {/* Handle favorite */},
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('ID: ${widget.data.techId ?? ''}'),
            Text('Equip: ${widget.data.equipmentNumber ?? ''}'),
            Text('FLOC: ${widget.data.floc ?? ''}'),
          ],
        ),
      ),
    );
  }

  Widget _buildTableView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Tech ID')),
          DataColumn(label: Text('Equipment')),
          DataColumn(label: Text('FLOC')),
          DataColumn(label: Text('Description')),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text(widget.data.techId ?? '')),
            DataCell(Text(widget.data.equipmentNumber ?? '')),
            DataCell(Text(widget.data.floc ?? '')),
            DataCell(Text(widget.data.flocDesc ?? '')),
          ]),
        ],
      ),
    );
  }
}
