import 'package:flutter/material.dart';
import 'package:foodpanda_admin/models/food.dart';
import 'package:foodpanda_admin/models/shop.dart';
import 'package:foodpanda_admin/shop/controllers/shop_controller.dart';
import 'package:foodpanda_admin/shop/screens/add_food_screen.dart';
import 'package:foodpanda_admin/shop/widgets/food_card.dart';

class FoodScreen extends StatefulWidget {
  static const String routeName = '/food-screen';
  final Shop shop;
  final String id;
  const FoodScreen({super.key, required this.id, required this.shop});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  ShopController shopController = ShopController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Foods',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AddFoodScreen.routeName,
                arguments: AddFoodScreen(
                  shop: widget.shop,
                  id: widget.id,
                ),
              );
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
              Text(
                widget.shop.shopName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const Text(
                'All Foods',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              StreamBuilder<List<Food>>(
                stream: shopController.fetchFood(
                    sellerId: widget.shop.uid, categoryId: widget.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('loading');
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final food = snapshot.data![index];
                        return Column(
                          children: [
                            FoodCard(
                              title: food.name,
                              subtitle: food.description,
                              price: food.price,
                              id: food.id,
                              sellerId: widget.shop.uid,
                              categoryId: widget.id,
                              comparePrice: food.comparePrice == 0.0
                                  ? null
                                  : food.comparePrice,
                              image: food.image,
                              isPublished: food.isPublished,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AddFoodScreen.routeName,
                                  arguments: AddFoodScreen(
                                    shop: widget.shop,
                                    id: widget.id,
                                    foodId: food.id,
                                  ),
                                );
                              },
                              onEditTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AddFoodScreen.routeName,
                                  arguments: AddFoodScreen(
                                    shop: widget.shop,
                                    id: widget.id,
                                    foodId: food.id,
                                  ),
                                );
                              },
                              onDeleteTap: () async {
                                await shopController.deleteFood(
                                  sellerId: widget.shop.uid,
                                  categoryId: widget.id,
                                  id: food.id,
                                );
                              },
                            ),
                            index != snapshot.data!.length - 1
                                ? Divider(
                                    color: Colors.grey[400]!,
                                  )
                                : const SizedBox(),
                          ],
                        );
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
