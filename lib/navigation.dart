import 'package:flutter/material.dart';


class NavigationItem extends StatelessWidget {
  final String title;
  final IconData icon;
//  final String link;
  final VoidCallback? onTap;
  const NavigationItem({super.key, required this.title, required this.icon,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.symmetric(horizontal: 12),
        padding: EdgeInsets.symmetric(vertical: 16,horizontal: 12),
        child: Row(children: [
          Icon(icon,color: Colors.grey.shade600,),
          SizedBox(width: 16,),
          Text(title,style: TextStyle(fontSize: 17),),
          Spacer(),
          Icon(Icons.navigate_next),
        ],
        ),
      ),
    );
  }
}