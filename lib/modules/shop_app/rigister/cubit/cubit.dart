import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_flutter/models/shop_app/login_model.dart';
import 'package:udemy_flutter/modules/shop_app/login/cubit/states.dart';
import 'package:udemy_flutter/modules/shop_app/rigister/cubit/states.dart';
import 'package:udemy_flutter/shared/network/end_point.dart';
import 'package:udemy_flutter/shared/network/remote/dio_helper.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates>
{
  ShopRegisterCubit() : super(ShopRegisterInitialState());
static ShopRegisterCubit get(context) => BlocProvider.of(context);

 ShopLoginModel? loginModel;
//get data method
void userRegister({
  required String name,
  required String email,
  required String password,
  required String phone,
})
{
  emit(ShopRegisterLoadingState());

  DioHelper.postData(
      url: REGISTER,
      data: {
        'name':name,
        'email':email,
        'password':password,
        'phone':phone,
      },
  ).then((value)
  {
    print(value.data);
    loginModel=ShopLoginModel.fromJson(value.data);
     print(loginModel!.status);
     print(loginModel!.message);
     print(loginModel!.data!.token);

    emit(ShopRegisterSuccessState(loginModel!));
  }).catchError((error){
    print(error.toString());
    emit(ShopRegisterErrorState(error.toString()));
  });
}

IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
void changePasswordVisibility()
{
  isPassword = !isPassword;
  suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
  emit(ShopRegisterChangePasswordVisibilityState());
}
}