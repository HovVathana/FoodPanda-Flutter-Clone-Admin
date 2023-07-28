import 'package:flutter/material.dart';
import 'package:foodpanda_admin/banner/controllers/banner_controller.dart';
import 'package:foodpanda_admin/banner/screen/add_banner_screen.dart';
import 'package:foodpanda_admin/constants/colors.dart';
import 'package:foodpanda_admin/models/banner.dart' as model;
import 'package:foodpanda_admin/widgets/my_alert_dialog.dart';

class BannerScreen extends StatefulWidget {
  static const String routeName = '/banner-screen';
  const BannerScreen({super.key});

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  BannerController bannerController = BannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Banners',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AddBannerScreen.routeName);
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'All Banners',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              StreamBuilder<List<model.Banner>>(
                  stream: bannerController.fetchBanner(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('loading');
                    }

                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final banner = snapshot.data![index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey[200]!),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(1, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 150,
                                      child: AspectRatio(
                                        aspectRatio: 4 / 5,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image:
                                                  NetworkImage(banner.imageUrl)
                                                      as ImageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            banner.description,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              const Text(
                                                'Approved',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Switch(
                                                value: banner.isApproved,
                                                activeColor: scheme.primary,
                                                onChanged: (value) async {
                                                  await bannerController
                                                      .changeBannerApproved(
                                                          bannerId: banner.id,
                                                          isApproved: value);
                                                },
                                              ),
                                              const SizedBox(width: 10),
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return MyAlertDialog(
                                                            title: 'Delete',
                                                            subtitle:
                                                                'Are you sure to delete this banner?',
                                                            action1Name:
                                                                'Cancel',
                                                            action2Name:
                                                                'Confirm',
                                                            action1Func: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            action2Func:
                                                                () async {
                                                              Navigator.pop(
                                                                  context);
                                                              await bannerController
                                                                  .deleteBanner(
                                                                bannerId:
                                                                    banner.id,
                                                              );
                                                            });
                                                      });
                                                },
                                                child: Icon(
                                                  Icons.delete_outline_outlined,
                                                  color: scheme.primary,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                            ],
                          );
                        });
                  }),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AddBannerScreen.routeName);
                },
                splashColor: scheme.primary.withOpacity(1),
                child: Ink(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: scheme.primary.withOpacity(0.5),
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    color: scheme.primary,
                    size: 50,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
