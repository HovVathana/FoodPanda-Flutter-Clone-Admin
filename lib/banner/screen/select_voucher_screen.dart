import 'package:flutter/material.dart';
import 'package:foodpanda_admin/models/voucher.dart';
import 'package:foodpanda_admin/voucher/controllers/voucher_controller.dart';
import 'package:foodpanda_admin/voucher/widgets/voucher_card.dart';

class SelectVoucherScreen extends StatelessWidget {
  static const String routeName = '/select-voucher-screen';
  final Function(String, String) selectVoucher;
  const SelectVoucherScreen({super.key, required this.selectVoucher});

  @override
  Widget build(BuildContext context) {
    VoucherController voucherController = VoucherController();
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: const Text(
            'Select Voucher',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: StreamBuilder<List<Voucher>>(
                stream: voucherController.fetchVouchers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('loading');
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final voucher = snapshot.data![index];

                        return DateTime.now().isBefore(
                                DateTime.fromMillisecondsSinceEpoch(
                                    voucher.expiredDate))
                            ? GestureDetector(
                                onTap: () =>
                                    selectVoucher(voucher.id, voucher.name),
                                child: VoucherCard(voucher: voucher),
                              )
                            : const SizedBox();
                      });
                }),
          ),
        ));
  }
}
