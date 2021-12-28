import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_flutter/modules/shop_app/cubit/cubit.dart';
import 'package:udemy_flutter/modules/shop_app/search/cubit/cubit.dart';
import 'package:udemy_flutter/modules/shop_app/search/cubit/states.dart';
import 'package:udemy_flutter/shared/components/components.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    var formKey = GlobalKey<FormState>();
    var searchController = TextEditingController();
    return  BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {

        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body:Form(
              key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),

                  child: Column(
                    children: [
                      defaultFormField(
                          controller: searchController,
                          type: TextInputType.text,
                          validate: (value)
                          {
                            if(value!.isEmpty)
                              {
                                return'Enter text to search';
                              }
                           return null;
                          },
                        onSubmit: (String text)
                        {
                          SearchCubit.get(context).search(text);
                        } ,
                          label: 'Search',
                          prefix: Icons.search,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      if(state is SearchLoadingState)
                       const LinearProgressIndicator(),

                      const SizedBox(height: 10,),
                      if(state is SearchSuccessState)
                      Expanded(
                        child: ListView.separated(
                          physics:const BouncingScrollPhysics(),
                          itemBuilder: (context, index) =>buildListProduct(
                            SearchCubit.get(context).model!.data!.data![index],
                            context,
                            isOldPrice:false,
                          ),
                          separatorBuilder: (context, index) => myDivider(),
                          itemCount: SearchCubit.get(context).model!.data!.data!.length,
                        ),
                      )
                    ],
                  ),
                ),
            ),
          );
        },
      ),
    );
  }
}
