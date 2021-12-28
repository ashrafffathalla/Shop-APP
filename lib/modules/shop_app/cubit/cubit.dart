import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_flutter/models/shop_app/categories_model.dart';
import 'package:udemy_flutter/models/shop_app/change_favoriets_model.dart';
import 'package:udemy_flutter/models/shop_app/favorites_models.dart';
import 'package:udemy_flutter/models/shop_app/home_model.dart';
import 'package:udemy_flutter/models/shop_app/login_model.dart';
import 'package:udemy_flutter/modules/shop_app/categories/categories_screen.dart';
import 'package:udemy_flutter/modules/shop_app/cubit/states.dart';
import 'package:udemy_flutter/modules/shop_app/favorite/favorits_screen.dart';
import 'package:udemy_flutter/modules/shop_app/products/products_screen.dart';
import 'package:udemy_flutter/modules/shop_app/settings/settings_screen.dart';
import 'package:udemy_flutter/shared/components/constance.dart';
import 'package:udemy_flutter/shared/network/end_point.dart';
import 'package:udemy_flutter/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates>
{
  ShopCubit() :super(ShopInitialState());
  static ShopCubit get(context) => BlocProvider.of(context);

  //Start List OF Screens To Toggle With current State
  int currentIndex = 0 ;
 List<Widget> bottomScreens =
 [
   const ProductsScreen(),
   const CategoriesScreen(),
   const FavoritesScreen(),
         SettingsScreen(),

 ];

 //Start Get Data To ProductsScreen

  //Start changeBottom
 void changeBottom(int index){
   currentIndex = index;
   emit(ShopChangeBottomNavState());
 }
//end changeBottom


  // المكان الخاص بجلب المعلومات في صفحهProductsScreen
 HomeModel? homeModel;

 // start Map favorites
  Map<int, bool> favorites = {};
 // end Map favorites

 void getHomeData(){
   emit(ShopLoadingHomeDataState());

   DioHelper.getData(
       url: HOME,
       token: token,
   ).then((value)
   {
     homeModel = HomeModel.fromJson(value.data);

     // print(homeModel!.data!.banners[0].image!);
     // print(homeModel!.status);

     homeModel!.data!.products.forEach((element)
     {
       favorites.addAll({
         element.id!: element.in_favorites!,
       });
     });
    // print(favorites.toString());
     emit(ShopSuccessHomeDataState());
   }).catchError((error)
   {
     print(error.toString());
     emit(ShopErrorHomeDataState());
   });
 }
//End Get Data To ProductsScreen

  //Start Get Data To CategoriesScreen
    CategoriesModel? categoriesModel ;
void getCategories()
{
  DioHelper.getData(
      url: GET_CATEGORIES,
      token: token,
  ).then((value)
  {
    categoriesModel = CategoriesModel.fromJson(value.data);
    emit(ShopSuccessCategoriesState());
  }).catchError((error)
  {
    print(error.toString());
    emit(ShopErrorCategoriesState());
  });

}
//End Get Data To CategoriesScreen

//start Change Favorites
  ChangeFavoritesModel? changeFavoritesModel;
void changeFavorites(int productId)
{
  // بدايه النقطه المسؤله عن التغيير اللحظي لعلامه favorite
  favorites[productId] = !favorites[productId]!;
  emit(ShopChangeFavoritesState());
  DioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': productId,
      },
    token : token,
  ).then((value)
  {

    changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
    print(value.data);
    if(!changeFavoritesModel!.status!)
    {
      favorites[productId] = !favorites[productId]!;
    } else
      {
        getFavorites();
      }
    emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
  }).catchError((error){

    favorites[productId] = !favorites[productId]!;
    emit(ShopErrorChangeFavoritesState());
  });
}
//End Change Favorites

  //Start Get Data To FavoritesScreen
  FavoritesModel? favoritesModel;
  void getFavorites()
  {
    emit(ShopLoadingGetFavoritesState());

    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value)
    {
      favoritesModel = FavoritesModel.fromJson(value.data);
     //printFullText(value.data.toString());
      emit(ShopSuccessGetFavoritesState());
    }).catchError((error)
    {
      print(error.toString());
      emit(ShopErrorGetFavoritesState());
    });

  }
//End Get Data To FavoritesScreen

//Start Get UserData
  ShopLoginModel? userModel;
  void getUserData()
  {
    emit(ShopLoadingUserDataState());

    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value)
    {
      userModel = ShopLoginModel.fromJson(value.data);
      printFullText(userModel!.data!.name!);
      emit(ShopSuccessUserDataState(userModel!));
    }).catchError((error)
    {
      print(error.toString());
      emit(ShopErrorUserDataState());
    });

  }
//End Get UserData

//Start update UserData
  void updateUserData({
  required String name,
  required String email,
  required String phone,
})
  {
    emit(ShopLoadingUpdateUserState());

    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name':name,
        'email':email,
        'phone':phone,
      },
    ).then((value)
    {
      userModel = ShopLoginModel.fromJson(value.data);
      printFullText(userModel!.data!.name!);
      emit(ShopSuccessUserDataState(userModel!));
    }).catchError((error)
    {
      print(error.toString());
      emit(ShopErrorUserDataState());
    });

  }

//end update UserData

























}