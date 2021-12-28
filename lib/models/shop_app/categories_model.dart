import 'package:udemy_flutter/main.dart';

class CategoriesModel
{
  bool? status ;
  CategoriesDataModel? data;

  //named Constructor
CategoriesModel.fromJson(Map<String, dynamic> json)
{
  status = json['status'];
  data = CategoriesDataModel.fromJson(json['data']);
}

}

class CategoriesDataModel
{
  int? current_page;
  List<DataModel> data = [];

  //named Constructor
  CategoriesDataModel.fromJson(Map<String, dynamic> json)
  {
    current_page = json['current_page'];
    json['data'].forEach((element)
    {
      data.add(DataModel.fromJson(element));
    });

  }
}

class DataModel
{
  int? id;
  String? name;
  String? image;

  //named Constructor
  DataModel.fromJson(Map<String,dynamic> json)
  {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}