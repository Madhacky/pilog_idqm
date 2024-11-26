

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AssetDataCardShimmer extends StatelessWidget {
  const AssetDataCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 150,
                    height: 20,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(5, (index) => _buildShimmerRow()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.grey[300],
          ),
          const SizedBox(width: 8),
          Container(
            width: 100,
            height: 16,
            color: Colors.grey[300],
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              height: 16,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}
