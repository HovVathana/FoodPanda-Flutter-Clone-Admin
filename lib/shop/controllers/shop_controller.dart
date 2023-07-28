import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_admin/common/firebare_storage_repository.dart';
import 'package:foodpanda_admin/models/category.dart';
import 'package:foodpanda_admin/models/food.dart';
import 'package:foodpanda_admin/models/shop.dart';
import 'package:image_picker/image_picker.dart';

class ShopController {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future addNewCategory({
    required String sellerId,
    required String title,
    required String subtitle,
    String? id,
  }) async {
    final DocumentReference ref;
    if (id != null) {
      ref = firestore
          .collection('sellers')
          .doc(sellerId)
          .collection('categories')
          .doc(id);
    } else {
      ref = firestore
          .collection('sellers')
          .doc(sellerId)
          .collection('categories')
          .doc();
    }

    await ref.set({
      'title': title,
      'subtitle': subtitle,
      'id': ref.id,
      'isPublished': true,
    }).catchError((error) {
      debugPrint(error);
    });
  }

  Future deleteCategory({
    required String sellerId,
    required String id,
  }) async {
    final DocumentReference ref;
    ref = firestore
        .collection('sellers')
        .doc(sellerId)
        .collection('categories')
        .doc(id);

    await ref.delete().catchError((error) {
      debugPrint(error);
    });
  }

  Future<List<Shop>> fetchShop() async {
    List<Shop> shops = [];

    var shopSnapshot = await firestore.collection('sellers').get();

    for (var tempData in shopSnapshot.docs) {
      Shop tempShop = Shop.fromMap(tempData.data());

      shops.add(tempShop);
    }
    return shops;
  }

  Stream<List<Category>> fetchCategory({required String sellerId}) {
    return firestore
        .collection('sellers')
        .doc(sellerId)
        .collection('categories')
        .snapshots()
        .map(
      (event) {
        List<Category> categories = [];
        for (var document in event.docs) {
          categories.add(Category.fromMap(document.data()));
        }
        return categories;
      },
    );
  }

  Future changeIsPublished({
    required String sellerId,
    required String id,
    required bool isPublished,
  }) async {
    final DocumentReference ref;
    ref = firestore
        .collection('sellers')
        .doc(sellerId)
        .collection('categories')
        .doc(id);

    await ref.set(
      {
        "isPublished": isPublished,
      },
      SetOptions(merge: true),
    ).catchError((error) {
      debugPrint(error);
    });
  }

  Stream<List<Food>> fetchFood({
    required String sellerId,
    required String categoryId,
  }) {
    return firestore
        .collection('sellers')
        .doc(sellerId)
        .collection('categories')
        .doc(categoryId)
        .collection('foods')
        .snapshots()
        .map(
      (event) {
        List<Food> foods = [];
        for (var document in event.docs) {
          foods.add(Food.fromMap(document.data()));
        }
        return foods;
      },
    );
  }

  Future changeIsPublishedFood({
    required String sellerId,
    required String categoryId,
    required String id,
    required bool isPublished,
  }) async {
    final DocumentReference ref;
    ref = firestore
        .collection('sellers')
        .doc(sellerId)
        .collection('categories')
        .doc(categoryId)
        .collection('foods')
        .doc(id);

    await ref.set(
      {
        "isPublished": isPublished,
      },
      SetOptions(merge: true),
    ).catchError((error) {
      debugPrint(error);
    });
  }

  Future addNewFood({
    required String sellerId,
    required String categoryId,
    required String name,
    required String description,
    required double price,
    required double comparePrice,
    required XFile? imageFile,
    String? imageUrl,
    String? foodId,
  }) async {
    final DocumentReference ref;
    String foodImage;

    if (foodId != null) {
      ref = firestore
          .collection('sellers')
          .doc(sellerId)
          .collection('categories')
          .doc(categoryId)
          .collection('foods')
          .doc(foodId);
    } else {
      ref = firestore
          .collection('sellers')
          .doc(sellerId)
          .collection('categories')
          .doc(categoryId)
          .collection('foods')
          .doc();
    }

    if (imageUrl != null) {
      foodImage = imageUrl;
    } else {
      foodImage = await storeFileToFirebase(
        'seller/$sellerId/$categoryId/${ref.id}',
        File(imageFile!.path),
      );
    }

    await ref.set({
      'id': ref.id,
      'name': name,
      'description': description,
      'price': price,
      'comparePrice': comparePrice,
      'image': foodImage,
      'isPublished': true,
    }).catchError((error) {
      debugPrint(error);
    });
  }

  Future<Food?> fetchFoodById({
    required String sellerId,
    required String categoryId,
    required String id,
  }) async {
    var foodData = await firestore
        .collection('sellers')
        .doc(sellerId)
        .collection('categories')
        .doc(categoryId)
        .collection('foods')
        .doc(id)
        .get();

    Food? food;
    if (foodData.data() != null) {
      food = Food.fromMap(foodData.data()!);
    }

    return food;
  }

  Future deleteFood({
    required String sellerId,
    required String categoryId,
    required String id,
  }) async {
    final DocumentReference ref;
    ref = firestore
        .collection('sellers')
        .doc(sellerId)
        .collection('categories')
        .doc(categoryId)
        .collection('foods')
        .doc(id);

    await ref.delete().catchError((error) {
      debugPrint(error);
    });
  }
}
