import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodpanda_admin/constants/colors.dart';
import 'package:foodpanda_admin/models/shop.dart';

class RestaurantCard extends StatelessWidget {
  final Shop shop;
  const RestaurantCard({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                fit: BoxFit.cover,
                height: 150,
                width: double.infinity,
                image: NetworkImage(shop.shopImage),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              shop.shopName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              children: [
                RatingBarIndicator(
                  rating: shop.rating,
                  itemCount: 1,
                  itemSize: 19,
                  direction: Axis.horizontal,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  shop.rating.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '(${shop.totalRating})',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '\$ • ${shop.shopDescription}',
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${shop.houseNumber} ${shop.street} ${shop.province}',
          style: TextStyle(
            color: scheme.primary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}
