import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmer_infoline/config/config.dart';
import 'package:cmer_infoline/services/app_service.dart';

class Article {

  String? category;
  String? contentType;
  String? title;
  String? description;
  String? thumbnailImagelUrl;
  String? youtubeVideoUrl;
  String? videoID;
  int? loves;
  String? sourceUrl;
  String? date;
  String? timestamp;
  int? views;

  Article({
    
    this.category,
    this.contentType,
    this.title,
    this.description,
    this.thumbnailImagelUrl,
    this.youtubeVideoUrl,
    this.videoID,
    this.loves,
    this.sourceUrl,
    this.date,
    this.timestamp,
    this.views,
    
  });


  factory Article.fromFirestore(DocumentSnapshot snapshot){
    Map d = snapshot.data() as Map<dynamic, dynamic>;

    //Config is used to check if user is using either English or French
    if (Config().lang == 'Cancel') {
      return Article(
        category: d['category'],
        contentType: d['content type'],
        title: d['title'],
        description: d['description'],
        thumbnailImagelUrl: d['image url'],
        youtubeVideoUrl: d['youtube url'],
        videoID: d['content type'] == 'video'? AppService.getYoutubeVideoIdFromUrl(d['youtube url']) : '',
        loves: d['loves'],
        sourceUrl: d['source'],
        date: d['date'],
        timestamp: d['timestamp'],
        views: d['views'] ?? null,
      );
    }else{
      return Article(
        category: d['category french'],
        contentType: d['content type'],
        title: d['title french'],
        description: d['description french'],
        thumbnailImagelUrl: d['image url'],
        youtubeVideoUrl: d['youtube url french'],
        videoID: d['content type'] == 'video'? AppService.getYoutubeVideoIdFromUrl(d['youtube url']) : '',
        loves: d['loves'],
        sourceUrl: d['source'],
        date: d['date'],
        timestamp: d['timestamp'],
        views: d['views'] ?? null,
      );
    }

   
  }
}