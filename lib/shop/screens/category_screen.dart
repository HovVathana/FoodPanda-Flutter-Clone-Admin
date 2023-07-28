import 'package:flutter/material.dart';
import 'package:foodpanda_admin/constants/colors.dart';
import 'package:foodpanda_admin/models/category.dart';
import 'package:foodpanda_admin/models/shop.dart';
import 'package:foodpanda_admin/shop/controllers/shop_controller.dart';
import 'package:foodpanda_admin/shop/screens/add_category_screen.dart';
import 'package:foodpanda_admin/shop/screens/food_screen.dart';
import 'package:foodpanda_admin/shop/widgets/category_card.dart';

class CategoryScreen extends StatefulWidget {
  static const String routeName = '/menu-screen';
  final Shop shop;
  const CategoryScreen({super.key, required this.shop});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  ShopController shopController = ShopController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Categories',
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
                AddCategoryScreen.routeName,
                arguments: AddCategoryScreen(
                  shop: widget.shop,
                  title: '',
                  subtitle: '',
                  id: '',
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
                'All Categories',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              StreamBuilder<List<Category>>(
                stream: shopController.fetchCategory(sellerId: widget.shop.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('loading');
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final category = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: CategoryCard(
                              title: category.title,
                              subtitle: category.subtitle,
                              sellerId: widget.shop.uid,
                              id: category.id,
                              isPublished: category.isPublished,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  FoodScreen.routeName,
                                  arguments: FoodScreen(
                                    id: category.id,
                                    shop: widget.shop,
                                  ),
                                );
                              },
                              onEditTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AddCategoryScreen.routeName,
                                  arguments: AddCategoryScreen(
                                    shop: widget.shop,
                                    title: category.title,
                                    subtitle: category.subtitle,
                                    id: category.id,
                                  ),
                                );
                              },
                              onDeleteTap: () async {
                                await shopController.deleteCategory(
                                  sellerId: widget.shop.uid,
                                  id: category.id,
                                );
                              }),
                        );
                      });
                },
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AddCategoryScreen.routeName,
                    arguments: AddCategoryScreen(
                      shop: widget.shop,
                      title: '',
                      subtitle: '',
                      id: '',
                    ),
                  );
                },
                splashColor: scheme.primary.withOpacity(1),
                child: Ink(
                  width: double.infinity,
                  height: 100,
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
