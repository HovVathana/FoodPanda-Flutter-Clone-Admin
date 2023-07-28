import 'package:flutter/material.dart';
import 'package:foodpanda_admin/banner/screen/banner_screen.dart';
import 'package:foodpanda_admin/constants/colors.dart';
import 'package:foodpanda_admin/home/widgets/my_drawer.dart';
import 'package:foodpanda_admin/providers/authentication_provider.dart';
import 'package:foodpanda_admin/shop/screens/shop_screen.dart';
import 'package:foodpanda_admin/voucher/screens/voucher_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final ap = context.watch<AuthenticationProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: scheme.primary,
        title: const Text(
          'FoodPanda Admin',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      drawer: MyDrawer(parentContext: context),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome ${ap.name}',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                collageItem(
                  height: height,
                  iconData: Icons.add_chart_outlined,
                  title: 'Dashboard',
                  onTap: () {},
                ),
                const SizedBox(width: 8),
                collageItem(
                  height: height,
                  iconData: Icons.local_offer_outlined,
                  title: 'Voucher',
                  onTap: () {
                    Navigator.pushNamed(context, VoucherScreen.routeName);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                collageItem(
                  height: height,
                  iconData: Icons.food_bank_outlined,
                  title: 'Shops',
                  onTap: () {
                    Navigator.pushNamed(context, ShopScreen.routeName);
                  },
                ),
                const SizedBox(width: 8),
                collageItem(
                  height: height,
                  iconData: Icons.delivery_dining_outlined,
                  title: 'Riders',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                collageItem(
                  height: height,
                  iconData: Icons.photo_size_select_actual_outlined,
                  title: 'Banners',
                  onTap: () {
                    Navigator.pushNamed(context, BannerScreen.routeName);
                  },
                ),
                // const SizedBox(width: 8),
                // collageItem(
                //   height: height,
                //   iconData: Icons.delivery_dining_outlined,
                //   title: 'Riders',
                //   onTap: () {},
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Expanded collageItem({
    required double height,
    required IconData iconData,
    required String title,
    required VoidCallback onTap,
    int alert = 0,
  }) {
    return Expanded(
      child: InkWell(
        splashColor: scheme.primary.withOpacity(0.2),
        onTap: onTap,
        child: Ink(
          height: height * 0.17,
          decoration: BoxDecoration(
            color: MyColors.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              children: [
                alert > 0
                    ? Positioned(
                        top: 20,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: scheme.primary,
                          radius: 13,
                          child: Text(
                            alert.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      iconData,
                      color: scheme.primary,
                      size: 40,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
