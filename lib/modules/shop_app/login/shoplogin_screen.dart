import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:udemy_flutter/modules/shop_app/login/cubit/cubit.dart';
import 'package:udemy_flutter/modules/shop_app/login/cubit/states.dart';
import 'package:udemy_flutter/modules/shop_app/rigister/shoprigister_screen.dart';
import 'package:udemy_flutter/modules/shop_app/shop_layout.dart';
import 'package:udemy_flutter/shared/components/components.dart';
import 'package:udemy_flutter/shared/components/constance.dart';
import 'package:udemy_flutter/shared/network/local/cach_helper.dart';

class ShopLoginScreen extends StatelessWidget
{
   ShopLoginScreen({Key? key}) : super(key: key);

var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var emailController= TextEditingController();
    var passwordController= TextEditingController();
    return BlocProvider(
      create: (BuildContext context)=>ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context,state){
          if(state is ShopLoginSuccessState)
          {
            if(state.loginModel.status!){
              print(state.loginModel.message);
              print(state.loginModel.data!.token);

              CacheHelper.saveData(
                  key: 'token',
                  value: state.loginModel.data!.token,).then((value)
              {
                token = state.loginModel.data!.token!;
                    navigateAndFinish(
                        context,
                        const ShopLayout(),
                    );
              });
            }else
              {
                print(state.loginModel.message);
                showToast(
                  text:state.loginModel.message!,
                    state: ToastStates.ERROR ,
                );
            }
          }
        },
        builder: (context,state){
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key:formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Login now to browse our hot offers',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                          controller:emailController,
                          type:TextInputType.emailAddress ,
                          validate: (value)
                          {
                            if(value!.isEmpty){
                              return 'Pleas enter your email address';
                            }
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        defaultFormField(
                          controller:passwordController,
                          type:TextInputType.visiblePassword ,
                          validate: (value)
                          {
                            if(value!.isEmpty){
                              return 'password is to short';
                            }
                          },
                          label: 'Password',
                          prefix: Icons.lock_outlined,
                          suffix: ShopLoginCubit.get(context).suffix,
                          onSubmit: (value)
                          {
                            if(formKey.currentState!.validate())
                            {
                              ShopLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text
                              );
                            }
                          },

                          isPassword: ShopLoginCubit.get(context).isPassword,
                          suffixPressed: ()
                          {
                             ShopLoginCubit.get(context).changePasswordVisibility();
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        
                        ConditionalBuilder(
                          condition: state is! ShopLoginLoadingState ,
                          builder: (context)=>defaultButton(
                            function: ()
                            {
                              if(formKey.currentState!.validate())
                              {
                                ShopLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text
                                );
                              }

                            },
                            text: 'Login',
                          ),
                          fallback: (context)=> const Center(child:  CircularProgressIndicator()),
                        ),

                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           const  Text('Don\'t have an account?',),
                            TextButton(
                              onPressed: ()
                              {
                                navigateAndFinish(
                                  context,
                                   ShopRegisterScreen(),
                                );
                              },
                              child: const Text(
                                'Register',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
