import 'package:flutter/foundation.dart';
import 'package:foodpanda_admin/models/food.dart';

class Menu {
  final Category category;
  final List<Food> foods;
  Menu({
    required this.category,
    required this.foods,
  });
}
