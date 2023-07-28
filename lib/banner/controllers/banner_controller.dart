import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_admin/common/firebare_storage_repository.dart';
import 'package:foodpanda_admin/models/banner.dart' as model;
import 'package:image_picker/image_picker.dart';

class BannerController {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future createBanner({
    required XFile image,
    required String description,
    required List<String> shopListId,
    String? voucherId,
  }) async {
    final DocumentReference ref;

    ref = firestore.collection('banners').doc();

    String imageUrl = await storeFileToFirebase(
      'seller/${firebaseAuth.currentUser!.uid}/banner/${ref.id}',
      File(image.path),
    );

    model.Banner banner = model.Banner(
      id: ref.id,
      imageUrl: imageUrl,
      description: description,
      creatorId: firebaseAuth.currentUser!.uid,
      shopListId: shopListId,
      isApproved: true,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      voucherId: voucherId,
    );

    await ref.set(banner.toMap()).catchError((error) {
      debugPrint(error);
    });
  }

  Stream<List<model.Banner>> fetchBanner() {
    return firestore.collection('banners').snapshots().map(
      (event) {
        List<model.Banner> banners = [];
        for (var document in event.docs) {
          banners.add(model.Banner.fromMap(document.data()));
        }
        return banners;
      },
    );
  }

  Future changeBannerApproved({
    required String bannerId,
    required bool isApproved,
  }) async {
    final DocumentReference ref;
    ref = firestore.collection('banners').doc(bannerId);

    await ref.set(
      {
        "isApproved": isApproved,
      },
      SetOptions(merge: true),
    ).catchError((error) {
      debugPrint(error);
    });
  }

  Future deleteBanner({
    required String bannerId,
  }) async {
    final DocumentReference ref;
    ref = firestore.collection('banners').doc(bannerId);

    await deleteFileStorage(
        'seller/${firebaseAuth.currentUser!.uid}/banner/$bannerId');

    await ref.delete().catchError((error) {
      debugPrint(error);
    });
  }
}
