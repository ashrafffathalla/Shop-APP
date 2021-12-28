

//BaseUrl :  https://newsapi.org/
// method (url): v2/top-headlines?
//queries : country=us&category=business&apiKey=f1dc51a27ad64097a663e717f91ea915

//https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=2184d6ee1b864e7c955f5aa3e2ef0308

//https://newsapi.org/v2/everything?q=tesla&from=2021-11-04&sortBy=publishedAt&apiKey=2184d6ee1b864e7c955f5aa3e2ef0308

// Start signOut Method
import 'package:udemy_flutter/modules/shop_app/login/shoplogin_screen.dart';
import 'package:udemy_flutter/shared/components/components.dart';
import 'package:udemy_flutter/shared/network/local/cach_helper.dart';

void signOut(context){
  CacheHelper.removerData(key: 'token',).then((value) {
    if(value!){
      navigateAndFinish(
        context,
        ShopLoginScreen(),
      );
    }
  });
}

void printFullText(String text)
{
  final pattern = RegExp('.{1,8000}'); // 800 is the size of chunk
  pattern.allMatches(text).forEach((match)=>print(match.group(0)));
}
String token ='';