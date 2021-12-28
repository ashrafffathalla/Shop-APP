import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:udemy_flutter/modules/shop_app/login/shoplogin_screen.dart';
import 'package:udemy_flutter/shared/components/components.dart';
import 'package:udemy_flutter/shared/network/local/cach_helper.dart';
import 'package:udemy_flutter/shared/network/local/cach_helper.dart';
import 'package:udemy_flutter/shared/styles/colors.dart';
class BoardingModel{
  final String image;
  final String title;
  final String body;
  BoardingModel({
   required this.image,
   required this.title,
   required this.body,

});
}
class OnBoardingScreen extends StatefulWidget
{

  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardingController = PageController();

List<BoardingModel> boarding =
[
  BoardingModel(
    image: 'assets/images/onboard_1.png',
    title: 'title Boarding 1',
    body: 'body Boarding 1',
  ),
  BoardingModel(
    image: 'assets/images/onboard_1.png',
    title: 'title Boarding 2',
    body: 'body Boarding 2',
  ),
  BoardingModel(
    image: 'assets/images/onboard_1.png',
    title: 'title Boarding 3',
    body: 'body Boarding 3',
  ),
];

bool isLast = false;
void submit (){
  CacheHelper.saveData(
      key: 'onBoarding',
      value: true
  ).then((value) {
    if(value!){
      navigateAndFinish(
          context,
          ShopLoginScreen(),
      );
    }
  });

}

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: ()
              {
                submit();

              },
              child: const Text(
                  'SKIP',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
           Expanded(
             child: PageView.builder(
               physics: const BouncingScrollPhysics(),
               controller: boardingController,
               onPageChanged: (int index )
               {
               if(index == boarding.length-1)
               {
               setState(() {
                 isLast = true;
               });
               }else
                 {
                 setState(() {
                   isLast = false;
                 });
               }
               },
               itemBuilder: (context,index)=>buildBoardingItem(boarding[index]),
               itemCount: boarding.length,
             ),


           ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
              SmoothPageIndicator(
                  controller: boardingController,
                  count: boarding.length,
                effect: const ExpandingDotsEffect(
                  dotColor: Colors.grey,
                  activeDotColor: defaultColor,
                  dotHeight: 10,
                  dotWidth: 10,
                  spacing: 5,
                  expansionFactor: 4,
                ),
              ),
                Spacer(),
                FloatingActionButton(
                    onPressed:()
                    {
                      if(isLast){
                        submit();
                      }
                      else{
                        boardingController.nextPage(
                          duration:const  Duration(
                            milliseconds: 750,
                          ),
                          curve: Curves.fastLinearToSlowEaseIn,
                        );
                      }
                    } ,
                    child: const Icon(
                      Icons.arrow_forward_ios,
                    ),
                    ),

              ],
            ),
          ],
        ),
      ),
    );
  }

      Widget buildBoardingItem(BoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children:  [
      Expanded(
      child: Image  (
      image: AssetImage('${model.image}'),
      ),
      ),
      const SizedBox(
      height: 30.0,
      ),

      Text(
      '${model.title}',
      style: TextStyle(
      fontSize: 24.0,

      ),
      ),
      SizedBox(
      height: 30.0,
      ),
      Text(
      '${model.body}',
      style: TextStyle(
      fontSize: 14.0,

      ),
      ),
        SizedBox(
          height: 30.0,
        ),
      ],
      );
}