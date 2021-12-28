import 'package:udemy_flutter/models/shop_app/login_model.dart';

abstract class ShopRegisterStates{}

class ShopRegisterInitialState extends ShopRegisterStates{}

class ShopRegisterLoadingState extends ShopRegisterStates{}

class ShopRegisterSuccessState extends ShopRegisterStates{

    late ShopLoginModel loginModel;

  ShopRegisterSuccessState(this.loginModel);

}

class ShopRegisterErrorState extends ShopRegisterStates{
  late final  String error;
  ShopRegisterErrorState(this.error);
}
class ShopRegisterChangePasswordVisibilityState extends ShopRegisterStates{}