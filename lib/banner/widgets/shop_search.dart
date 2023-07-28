import 'package:flutter/cupertino.dart';
import 'package:foodpanda_admin/models/shop.dart';
import 'package:foodpanda_admin/shop/widgets/restaurant_card.dart';

class ShopSearch extends StatelessWidget {
  final List<Shop> shops;
  final String search;
  final Function(String, String) onShopClick;

  const ShopSearch({
    super.key,
    required this.shops,
    required this.search,
    required this.onShopClick,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${shops.length} results for \'$search\'',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: shops.length,
              itemBuilder: ((context, index) {
                final shop = shops[index];
                return GestureDetector(
                  onTap: () => onShopClick(shop.uid, shop.shopName),
                  child: RestaurantCard(shop: shop),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
