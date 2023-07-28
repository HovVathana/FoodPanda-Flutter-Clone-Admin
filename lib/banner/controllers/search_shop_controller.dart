import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodpanda_admin/models/shop.dart';

class SearchShopController {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Shop>> fetchSearchResult({
    required String search,
  }) async {
    List<Shop> shopList = [];
    var shopSnapshot = await firestore
        .collection('sellers')
        .where(
          'shopName',
          isGreaterThanOrEqualTo: search.toUpperCase(),
        )
        .get();

    for (var tempData in shopSnapshot.docs) {
      Shop tempShop = Shop.fromMap(tempData.data());
      if (tempShop.isApproved) {
        shopList.add(tempShop);
      }
    }

    return shopList;
  }
}
