import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_admin/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_admin/constants/colors.dart';
import 'package:foodpanda_admin/models/food.dart';
import 'package:foodpanda_admin/models/shop.dart';
import 'package:foodpanda_admin/providers/internet_provider.dart';
import 'package:foodpanda_admin/shop/controllers/shop_controller.dart';
import 'package:foodpanda_admin/shop/widgets/food_card.dart';
import 'package:foodpanda_admin/widgets/custom_textfield.dart';
import 'package:foodpanda_admin/widgets/ficon_button.dart';
import 'package:foodpanda_admin/widgets/my_snack_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddFoodScreen extends StatefulWidget {
  static const String routeName = '/add-food-screen';
  final Shop shop;
  final String id;
  final String? foodId;

  const AddFoodScreen({
    super.key,
    required this.id,
    this.foodId,
    required this.shop,
  });

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController comparePriceController = TextEditingController();

  String nameText = '';
  String descriptionText = '';
  double priceText = 0;
  double? comparePriceText = 0;
  String imageUrl = '';

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  ShopController shopController = ShopController();

  Future getFoodById() async {
    Food? food = await shopController.fetchFoodById(
      sellerId: widget.shop.uid,
      categoryId: widget.id,
      id: widget.foodId!,
    );
    setState(() {
      nameController.text = food!.name;
      descriptionController.text = food.description;
      priceController.text = food.price.toString();
      comparePriceController.text = food.comparePrice.toString();
      nameText = food.name;
      descriptionText = food.description;
      priceText = food.price;
      comparePriceText = food.comparePrice;
      imageUrl = food.image;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.foodId != null) {
      getFoodById();
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    comparePriceController.dispose();
  }

  handleAddCategory() async {
    final internetProvider = context.read<InternetProvider>();

    await internetProvider.checkInternetConnection();
    if (internetProvider.hasInternet == false) {
      Navigator.pop(context);
      openSnackbar(context, 'Check your internet connection', scheme.primary);
    } else {
      await shopController.addNewFood(
        sellerId: widget.shop.uid,
        categoryId: widget.id,
        name: nameController.text.trim().toString(),
        description: descriptionController.text.trim().toString(),
        price: double.parse(priceController.text),
        comparePrice: double.parse(comparePriceController.text),
        imageFile: imageXFile,
        imageUrl: imageUrl == '' ? null : imageUrl,
        foodId: widget.foodId,
      );

      Navigator.pop(context);
    }
  }

  takePhoto() async {
    imageXFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  uploadPhoto() async {
    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Add Food',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: !(nameText.isNotEmpty &&
                    descriptionText.isNotEmpty &&
                    priceText != 0 &&
                    ((imageUrl.isEmpty && imageXFile != null) ||
                        (imageUrl.isNotEmpty && imageXFile == null)))
                ? null
                : handleAddCategory,
            icon: Icon(
              Icons.add,
              color: !(nameText.isNotEmpty &&
                      descriptionText.isNotEmpty &&
                      priceText != 0 &&
                      ((imageUrl.isEmpty && imageXFile != null) ||
                          (imageUrl.isNotEmpty && imageXFile == null)))
                  ? Colors.grey[400]
                  : Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Add New Food',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      controller: nameController,
                      labelText: 'Name',
                      onChanged: (value) {
                        setState(
                          () {
                            nameText = value;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      controller: descriptionController,
                      labelText: 'Description',
                      onChanged: (value) {
                        setState(
                          () {
                            descriptionText = value;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Price is in dollar USD currency.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 15,
                          padding: const EdgeInsets.only(right: 7),
                          child: CustomTextField(
                            controller: priceController,
                            labelText: 'Price',
                            isNumPad: true,
                            onChanged: (value) {
                              setState(() {
                                priceText =
                                    value.isEmpty ? 0 : double.parse(value);
                              });
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 15,
                          padding: const EdgeInsets.only(left: 7),
                          child: CustomTextField(
                            controller: comparePriceController,
                            labelText: 'Old Price',
                            isNumPad: true,
                            onChanged: (value) {
                              setState(() {
                                comparePriceText =
                                    value.isEmpty ? null : double.parse(value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Food image',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    imageXFile == null && imageUrl.isEmpty
                        ? DottedBorder(
                            color: Colors.grey[500]!,
                            strokeWidth: 1,
                            dashPattern: const [10, 6],
                            child: SizedBox(
                              height: 180,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.camera_alt_outlined,
                                    size: 70,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        child: CustomTextButton(
                                          text: 'Take a photo',
                                          onPressed: takePhoto,
                                          isDisabled: false,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: CustomTextButton(
                                          text: 'Upload a photo',
                                          onPressed: uploadPhoto,
                                          isDisabled: false,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        : DottedBorder(
                            color: Colors.grey[500]!,
                            strokeWidth: 1,
                            dashPattern: const [10, 6],
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 180,
                                    child: Center(
                                      child: Stack(
                                        children: [
                                          AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageUrl == ''
                                                      ? FileImage(
                                                          File(
                                                              imageXFile!.path),
                                                        )
                                                      : NetworkImage(imageUrl)
                                                          as ImageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: FIconButton(
                                              icon: const Icon(Icons.close),
                                              backgroundColor: Colors.white,
                                              onPressed: () {
                                                setState(() {
                                                  imageUrl = '';
                                                  imageXFile = null;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    const SizedBox(height: 50),
                    const Text(
                      'Preview',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    FoodCard(
                      sellerId: widget.shop.uid,
                      title: nameText,
                      subtitle: descriptionText,
                      price: priceText,
                      comparePrice:
                          comparePriceText == 0.0 ? null : comparePriceText,
                      image: imageUrl,
                      imageFile: imageXFile != null ? imageXFile : null,
                      onTap: () {},
                    )
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            CustomTextButton(
              text: 'Confirm',
              onPressed: handleAddCategory,
              isDisabled: !(nameText.isNotEmpty &&
                  descriptionText.isNotEmpty &&
                  priceText != 0 &&
                  ((imageUrl.isEmpty && imageXFile != null) ||
                      (imageUrl.isNotEmpty && imageXFile == null))),
            ),
          ],
        ),
      ),
    );
  }
}
