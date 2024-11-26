import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilog_idqm/controller/floc_controller.dart';
import 'package:pilog_idqm/global/app_styles.dart';
import 'package:pilog_idqm/view/floc%20search/floc_search_result.dart';
import 'package:shimmer/shimmer.dart';

class FLOCOperation extends StatefulWidget {
  const FLOCOperation({
    super.key,
  });

  @override
  State<FLOCOperation> createState() => _FLOCOperationState();
}

class _FLOCOperationState extends State<FLOCOperation> {
  final controller = Get.put(FlocController());

  @override
  void initState() {
    super.initState();
    // Fetch the FLOC data when the widget initializes
    controller.getFlocIdsFuture = controller.getFlocInfoApi().then((value) {
      // Call _filterFLOC with an empty query after the data is loaded
      controller.filterFLOC('');
      return [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'FLOC Search',
          style: AppStyles.black_20_600,
        ),
        backgroundColor: const Color(0xff7165E3), // AppBar background color
      ),
      body: Column(
        children: [
          buildSearchBar(),
          Expanded(
            child: FutureBuilder(
              future: controller.getFlocIdsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return buildShimmer();
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Image(
                          image: AssetImage('assets/images/not_found.png')));
                } else if (snapshot.hasData) {
                  // Return the filtered list in the ListView
                  return buildFlocInfoCard();
                }
                return const SizedBox
                    .shrink(); // In case of no data, return empty
              },
            ),
          ),
        ],
      ),
    );
  }

  buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white, // Background color of the search bar
        borderRadius: BorderRadius.circular(30.0), // Rounded corners
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0, // Blur for shadow effect
            offset: Offset(0, 4), // Position of the shadow
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search FLOC...',
          border: InputBorder.none,
          icon: Icon(
            Icons.search,
            color: Colors.grey[600], // Search icon color
          ),
          hintStyle: TextStyle(color: Colors.grey[600]), // Hint text color
        ),
        onChanged: (value) {
          controller
              .filterFLOC(value); // Update the search query and filter the list
        },
      ),
    );
  }

  buildFlocInfoCard() {
    return Obx(() => ListView.builder(
          itemCount: controller.filteredFLOCEntries.length,
          itemBuilder: (context, index) {
            final entry = controller.filteredFLOCEntries[index];
            return InkWell(
              splashColor: Colors.greenAccent,
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute<bool>(
                        builder: (_) => FlocSearchResultScreen(
                              flocID: entry.key.toUpperCase(),
                            )));
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                child: Card(
                  elevation: 4.0, // Elevation for shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0), // Content padding inside the ListTile
                    leading: CircleAvatar(
                      backgroundColor: const Color(
                          0xff7165E3), // Custom background color for avatar
                      foregroundColor: Colors.white,
                      child: Text(entry.key[0].toUpperCase()),
                    ),
                    title: Text(
                      entry.key.toUpperCase(), // FLOC value
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    trailing: Text(
                      ' ${entry.value}', // Occurrence count
                      style: AppStyles.black_14_500,
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }

  Widget buildShimmer() {
    return ListView.builder(
      itemCount: 10, // You can display multiple shimmer items while loading
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[400]!,
                ),
                title: Container(
                  width: 100,
                  height: 16,
                  color: Colors.grey[400], // Placeholder for title
                ),
                trailing: Container(
                  width: 50,
                  height: 14,
                  color: Colors.grey[400], // Placeholder for trailing text
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
