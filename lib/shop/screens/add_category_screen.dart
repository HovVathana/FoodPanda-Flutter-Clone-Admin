import 'package:flutter/material.dart';
import 'package:foodpanda_admin/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_admin/constants/colors.dart';
import 'package:foodpanda_admin/models/shop.dart';
import 'package:foodpanda_admin/providers/internet_provider.dart';
import 'package:foodpanda_admin/shop/controllers/shop_controller.dart';
import 'package:foodpanda_admin/shop/widgets/category_card.dart';
import 'package:foodpanda_admin/widgets/custom_textfield.dart';
import 'package:foodpanda_admin/widgets/my_snack_bar.dart';
import 'package:provider/provider.dart';

class AddCategoryScreen extends StatefulWidget {
  static const String routeName = '/add-category-screen';
  final Shop shop;
  final String title;
  final String subtitle;
  final String id;

  const AddCategoryScreen({
    super.key,
    this.title = '',
    this.subtitle = '',
    required this.id,
    required this.shop,
  });

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  String titleText = '';
  String subtitleText = '';

  @override
  void initState() {
    super.initState();
    if (widget.title.isNotEmpty && widget.subtitle.isNotEmpty) {
      titleController.text = widget.title;
      subtitleController.text = widget.subtitle;
      titleText = widget.title;
      subtitleText = widget.subtitle;
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    subtitleController.dispose();
  }

  ShopController shopController = ShopController();

  handleAddCategory() async {
    final internetProvider = context.read<InternetProvider>();

    await internetProvider.checkInternetConnection();
    if (internetProvider.hasInternet == false) {
      Navigator.pop(context);
      openSnackbar(context, 'Check your internet connection', scheme.primary);
    } else {
      await shopController.addNewCategory(
        sellerId: widget.shop.uid,
        title: titleController.text.trim().toString(),
        subtitle: subtitleController.text.trim().toString(),
        id: widget.id.isEmpty ? null : widget.id,
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Add Category',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: titleText.isEmpty || subtitleText.isEmpty
                ? null
                : handleAddCategory,
            icon: Icon(
              Icons.add,
              color: titleText.isEmpty || subtitleText.isEmpty
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
                      'Add New Category',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      controller: titleController,
                      labelText: 'Title',
                      onChanged: (value) {
                        setState(
                          () {
                            titleText = value;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      controller: subtitleController,
                      labelText: 'Subtitle',
                      onChanged: (value) {
                        setState(
                          () {
                            subtitleText = value;
                          },
                        );
                      },
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
                    CategoryCard(
                      sellerId: widget.shop.uid,
                      title: titleText,
                      subtitle: subtitleText,
                      onTap: () {},
                    ),
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
              isDisabled: titleText.isEmpty || subtitleText.isEmpty,
            ),
          ],
        ),
      ),
    );
  }
}
