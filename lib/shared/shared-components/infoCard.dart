
import 'package:flutter/material.dart';
import 'package:madrasti/providers/userProvider.dart';

import '../../language_utils/language_constants.dart';
import '../../models/user.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final bool isActive;
  final double? widh;
  final Function()? onTap;
  final String? subTitle;
  final int index;

  final Color color;
  final IconData iconData;

  const InfoCard({super.key, required this.title, required this.value, required this.isActive, required this.onTap, required this.color, required this.iconData,this.widh, this.subTitle, required this.index});

  bool havePermission(int index,context){
    User? user = getCurrentUser(context);
    if(user != null){
      if(user.isAdmin == true){
        return true;
      }
      if(user.permissions != null){
        if(user.permissions!.contains(index.toString())){
          return true;
        }
        else{
          return false;
        }
      }
      else{
        return false;
      }
    }
    else{
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 160,
        width: (widh != null)?widh : 280,
        decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            boxShadow:[
              BoxShadow(color: Colors.blueAccent.withOpacity(0.1))
            ],

        ),

        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(
                width: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title.toString(),
                          style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                        ),
                        SizedBox(height: 10,),
                        (subTitle == null)?Text(
                            (havePermission(index,context))?'${translation(context).total}: ' + value.toString() : '',
                          style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 20,color: Colors.blueGrey),
                        ):Text(
                          (havePermission(index,context))?'${translation(context).incomes_this_moth}: ' + value.toString() :'',
                          style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 20,color: Colors.blueGrey),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10,top: 5,right: 10),
                    child: Icon(iconData,size: 90,color: color.withOpacity(0.3),),
                  ),
                  SizedBox()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

