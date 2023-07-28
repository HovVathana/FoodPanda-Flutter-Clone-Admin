import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_admin/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_admin/banner/controllers/banner_controller.dart';
import 'package:foodpanda_admin/banner/screen/search_user_screen.dart';
import 'package:foodpanda_admin/banner/screen/select_voucher_screen.dart';
import 'package:foodpanda_admin/constants/colors.dart';
import 'package:foodpanda_admin/widgets/custom_textfield.dart';
import 'package:foodpanda_admin/widgets/ficon_button.dart';
import 'package:foodpanda_admin/widgets/my_snack_bar.dart';
import 'package:image_picker/image_picker.dart';

class AddBannerScreen extends StatefulWidget {
  static const String routeName = '/add-banner-screen';

  const AddBannerScreen({super.key});

  @override
  State<AddBannerScreen> createState() => _AddBannerScreenState();
}

class _AddBannerScreenState extends State<AddBannerScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  TextEditingController descriptionController = TextEditingController();
  String descriptionText = '';
  List<String> shopListId = [];
  List<String> shopListName = [];
  String voucherId = '';
  String voucherName = '';

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

  handleConfirm() async {
    BannerController bannerController = BannerController();
    await bannerController.createBanner(
      image: imageXFile!,
      description: descriptionController.text,
      shopListId: shopListId,
      voucherId: voucherId.isEmpty ? null : voucherId,
    );
    Navigator.pop(context);
  }

  onShopClick(String shopId, String shopName) {
    if (shopListId.contains(shopId)) {
      openSnackbar(
          context, 'This shop has already been added!', scheme.primary);
    } else {
      shopListId.add(shopId);
      shopListName.add(shopName);
      setState(() {});
      Navigator.pop(context);
    }
  }

  selectVoucher(String id, String name) {
    if (voucherId.isNotEmpty || voucherName.isNotEmpty) {
      openSnackbar(
          context, 'This voucher has already been added!', scheme.primary);
    } else {
      voucherName = name;
      voucherId = id;
      setState(() {});
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Add Banner',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: imageXFile == null ||
                    descriptionText.isEmpty ||
                    shopListId.isEmpty
                ? () {}
                : handleConfirm,
            icon: Icon(
              Icons.add,
              color: imageXFile == null ||
                      descriptionText.isEmpty ||
                      shopListId.isEmpty
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
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    imageXFile == null
                        // && imageUrl.isEmpty
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
                                    // width: MediaQuery.of(context).size.width,
                                    child: Center(
                                      child: Stack(
                                        children: [
                                          AspectRatio(
                                            aspectRatio: 4 / 5,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image:
                                                      //  imageUrl == '' ?
                                                      FileImage(
                                                    File(imageXFile!.path),
                                                  )
                                                  // : NetworkImage(imageUrl)
                                                  //     as ImageProvider
                                                  ,
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
                                                  // imageUrl = '';
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
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          SearchUserScreen.routeName,
                          arguments: SearchUserScreen(onShopClick: onShopClick),
                        );
                      },
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Choose Shop',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.add,
                            color: scheme.primary,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: shopListName.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(shopListName[index]),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    shopListName.removeAt(index);
                                    shopListId.removeAt(index);
                                    setState(() {});
                                  },
                                  child: Icon(
                                    Icons.delete_outline,
                                    color: scheme.primary,
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, SelectVoucherScreen.routeName,
                            arguments: SelectVoucherScreen(
                              selectVoucher: selectVoucher,
                            ));
                      },
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Choose voucher (optional)',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.add,
                            color: scheme.primary,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    voucherName.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(voucherName),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    voucherName = '';
                                    setState(() {});
                                  },
                                  child: Icon(
                                    Icons.delete_outline,
                                    color: scheme.primary,
                                  ),
                                )
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
            CustomTextButton(
              text: 'Confirm',
              onPressed: handleConfirm,
              isDisabled: imageXFile == null ||
                  descriptionText.isEmpty ||
                  shopListId.isEmpty,
            ),
          ],
        ),
      ),
    );
  }
}
