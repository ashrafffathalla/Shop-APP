import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_flutter/modules/shop_app/cubit/cubit.dart';
import 'package:udemy_flutter/modules/shop_app/cubit/states.dart';
import 'package:udemy_flutter/modules/shop_app/login/shoplogin_screen.dart';
import 'package:udemy_flutter/modules/shop_app/search/search_screen.dart';
import 'package:udemy_flutter/shared/components/components.dart';
import 'package:udemy_flutter/shared/network/local/cach_helper.dart';
class ShopLayout extends StatelessWidget {
  const ShopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var cubit = ShopCubit.get(context);
        return  Scaffold(
          appBar: AppBar(
            title:const  Text('Salla',),
            actions: [
              IconButton(
                onPressed: ()
                {
                  navigateTo(
                      context,
                     const SearchScreen(),
                  );

                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
          body: cubit.bottomScreens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap:(index)
            {
              cubit.changeBottom(index);
            },
            currentIndex: cubit.currentIndex,
            items: const[
               BottomNavigationBarItem(
                 icon: Icon(Icons.home_outlined),
                 label: 'Home',
              ),
               BottomNavigationBarItem(
                 icon: Icon(Icons.apps),
                 label: 'Categories',
              ),
               BottomNavigationBarItem(
                 icon: Icon(Icons.favorite),
                 label: 'Favorites',
              ),
               BottomNavigationBarItem(
                 icon: Icon(Icons.settings,),
                 label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}