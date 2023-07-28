import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodpanda_admin/constants/colors.dart';
import 'package:foodpanda_admin/shop/controllers/shop_controller.dart';
import 'package:foodpanda_admin/shop/widgets/my_dismissible.dart';
import 'package:foodpanda_admin/widgets/ficon_button.dart';
import 'package:image_picker/image_picker.dart';

class FoodCard extends StatefulWidget {
  final String sellerId;
  final String title;
  final String subtitle;
  final double price;
  final double? comparePrice;
  final String image;
  final VoidCallback onTap;
  final String? id;
  final VoidCallback? onEditTap;
  final VoidCallback? onDeleteTap;
  XFile? imageFile;
  bool? isPublished;
  String? categoryId;

  FoodCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    this.comparePrice,
    required this.image,
    required this.onTap,
    this.imageFile,
    this.id,
    this.onEditTap,
    this.onDeleteTap,
    this.isPublished,
    this.categoryId,
    required this.sellerId,
  });

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  ShopController shopController = ShopController();

  changeIsPublished(bool value) async {
    await shopController.changeIsPublishedFood(
      sellerId: widget.sellerId,
      id: widget.id!,
      categoryId: widget.categoryId!,
      isPublished: value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyDismissible(
      id: widget.id,
      onEditTap: widget.onEditTap,
      onDeleteTap: widget.onDeleteTap,
      dialogSubtitle: 'Are you sure to delete this food item?',
      children: InkWell(
        onTap: widget.onTap,
        splashColor: scheme.primary.withOpacity(0.2),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              widget.subtitle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600]!,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Text(
                                  'from \$ ${widget.price}',
                                ),
                                const SizedBox(width: 8.0),
                                widget.comparePrice != null
                                    ? Text(
                                        '\$ ${widget.comparePrice}',
                                        style: TextStyle(
                                          color: Colors.grey[600]!,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            widget.isPublished != null
                                ? Row(
                                    children: [
                                      Switch(
                                        value: widget.isPublished!,
                                        activeColor: scheme.primary,
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
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: scheme.primary,
                          image: DecorationImage(
                            image: widget.imageFile == null
                                ? NetworkImage(
                                    widget.image,
                                  )
                                : FileImage(File(widget.imageFile!.path))
                                    as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: -4,
              child: FIconButton(
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: scheme.primary,
                onPressed: () {
                  // if (widget.id != null && widget.categoryId != null) {
                  //   Navigator.pushNamed(
                  //     context,
                  //     AddCustomizationScreen.routeName,
                  //     arguments: AddCustomizationScreen(
                  //       categoryId: widget.categoryId!,
                  //       foodId: widget.id!,
                  //     ),
                  //   );
                  // }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
