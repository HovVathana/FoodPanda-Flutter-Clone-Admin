import 'package:flutter/material.dart';
import 'package:foodpanda_admin/widgets/my_alert_dialog.dart';

class MyDismissible extends StatelessWidget {
  final VoidCallback? onEditTap;
  final VoidCallback? onDeleteTap;
  final String? dialogSubtitle;
  final String? id;
  final Widget children;
  const MyDismissible({
    Key? key,
    this.onEditTap,
    this.onDeleteTap,
    this.id,
    this.dialogSubtitle,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(id != null ? id! : ''),
      direction: onEditTap == null && onDeleteTap == null
          ? DismissDirection.none
          : DismissDirection.horizontal,
      confirmDismiss: (DismissDirection direction) async {
        if (direction == DismissDirection.startToEnd) {
          onEditTap!();
          return false;
        } else if (direction == DismissDirection.endToStart) {
          bool isDeleted = false;
          showDialog(
              context: context,
              builder: (context) {
                return MyAlertDialog(
                    title: 'Delete',
                    subtitle: dialogSubtitle != null
                        ? dialogSubtitle!
                        : 'Are you sure to delete this category and foods under this category?',
                    action1Name: 'Cancel',
                    action2Name: 'Confirm',
                    action1Func: () {
                      Navigator.pop(context);
                    },
                    action2Func: () {
                      isDeleted = true;
                      onDeleteTap!();
                      Navigator.pop(context);
                    });
              });

          // onDeleteTap!();
          return isDeleted;
        }
      },
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[300]!),
        ),
        alignment: Alignment.centerRight,
        child: const Padding(
          padding: EdgeInsets.only(right: 10),
          child: Icon(
            Icons.delete_outline_rounded,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      background: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[300]!),
        ),
        alignment: Alignment.centerLeft,
        child: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Icon(
            Icons.mode_edit_outline_outlined,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      child: children,
    );
  }
}
