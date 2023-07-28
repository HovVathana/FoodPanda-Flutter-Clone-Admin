import 'package:flutter/material.dart';
import 'package:foodpanda_admin/authentication/screens/authentication_screen.dart';
import 'package:foodpanda_admin/constants/colors.dart';
import 'package:foodpanda_admin/providers/authentication_provider.dart';
import 'package:foodpanda_admin/widgets/my_alert_dialog.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  final BuildContext parentContext;
  const MyDrawer({super.key, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    final ap = context.watch<AuthenticationProvider>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Builder(builder: (c) {
            return DrawerHeader(
                decoration: BoxDecoration(
                  color: scheme.primary,
                  border: Border.all(color: scheme.primary),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          ap.name!.isNotEmpty ? ap.name!.substring(0, 1) : 'F',
                          style: TextStyle(
                            color: scheme.primary,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      ap.name!.isNotEmpty ? ap.name! : 'Foodpanda',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ));
          }),
          listTile(
            context,
            'Help center',
            Icons.help_outline_outlined,
            () {
              Navigator.pop(context);
            },
          ),
          Container(
            height: 1,
            color: MyColors.borderColor,
          ),
          listTile(
            context,
            'Settings',
            null,
            () {
              Navigator.pop(context);
            },
          ),
          listTile(
            context,
            'Terms & Conditions / Privacy',
            null,
            () {
              Navigator.pop(context);
            },
          ),
          Builder(builder: (c) {
            return listTile(
              context,
              'Log out',
              null,
              () {
                Scaffold.of(c).closeDrawer();
                showDialog(
                  context: c,
                  builder: (ctx) => MyAlertDialog(
                    title: 'Logging out?',
                    subtitle: 'Thanks for stopping by. See you again soon!',
                    action1Name: 'Cancel',
                    action2Name: 'Log out',
                    action1Func: () {
                      Navigator.pop(ctx);
                    },
                    action2Func: () {
                      ap.userSignOut();
                      Navigator.pushNamedAndRemoveUntil(ctx,
                          AuthenticationScreen.routeName, (route) => false);
                    },
                  ),
                );
              },
            );
          })
        ],
      ),
    );
  }

  ListTile listTile(
      BuildContext context, String text, IconData? icon, VoidCallback onTap) {
    return icon == null
        ? ListTile(
            title: Text(
              text,
              style: const TextStyle(
                color: MyColors.textColor,
                fontSize: 14,
              ),
            ),
            onTap: onTap,
          )
        : ListTile(
            title: Text(
              text,
              style: const TextStyle(
                color: MyColors.textColor,
                fontSize: 14,
              ),
            ),
            leading: Icon(
              icon,
              color: scheme.primary,
            ),
            onTap: onTap,
          );
  }
}
