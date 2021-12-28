import 'package:udemy_flutter/models/shop_app/login_model.dart';

abstract class ShopLoginStates{}

class ShopLoginInitialState extends ShopLoginStates{}

class ShopLoginLoadingState extends ShopLoginStates{}

class ShopLoginSuccessState extends ShopLoginStates{

    late ShopLoginModel loginModel;

  ShopLoginSuccessState(this.loginModel);

}

class ShopLoginErrorState extends ShopLoginStates{
  late final  String error;
  ShopLoginErrorState(this.error);
}
class ShopChangePasswordVisibilityState extends ShopLoginStates{}