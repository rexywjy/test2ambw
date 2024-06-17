import 'package:flutter/material.dart';

// class name extends StatelessWidget {
//   const name({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

class CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final Function? method;
  const CustomListTile(
      {Key? key, required this.title, required this.icon, this.trailing, this.method})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: this.method as void Function()?,
    );
  }
}