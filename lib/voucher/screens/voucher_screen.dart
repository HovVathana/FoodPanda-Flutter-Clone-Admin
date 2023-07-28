import 'package:flutter/material.dart';
import 'package:foodpanda_admin/models/voucher.dart';
import 'package:foodpanda_admin/voucher/controllers/voucher_controller.dart';
import 'package:foodpanda_admin/voucher/screens/add_voucher_screen.dart';
import 'package:foodpanda_admin/voucher/widgets/voucher_card.dart';

class VoucherScreen extends StatefulWidget {
  static const String routeName = '/voucher-screen';
  const VoucherScreen({super.key});

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  VoucherController voucherController = VoucherController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: const Text(
            'Voucher',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AddVoucherScreen.routeName);
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
                    const Text(
                      'All Categories',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 30),
                    StreamBuilder<List<Voucher>>(
                        stream: voucherController.fetchVouchers(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text('loading');
                          }
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final voucher = snapshot.data![index];
                                return VoucherCard(voucher: voucher);
                              });
                        })
                  ])),
        ));
  }
}
