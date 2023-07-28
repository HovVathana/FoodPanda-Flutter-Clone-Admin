import 'package:flutter/material.dart';
import 'package:foodpanda_admin/constants/colors.dart';
import 'package:foodpanda_admin/shop/controllers/shop_controller.dart';
import 'package:foodpanda_admin/shop/widgets/my_dismissible.dart';

class CategoryCard extends StatefulWidget {
  final String sellerId;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final VoidCallback? onEditTap;
  final VoidCallback? onDeleteTap;
  final String? id;
  bool? isPublished;
  CategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.onEditTap,
    this.id,
    this.onDeleteTap,
    this.isPublished,
    required this.sellerId,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  ShopController shopController = ShopController();

  changeIsPublished(bool value) async {
    await shopController.changeIsPublished(
      sellerId: widget.sellerId,
      id: widget.id!,
      isPublished: value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyDismissible(
      id: widget.id,
      onDeleteTap: widget.onDeleteTap,
      onEditTap: widget.onEditTap,
      children: InkWell(
        onTap: widget.onTap,
        splashColor: Colors.white.withOpacity(0.2),
        child: Ink(
          width: double.infinity,
          height: widget.isPublished != null ? 110 : 100,
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 150,
                      child: Text(
                        widget.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 150,
                      child: Text(
                        widget.subtitle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    widget.isPublished != null
                        ? Row(
                            children: [
                              Switch(
                                value: widget.isPublished!,
                                activeColor: Colors.white,
                                onChanged: (value) {
                                  setState(() {
                                    widget.isPublished = value;
                                  });
                                  changeIsPublished(value);
                                },
                              ),
                              const Text(
                                'Published',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              Positioned(
                right: 10,
                bottom: 0,
                child: Image.asset(
                  'assets/images/panda_eating.png',
                  height: 90,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
