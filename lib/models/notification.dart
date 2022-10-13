import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmer_infoline/config/config.dart';

class NotificationModel {
  String? title;
  String? description;
  String? date;
  String? timestamp;

  NotificationModel({
    this.title,
    this.description,
    this.date,
    this.timestamp
  });


  factory NotificationModel.fromFirestore(DocumentSnapshot snapshot){
    Map d = snapshot.data() as Map<dynamic, dynamic>;

    //Config is used to check if user is using either English or French
    if (Config().lang == 'Cancel') {
      return NotificationModel(
        title: d['title'],
        description: d['description'],
        date: d['date'],
        timestamp: d['timestamp'],
      );
    }else{
      return NotificationModel(
        title: d['title french'],
        description: d['description french'],
        date: d['date'],
        timestamp: d['timestamp'],
      );
    }
  }
}