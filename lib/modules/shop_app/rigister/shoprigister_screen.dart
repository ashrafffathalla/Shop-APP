import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_flutter/modules/shop_app/login/cubit/cubit.dart';
import 'package:udemy_flutter/modules/shop_app/login/cubit/states.dart';
import 'package:udemy_flutter/modules/shop_app/rigister/cubit/cubit.dart';
import 'package:udemy_flutter/modules/shop_app/rigister/cubit/states.dart';
import 'package:udemy_flutter/modules/shop_app/shop_layout.dart';
import 'package:udemy_flutter/shared/components/components.dart';
import 'package:udemy_flutter/shared/components/constance.dart';
import 'package:udemy_flutter/shared/network/local/cach_helper.dart';

class ShopRegisterScreen extends StatelessWidget {
   ShopRegisterScreen({Key? key}) : super(key: key);
   var formKey = GlobalKey<FormState>();

   var nameController= TextEditingController();
   var emailController= TextEditingController();
   var passwordController= TextEditingController();
   var phoneController= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
        listener: (context, state)
        {
          if(state is ShopRegisterSuccessState)
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
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REGISTER',
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          'Register now to browse our hot offers',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                            )
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                          controller: nameController,
                          type: TextInputType.text,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Pleas enter your name ';
                            }
                          },
                          label: 'User Name',
                          prefix: Icons.person,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (value) {
                            if (value!.isEmpty) {
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
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'password is to short';
                            }
                          },
                          label: 'Password',
                          prefix: Icons.lock_outlined,
                          suffix: ShopRegisterCubit
                              .get(context)
                              .suffix,
                          onSubmit: (value)
                          {

                          },
                          isPassword: ShopRegisterCubit
                              .get(context)
                              .isPassword,
                          suffixPressed: () {
                            ShopRegisterCubit.get(context)
                                .changePasswordVisibility();
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                          controller: phoneController,
                          type: TextInputType.visiblePassword,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Pleas enter your Phone number ';
                            }
                          },
                          label: 'Phone',
                          prefix: Icons.phone,
                        ),
                        const SizedBox(
                          height: 30,
                        ),

                        ConditionalBuilder(
                          condition: state is! ShopRegisterLoadingState,
                          builder: (context) =>
                              defaultButton(
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    ShopRegisterCubit.get(context).userRegister(
                                        name: nameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        phone: phoneController.text,
                                    );
                                  }
                                },
                                text: 'Register',
                              ),
                          fallback: (context) =>
                          const Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

    );

  }
}
