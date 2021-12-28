class ChangeFavoritesModel
{
  bool? status ;
  String? message;

  //named constructor
ChangeFavoritesModel.fromJson(Map<String, dynamic> json)
  {
    status = json['status'];
    message = json['message'];
  }
}