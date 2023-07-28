import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_admin/banner/controllers/search_shop_controller.dart';
import 'package:foodpanda_admin/banner/widgets/shop_search.dart';
import 'package:foodpanda_admin/constants/colors.dart';
import 'package:foodpanda_admin/models/shop.dart';

class SearchUserScreen extends StatefulWidget {
  static const String routeName = '/search-user-screen';
  final Function(String, String) onShopClick;
  const SearchUserScreen({super.key, required this.onShopClick});

  @override
  State<SearchUserScreen> createState() => SearchUserScreenState();
}

class SearchUserScreenState extends State<SearchUserScreen> {
  TextEditingController queryController = TextEditingController();
  String searchText = '';
  FocusNode searchFocus = FocusNode();
  List<Shop>? shops;

  @override
  void initState() {
    searchFocus.requestFocus();
    super.initState();
  }

  handleSubmit(String search) async {
    queryController.text = search;
    SearchShopController searchShopController = SearchShopController();
    shops = await searchShopController.fetchSearchResult(search: search);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: scheme.primary,
        elevation: 0.5,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: CupertinoTextField(
            controller: queryController,
            focusNode: searchFocus,
            onSubmitted: handleSubmit,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            placeholder: 'Search for shop & restaurants',
            placeholderStyle: TextStyle(
              color: Colors.grey[700],
            ),
            prefix: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Icon(
                Icons.search,
                color: Colors.grey[700],
              ),
            ),
            suffix: searchText.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: GestureDetector(
                      onTap: () {
                        queryController.text = '';
                        searchText = '';
                        shops = null;
                        setState(() {});
                      },
                      child: Icon(
                        Icons.cancel_outlined,
                        color: Colors.grey[700],
                      ),
                    ),
                  )
                : const SizedBox(),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(50),
            ),
            style: const TextStyle(
              fontSize: 15,
            ),
            onChanged: (String value) {
              setState(() {
                searchText = value;
              });
            },
          ),
        ),
      ),
      body: shops == null
          ? const SizedBox()
          : ShopSearch(
              shops: shops!,
              search: queryController.text,
              onShopClick: widget.onShopClick,
            ),
    );
  }
}
