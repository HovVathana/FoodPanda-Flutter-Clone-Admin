import 'package:flutter/material.dart';
import 'package:foodpanda_admin/authentication/screens/authentication_screen.dart';
import 'package:foodpanda_admin/authentication/screens/login_screen.dart';
import 'package:foodpanda_admin/banner/screen/add_banner_screen.dart';
import 'package:foodpanda_admin/banner/screen/banner_screen.dart';
import 'package:foodpanda_admin/banner/screen/search_user_screen.dart';
import 'package:foodpanda_admin/banner/screen/select_voucher_screen.dart';
import 'package:foodpanda_admin/home/screens/home_screen.dart';
import 'package:foodpanda_admin/shop/screens/add_category_screen.dart';
import 'package:foodpanda_admin/shop/screens/add_food_screen.dart';
import 'package:foodpanda_admin/shop/screens/category_screen.dart';
import 'package:foodpanda_admin/shop/screens/food_screen.dart';
import 'package:foodpanda_admin/shop/screens/shop_screen.dart';
import 'package:foodpanda_admin/voucher/screens/add_voucher_screen.dart';
import 'package:foodpanda_admin/voucher/screens/voucher_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );

    case AuthenticationScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthenticationScreen(),
      );

    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LoginScreen(),
      );

    case ShopScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ShopScreen(),
      );

    case CategoryScreen.routeName:
      final args = routeSettings.arguments as CategoryScreen;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CategoryScreen(
          shop: args.shop,
        ),
      );

    case AddCategoryScreen.routeName:
      final args = routeSettings.arguments as AddCategoryScreen;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddCategoryScreen(
          shop: args.shop,
          id: args.id,
          subtitle: args.subtitle,
          title: args.title,
        ),
      );

    case AddFoodScreen.routeName:
      final args = routeSettings.arguments as AddFoodScreen;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddFoodScreen(
          shop: args.shop,
          id: args.id,
          foodId: args.foodId,
        ),
      );

    case FoodScreen.routeName:
      final args = routeSettings.arguments as FoodScreen;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => FoodScreen(
          shop: args.shop,
          id: args.id,
        ),
      );

    case VoucherScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const VoucherScreen(),
      );

    case AddVoucherScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddVoucherScreen(),
      );

    case BannerScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BannerScreen(),
      );

    case AddBannerScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddBannerScreen(),
      );

    case SearchUserScreen.routeName:
      final args = routeSettings.arguments as SearchUserScreen;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchUserScreen(
          onShopClick: args.onShopClick,
        ),
      );

    case SelectVoucherScreen.routeName:
      final args = routeSettings.arguments as SelectVoucherScreen;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SelectVoucherScreen(
          selectVoucher: args.selectVoucher,
        ),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
