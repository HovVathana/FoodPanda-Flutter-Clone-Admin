import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_admin/models/voucher.dart';

class VoucherController {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String?> addNewVoucher({
    required Voucher voucher,
  }) async {
    var result = await firestore
        .collection('vouchers')
        .where('name', isEqualTo: voucher.name)
        .get();

    if (result.docs.isEmpty) {
      final DocumentReference ref;
      ref = firestore.collection('vouchers').doc();
      voucher.id = ref.id;

      await ref.set(voucher.toMap()).catchError((error) {
        debugPrint(error);
      });
      return null;
    } else {
      return 'This voucher name already existed!';
    }
  }

  Stream<List<Voucher>> fetchVouchers() {
    return firestore
        .collection('vouchers')
        .orderBy('createdDate', descending: true)
        .snapshots()
        .map(
      (event) {
        List<Voucher> vouchers = [];
        for (var document in event.docs) {
          vouchers.add(Voucher.fromMap(document.data()));
        }
        return vouchers;
      },
    );
  }

  Future deleteVoucher({
    required String id,
  }) async {
    final DocumentReference ref;
    ref = firestore.collection('vouchers').doc(id);

    await ref.delete().catchError((error) {
      debugPrint(error);
    });
  }
}
