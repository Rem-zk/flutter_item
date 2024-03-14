import 'package:flutter/material.dart';

class user_setting extends StatelessWidget {
  final String title;
  final Widget? tailing;
  final Function()? onTap;

  const user_setting({super.key, required this.title, this.tailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(onTap!=null) onTap!();
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 20),
        child:
        Row(
          children: [
            Text(title,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
            Spacer(),
            if(tailing!=null) tailing!,
            Icon(
              Icons.navigate_next,
              color:Colors.grey.shade500 ,
            ),
          ],
        ),
      ),
    );
  }
}
