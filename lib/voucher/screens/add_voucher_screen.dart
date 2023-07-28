import 'package:flutter/material.dart';
import 'package:foodpanda_admin/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_admin/constants/colors.dart';
import 'package:foodpanda_admin/models/voucher.dart';
import 'package:foodpanda_admin/voucher/controllers/voucher_controller.dart';
import 'package:foodpanda_admin/voucher/widgets/date_picker.dart';
import 'package:foodpanda_admin/widgets/custom_textfield.dart';
import 'package:foodpanda_admin/widgets/my_snack_bar.dart';
import 'package:intl/intl.dart';

class AddVoucherScreen extends StatefulWidget {
  static const String routeName = '/add-voucher-screen';
  const AddVoucherScreen({super.key});

  @override
  State<AddVoucherScreen> createState() => _AddVoucherScreenState();
}

class _AddVoucherScreenState extends State<AddVoucherScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController minimumPriceController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  String nameText = '';
  DateTime startingDate = DateTime.now();
  DateTime expiredDate = DateTime.now();
  bool isNewUser = false;
  bool isDollar = false;
  String discountText = '';

  @override
  void dispose() {
    nameController.dispose();
    minimumPriceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    expiredDate =
        DateTime(startingDate.year, startingDate.month, startingDate.day + 10);

    setState(() {});

    super.initState();
  }

  handleAddVoucher() async {
    VoucherController voucherController = VoucherController();
    Voucher voucher = Voucher(
      id: '',
      name: nameController.text,
      isNewUser: isNewUser,
      startingDate: startingDate.millisecondsSinceEpoch,
      expiredDate: expiredDate.millisecondsSinceEpoch,
      createdDate: DateTime.now().millisecondsSinceEpoch,
      minPrice: minimumPriceController.text.isEmpty
          ? null
          : double.parse(minimumPriceController.text),
      freeDelivery: false,
      discountPercentage:
          isDollar ? null : double.parse(discountController.text.trim()),
      discountPrice:
          isDollar ? double.parse(discountController.text.trim()) : null,
    );

    String? result = await voucherController.addNewVoucher(
      voucher: voucher,
    );
    if (result == null) {
      Navigator.pop(context);
    } else {
      openSnackbar(context, result, scheme.primary);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Add Voucher',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: nameText.isEmpty || discountText.isEmpty
                ? null
                : handleAddVoucher,
            icon: Icon(
              Icons.add,
              color: nameText.isEmpty || discountText.isEmpty
                  ? Colors.grey[400]
                  : Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
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
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        showDateDialog(
                            context: context,
                            expiredDate: expiredDate,
                            startingDate: startingDate,
                            onChange: (newStartingDate, newExpiredDate) {
                              setState(() {
                                startingDate = newStartingDate;
                                expiredDate = newExpiredDate;
                              });
                            });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey[400]!,
                          ),
                        ),
                        child: Text(
                          '${DateFormat('d MMM yyyy').format(startingDate)}  -  ${DateFormat('d MMM yyyy').format(expiredDate)}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: minimumPriceController,
                      labelText: 'Minimum price',
                      isNumPad: true,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text('Only available for new user only')),
                        Switch(
                          value: isNewUser,
                          activeColor: scheme.primary,
                          onChanged: (value) {
                            setState(() {
                              isNewUser = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: discountController,
                            labelText: 'Discount ${isDollar ? "(\$)" : "(%)"}',
                            isNumPad: true,
                            onChanged: (value) {
                              setState(
                                () {
                                  discountText = value;
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('Percentage'),
                        Switch(
                          value: isDollar,
                          activeColor: scheme.primary,
                          onChanged: (value) {
                            setState(() {
                              isDollar = value;
                            });
                          },
                        ),
                        Text('Dollar'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          CustomTextButton(
            text: 'Confirm',
            onPressed: handleAddVoucher,
            isDisabled: nameText.isEmpty || discountText.isEmpty,
          )
        ],
      ),
    );
  }
}
