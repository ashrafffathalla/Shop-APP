import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_flutter/modules/shop_app/cubit/cubit.dart';
import 'package:udemy_flutter/modules/shop_app/cubit/states.dart';
import 'package:udemy_flutter/shared/components/components.dart';
import 'package:udemy_flutter/shared/components/constance.dart';

class SettingsScreen extends StatelessWidget {

   SettingsScreen({Key? key}) : super(key: key);
    var formKey = GlobalKey<FormState>();
    var nameController = TextEditingController();
    var emailController = TextEditingController();
    var phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state)
      {
        if(state is ShopSuccessUserDataState)
          {

          }
      },
      builder: (context, state)
      {
        var model = ShopCubit.get(context).userModel!;
        nameController.text  =model.data!.name!;
        emailController.text =model.data!.email!;
        phoneController.text =model.data!.phone!;
        return ConditionalBuilder(
          condition: ShopCubit.get(context).userModel !=null,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(

                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    if(state is ShopLoadingUpdateUserState)
                    const LinearProgressIndicator(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultFormField(
                      controller: nameController,
                      type: TextInputType.name,
                      validate: (value)
                      {
                        if(value!.isEmpty)
                        {
                          return 'name must be not empty';
                        }
                        return null;
                      },
                      label: 'Name',
                      prefix: Icons.person,
                    ),
                   const SizedBox(
                      height: 20.0,
                    ),
                    /////////////////////
                    defaultFormField(
                      controller: emailController,
                      type: TextInputType.name,
                      validate: (value)
                      {
                        if(value!.isEmpty)
                        {
                          return 'name must be not empty';
                        }
                        return null;
                      },
                      label: 'Email',
                      prefix: Icons.email_outlined,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    /////////////////////
                    defaultFormField(
                      controller: phoneController,
                      type: TextInputType.name,
                      validate: (value)
                      {
                        if(value!.isEmpty)
                        {
                          return 'name must be not empty';
                        }
                        return null;
                      },
                      label: 'Phone',
                      prefix: Icons.phone,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultButton(
                        function: ()
                        {
                          if(formKey.currentState!.validate())
                          {
                            ShopCubit.get(context).updateUserData(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                            );
                          }

                        },
                        text: 'Update Person Data',
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultButton(
                        function: ()
                        {
                          signOut(context);
                        },
                        text: 'Logout'
                    ),
                  ],
                ),
              ),
            ),
          ),
          fallback:(context) => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

}
