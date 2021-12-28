
import 'dart:ffi';

import 'dart:ui';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:udemy_flutter/modules/news_app/web_view/view_screen.dart';
import 'package:udemy_flutter/modules/shop_app/cubit/cubit.dart';
import 'package:udemy_flutter/modules/shop_app/login/shoplogin_screen.dart';
import 'package:udemy_flutter/shared/cubit/cubit.dart';
import 'package:udemy_flutter/shared/network/local/cach_helper.dart';
import 'package:udemy_flutter/shared/styles/colors.dart';

Widget defaultButton({

   double width = double.infinity,
   Color background = Colors.blue,
  bool isUpperCase = true,
   required Function function,
  required String text,
}) =>
    Container(

      width: width,
  color: background,
  child: MaterialButton(
    onPressed: (){
      function();
    },
    child: Text(
     isUpperCase? text.toUpperCase() : text,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  ),
);
///////////////////////////////////////////////
Widget defaultFormField({
  required TextEditingController controller ,
  required TextInputType type,
  required FormFieldValidator<String>? validate ,
  VoidCallback ?  onTab,
  ValueChanged<String>? onChange,
  ValueChanged<String>? onSubmit ,
  VoidCallback? suffixPressed,
  bool isPassword = false,
  required String label,
  required IconData prefix,
   IconData? suffix,
   bool isClickable = true,


}) => TextFormField  (
  controller: controller,
  keyboardType: type,
  obscureText: isPassword,
  enabled:isClickable ,

  onFieldSubmitted:onSubmit,

  // onChanged: (value)
  // {
  //   print (value);
  // },
  onTap:onTab,
  onChanged :onChange,
  validator: validate,
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(
     prefix,
    ) ,
    suffixIcon: suffix != null ? IconButton(
      onPressed:(){
        suffixPressed!();
      },
        icon: Icon(
            suffix,
        ),
        ) : null ,
    border: OutlineInputBorder(),
  ),
);

///////////////////////////////////////////////////
Widget  buildTaskItem(Map model, context) => Dismissible(
  key: Key(model['time']),
  child:Padding(
  
    padding: const EdgeInsets.all(20.0),
  
    child: Row(
  
      children: [
  
        CircleAvatar(
  
          radius: 40,
  
          child: Text(
  
            '${model['time']}',
  
            style: const TextStyle(
  
              color: Colors.white,
  
            ),
  
          ),
  
          backgroundColor: Colors.amber,
  
        ),
  
        SizedBox(
  
          width: 20.0,
  
        ),
  
        Expanded(
  
          child: Column(
  
            mainAxisSize: MainAxisSize.min,
  
            children:[
  
              Text(
  
                '${model['title']}',
  
                style: TextStyle(
  
                  fontSize: 16.0,
  
                  fontWeight: FontWeight.bold,
  
                ),
  
              ),
  
              Text(
  
                '${model['time']}',
  
                style: TextStyle(
  
                  color: Colors.grey,
  
                ),
  
              ),
  
            ],
  
          ),
  
        ),
  
        SizedBox(
  
          width: 20.0,
  
        ),
  
        IconButton(
  
          onPressed: ()
  
          {
  
            AppCubit.get(context).updateDateData(
  
              status: 'done',
  
              id: model['id'],
  
            );
  
          },
  
          icon:const Icon(
  
            Icons.check,
  
            color: Colors.green,
  
          ),
  
  
  
        ),
  
        IconButton(
  
          onPressed: ()
  
          {
  
            AppCubit.get(context).updateDateData(
  
              status: 'archived',
  
              id: model['id'],
  
            );
  
          },
  
          icon:const Icon(
  
            Icons.archive_outlined,
  
            color: Colors.black45,
  
          ),
  
  
  
        ),
  
      ],
  
    ),
  
  ),
  onDismissed: (direction)
  {
    AppCubit.get(context).deleteData(id: model['id']);
  },
);
//////////////////
Widget tasksBuilder({
  required List<Map> tasks,
}) => ConditionalBuilder(
  condition: tasks.length > 0,
  builder: (context)=>ListView.separated(
    physics: BouncingScrollPhysics(),
    itemBuilder: (context, index)=>buildTaskItem(tasks[index], context),
    separatorBuilder: (context, index)=> myDivider(),
    itemCount: tasks.length,
  ),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.menu,
          size: 100,
          color: Colors.grey,
        ),
        Text(
          'No Tasks Yet, PLS Add Some Tasks',
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold
          ),
        ),
      ],
    ),
  ),

);
Widget myDivider() =>Container(
  width: double.infinity,
  height: 1.0,
  color: Colors.grey[300],
);
////////////////Start Article ITEMS
Widget buildArticleItem(article,context)=>InkWell(
  onTap: (){
    navigateTo(context, WebViewScreen(article['url']));
  },
  child: Padding(
    padding: const EdgeInsets.all(8.0),

    child: Row(

      children:  [

        Container(

          width: 120.0,

          height: 120.0,

          decoration: BoxDecoration(

              borderRadius: BorderRadius.circular(20.0),

              image:  DecorationImage(

                image: NetworkImage('${article['urlToImage']}'),

                fit: BoxFit.cover,

              )

          ),

        ),

        const SizedBox (

          width: 20.0,

        ),

        Expanded(

          child:Container(

            height: 120.0,

            child: Column(

              mainAxisSize: MainAxisSize.max,

              crossAxisAlignment:CrossAxisAlignment.start,



              children:  [

                Expanded(

                  child: Text(

                    '${article['title']}',

                    style:Theme.of(context).textTheme.bodyText1,

                    overflow: TextOverflow.ellipsis,

                    maxLines: 3,

                  ),

                ),

                Text(

                  '${article['publishedAt']}',

                  style: TextStyle(

                    color: Colors.grey,

                  ),

                ),

              ],

            ),

          ),

        ),



      ],

    ),

  ),
);
////////////////END Articals
//// Start articleBuilder
Widget articleBuilder(list,context,{isSearch=false}) =>ConditionalBuilder(
  condition: list.length > 0,
  // condition: State is! NewsGetScienceLoadingState,
  builder: (context) =>
      ListView.separated(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index)=>buildArticleItem(list[index], context),
          separatorBuilder: (context, index) =>myDivider(),
          itemCount: 10),
  fallback: (context) => isSearch? Container() : Center(child: CircularProgressIndicator()),
);
//// End articleBuilder
void navigateTo(context,widget ){
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
  );

}
void navigateAndFinish(
    context,widget
    )=>
    Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
        builder: (context) =>widget,
    ),
     (route) {
      return false;
     }
    );

/////Start Flutter toast
void showToast({
  required String text,
  required state,
}) =>  Fluttertoast.showToast(
  msg: text,
  toastLength: Toast.LENGTH_LONG,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 5,
  backgroundColor: chooseToastColor(state),
  textColor: Colors.white,
  fontSize: 16.0,
);

enum ToastStates {SUCCESS, ERROR, WARNING}
 Color? chooseToastColor(ToastStates state)
 {
   Color color;
switch(state){
  case ToastStates.SUCCESS:
    color = Colors.green;
  break;
  case ToastStates.ERROR:
    color = Colors.red;
    break;
  case ToastStates.WARNING:
    color = Colors.amber;
    break;
}
return color;
}
/////End Flutter toast

/////////////Start buildListProduct
Widget buildListProduct(model, context, {
  bool isOldPrice = true,
}) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: Container(
    height: 120,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              image: NetworkImage(model.image!),
              width: 120.0,
              height: 120.0,
              fit: BoxFit.cover,


            ),
            if(model.discount != 0 && isOldPrice)
              Container(
                color: Colors.red,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child:Text(
                    'DISCOUNT',
                    style:TextStyle(
                      fontSize: 11.0,
                      fontWeight:FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                model.name!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  height: 1.3,
                  fontSize: 14.0,
                ),

              ),
              Spacer(),
              Row(
                children:
                [
                  Text(
                    model.price!.toString(),
                    style: const TextStyle(
                      color: defaultColor,
                      fontSize: 12.0,
                    ),

                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  if(model.discount != 0 && isOldPrice)
                    Text(
                      model.oldPrice!.toString(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                        decoration: TextDecoration.lineThrough,
                      ),

                    ),
                  const Spacer(),
                  IconButton(
                    onPressed: ()
                    {
                      ShopCubit.get(context).changeFavorites(model.id!);

                      //print('12');
                    },
                    icon: CircleAvatar(
                      radius: 15.0,
                      backgroundColor:
                      ShopCubit.get(context).favorites[model.id!]! ? Colors.red : Colors.red[100],
                      child:const Icon(
                        Icons.favorite_border,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

      ],
    ),
  ),
);
/////////////End buildListProduct