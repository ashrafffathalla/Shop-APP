import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_flutter/models/shop_app/categories_model.dart';
import 'package:udemy_flutter/models/shop_app/home_model.dart';
import 'package:udemy_flutter/modules/shop_app/cubit/cubit.dart';
import 'package:udemy_flutter/modules/shop_app/cubit/states.dart';
import 'package:udemy_flutter/shared/components/components.dart';
import 'package:udemy_flutter/shared/styles/colors.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context, state)
      {
        if(state is ShopSuccessChangeFavoritesState)
        {
          if(!state.model.status!)
          {
            showToast(
                text: state.model.message!,
                state: ToastStates.ERROR ,
            );
          }
        }
      },
      builder: (context, state)
      {
        return ConditionalBuilder(
            condition: ShopCubit.get(context).homeModel !=null && ShopCubit.get(context).categoriesModel !=null,
            builder:(context) =>  productsBuilder(ShopCubit.get(context).homeModel!, ShopCubit.get(context).categoriesModel!, context),
          fallback: (context) =>const Center(
              child: CircularProgressIndicator(),
          ) ,
        );
      } ,
    );
  }

  Widget productsBuilder(HomeModel model , CategoriesModel categoriesModel, context) => SingleChildScrollView(
    physics:const  BouncingScrollPhysics(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider(
            items: model.data!.banners.map((e) =>
              Image(
                image:NetworkImage('${e.image}'),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
             ).toList(),
            options: CarouselOptions(
              height:  250.0,
              initialPage: 0,
              viewportFraction: 1 ,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(seconds: 1),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,

            ),
        ),
        const SizedBox (
          height: 1.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox (
                height: 10.0,
              ),
              const Text(
                  'Categories',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox (
                height: 10.0,
              ),
              Container(
                height: 100.0,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                    itemBuilder:(context, index) => buildCategoryItem(categoriesModel.data!.data[index]),
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 10.0,
                    ),
                    itemCount: categoriesModel.data!.data.length,
                ),
              ),
               const SizedBox (
                height: 23.0,
              ),
              const Text(
                'New Products',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox (
          height: 5.0,
        ),
        Container(
          color: Colors.grey[300],
          child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
            mainAxisSpacing: 1.0,
            crossAxisSpacing: 1.0,
            childAspectRatio: 1 / 1.72,
            children: List.generate(
              model.data!.products.length,
                  (index) => buildGridProduct(model.data!.products[index],context),
            ),
          ),
        ),
      ],
    ),
  );

//Start build CategoryItem
  Widget buildCategoryItem (DataModel model ) => Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children: [
       Image(
        image:NetworkImage(model.image!),
        height: 100.0,
        width: 100.0,
        fit: BoxFit.cover,
      ),
      Container(
        color: Colors.black.withOpacity(.8,),
        width: 100.0,
        child: Text(
          model.name!,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style:const TextStyle (
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
//End Build CategoryItem
  //Start Build GridProducts
  Widget buildGridProduct(ProductsModel model, context ) =>Container(
    color: Colors.white,
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              image: NetworkImage(model.image!),
              width: double.infinity,
              height: 200.0,

            ),
             if(model.discount != 0)
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
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:const TextStyle(
                  height: 1.3,
                  fontSize: 14.0,
                ),

              ),
              Row(
                children:
                [
                  Text(
                    '${model.price.round()}',
                    style:const TextStyle(
                      color: defaultColor,
                      fontSize: 12.0,
                    ),

                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  if(model.discount != 0 )
                    Text(
                      '${model.old_price.round()}',
                      style:const TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                        decoration: TextDecoration.lineThrough,
                      ),

                    ),
                  const Spacer(),
                   CircleAvatar(
                     radius: 15.0,
                     backgroundColor:ShopCubit.get(context).favorites[model.id!]! ? Colors.red : Colors.red[100],
                     child: IconButton (
                       onPressed: ()
                       {
                         ShopCubit.get(context).changeFavorites(model.id!);
                         print(model.id!);
                       },
                       padding: EdgeInsets.zero,
                        icon: const Icon(
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
  );
  //End Build GridProducts
}
