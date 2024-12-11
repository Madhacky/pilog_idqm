import 'dart:convert'; // For JSON encoding
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pilog_idqm/view/home/components/assest_details_screen.dart';

class AssetDataCard extends StatefulWidget {
  final String? classTerm;
  final String? recordNo;
  final String? shortDescription;
  final String? longDesc;
  final String? status;
  final String? imageName;
  final String? equipmentNumber;
  final String? techId;
  final String? lat;
  final String? long;
  final String? floc;
final String? floc_desc;
  const AssetDataCard({
    super.key,
    this.recordNo,
    this.classTerm,
    this.shortDescription,
    this.longDesc,
    this.status,
    this.imageName,
    this.equipmentNumber,
    this.techId,
    this.lat,
    this.long,
    this.floc, this.floc_desc,
  });

  @override
  State<AssetDataCard> createState() => _AssetDataCardState();
}

class _AssetDataCardState extends State<AssetDataCard> {
  bool isFavorite = false; // Track favorite status

  Future<void> _saveToFavorites() async {
    // Convert card data to a map
    final cardData = {
      "classTerm": widget.classTerm,
      "recordNo": widget.recordNo,
      "shortDescription": widget.shortDescription,
      "longDesc": widget.longDesc,
      "status": widget.status,
      "imageName": widget.imageName,
      "equipmentNumber": widget.equipmentNumber,
      "techId": widget.techId,
      "lat": widget.lat,
      "long": widget.long,
      "floc": widget.floc,
    };

    // Access shared preferences
    final prefs = await SharedPreferences.getInstance();

    // Retrieve existing favorites or initialize as empty list
    final List<String> favorites =
        prefs.getStringList('favorites') ?? [];

    // Check if an item with the same techId already exists
    final bool alreadyExists = favorites.any((item) {
      final existingItem = jsonDecode(item);
      return existingItem['techId'] == widget.techId;
    });

    if (alreadyExists) {
      // Show SnackBar if the item is already saved
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item already saved!")),
      );
      return;
    }

    // Add the new card data as a JSON string
    favorites.add(jsonEncode(cardData));

    // Save updated list to shared preferences
    await prefs.setStringList('favorites', favorites);

    // Update UI
    setState(() {
      isFavorite = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Added to Favorites!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        CupertinoPageRoute<bool>(
          builder: (_) => AssetDetailsScreen(
            classTerm: widget.classTerm,
            longDesc: widget.longDesc,
            recordNo: widget.recordNo,
            shortDescription: widget.shortDescription,
            status: widget.status,
            imageName: widget.imageName,
            equipmentNo: widget.equipmentNumber,
            techID: widget.techId,
            lat: widget.lat,
            lng: widget.long,
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
            child: Card(
              elevation: 6,
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
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff7165E3), Colors.indigo],
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
                            widget.classTerm ?? "",
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
                        _buildInfoRow("TECH ID", widget.techId,16),
                        const SizedBox(height: 5),
                        _buildInfoRow("EQUIPMENT NO", widget.equipmentNumber,16),
                        const SizedBox(height: 5),
                        _buildInfoRow("FLOC", widget.floc,16),
                         _buildInfoRow("FLOC DESC", widget.floc_desc,14),
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
}
