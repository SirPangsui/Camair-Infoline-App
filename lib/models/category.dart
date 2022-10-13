import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmer_infoline/config/config.dart';

class CategoryModel {
  String? displayCategoryName; //Display Name is the name displayed on the App for different categories which is translated
  String? dataCategoryName; //Data Name is the name for different categories which is not translated and used to fetch data
  String? thumbnailUrl;
  String? timestamp;

  CategoryModel({
    this.displayCategoryName,
    this.dataCategoryName,
    this.thumbnailUrl,
    this.timestamp
  });


  factory CategoryModel.fromFirestore(DocumentSnapshot snapshot){
    Map d = snapshot.data() as Map<dynamic, dynamic>;

    //Config is used to check if user is using either English or French
    if (Config().lang == 'Cancel') {
      return CategoryModel(
        displayCategoryName: d['name'],
        dataCategoryName: d['name'],
        thumbnailUrl: d['thumbnail'],
        timestamp: d['timestamp'],
      );
    }else{
      return CategoryModel(
        displayCategoryName: d['name french'],
        dataCategoryName: d['name'],
        thumbnailUrl: d['thumbnail'],
        timestamp: d['timestamp'],
      );
    }
  }
}