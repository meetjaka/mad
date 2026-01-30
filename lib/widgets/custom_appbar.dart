import 'package:flutter/material.dart';
import '../core/constants/dimens.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? trailing;

  const CustomAppBar({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      centerTitle: false,
      elevation: 0,
      actions: [
        if (trailing != null)
          Padding(
            padding: const EdgeInsets.only(right: Dimens.padding / 2),
            child: trailing!,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
