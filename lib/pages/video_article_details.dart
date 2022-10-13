import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmer_infoline/blocs/comments_bloc.dart';
import 'package:cmer_infoline/config/config.dart';
import 'package:cmer_infoline/libraries/loader_animation/dot.dart';
import 'package:cmer_infoline/libraries/loader_animation/loader.dart';
import 'package:cmer_infoline/models/comment.dart';
import 'package:cmer_infoline/utils/comment_card.dart';
import 'package:cmer_infoline/utils/loading_cards.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:cmer_infoline/blocs/ads_bloc.dart';
import 'package:cmer_infoline/blocs/bookmark_bloc.dart';
import 'package:cmer_infoline/blocs/sign_in_bloc.dart';
import 'package:cmer_infoline/blocs/theme_bloc.dart';
import 'package:cmer_infoline/models/article.dart';
import 'package:cmer_infoline/models/custom_color.dart';
import 'package:cmer_infoline/pages/comments.dart';
import 'package:cmer_infoline/services/app_service.dart';
import 'package:cmer_infoline/utils/cached_image.dart';
import 'package:cmer_infoline/utils/sign_in_dialog.dart';
import 'package:cmer_infoline/widgets/bookmark_icon.dart';
import 'package:cmer_infoline/widgets/html_body.dart';
import 'package:cmer_infoline/widgets/love_count.dart';
import 'package:cmer_infoline/widgets/love_icon.dart';
import 'package:cmer_infoline/widgets/related_articles.dart';
import 'package:cmer_infoline/widgets/views_count.dart';
import 'package:line_icons/line_icons.dart';
import 'package:share/share.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import '../utils/next_screen.dart';

class VideoArticleDetails extends StatefulWidget {
  final Article? data;
  const VideoArticleDetails({Key? key, required this.data})
      : super(key: key);

  @override
  _VideoArticleDetailsState createState() => _VideoArticleDetailsState();
}

class _VideoArticleDetailsState extends State<VideoArticleDetails> {

  //Getting user review information
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String collectionName = 'contents';
  ScrollController? controller;
  DocumentSnapshot? _lastVisible;
  late bool _isLoading;
  List<DocumentSnapshot> _snap = [];
  List<Comment> _data = [];
  bool? _hasData=false;

  double rightPaddingValue = 140;
  late YoutubePlayerController _controller;

  initYoutube() async {
    _controller = YoutubePlayerController(
        initialVideoId: widget.data!.videoID!,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          forceHD: false,
          loop: true,
          controlsVisibleAtStart: false,
          enableCaption: false,
      )
    );
  }

  void _handleShare() {
    final sb = context.read<SignInBloc>();
    final String _shareTextAndroid = '${widget.data!.title}, Check out this app to explore more. App link: https://play.google.com/store/apps/details?id=${sb.packageName}';
    final String _shareTextiOS = '${widget.data!.title}, Check out this app to explore more. App link: https://play.google.com/store/apps/details?id=${sb.packageName}';

    if (Platform.isAndroid) {
      Share.share(_shareTextAndroid);
    } else{
      Share.share(_shareTextiOS);
    }
  }

  handleLoveClick() {
    bool _guestUser = context.read<SignInBloc>().guestUser;

    if (_guestUser == true) {
      openSignInDialog(context);
    } else {
      context.read<BookmarkBloc>().onLoveIconClick(widget.data!.timestamp);
    }
  }

  handleBookmarkClick() {
    bool _guestUser = context.read<SignInBloc>().guestUser;

    if (_guestUser == true) {
      openSignInDialog(context);
    } else {
      context.read<BookmarkBloc>().onBookmarkIconClick(widget.data!.timestamp);
    }
  }


  _initInterstitialAds (){
    final adb = context.read<AdsBloc>();
    Future.delayed(Duration(milliseconds: 0)).then((value){
      if(adb.interstitialAdEnabled == true){
        context.read<AdsBloc>().loadAds();
      }
    });
  }


  @override
  void initState() {
    super.initState();
    initYoutube();
    _initInterstitialAds();
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      setState(() {
        rightPaddingValue = 10;
      });
    });

    setState(() {
      _isLoading = true;
      _getData();
    });
  }


  Future<Null> _getData() async {
    setState(() => _hasData = true);
    await context.read<CommentsBloc>().getFlagList();
    QuerySnapshot data;
    if (_lastVisible == null)
      data = await firestore
          .collection('$collectionName/${widget.data!.timestamp}/comments')
          .orderBy('timestamp', descending: true)
          .limit(5)
          .get();
    else
      data = await firestore
          .collection('$collectionName/${widget.data!.timestamp}/comments')
          .orderBy('timestamp', descending: true)
          .startAfter([_lastVisible!['timestamp']])
          .limit(5)
          .get();

    if (data.docs.length > 0) {
      _lastVisible = data.docs[data.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _snap.addAll(data.docs);
          _data = _snap.map((e) => Comment.fromFirestore(e)).toList();
        });
      }
    } else {
      if (_lastVisible == null) {
        setState(() {
          _isLoading = false;
          _hasData = false;
          print('no items');
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasData = true;
          print('no more items');
        });
      }
    }
    return null;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    final Article d = widget.data!;

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        thumbnail: CustomCacheImage(imageUrl: d.thumbnailImagelUrl, radius: 0),
      ),
      builder: (context, player){
        return Scaffold(
        body: SafeArea(
          bottom: false,
          top: true,
          ///Check if the data is still loading and show layout only when loading is complete
          child: _isLoading!=true?Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          child: player,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 5.0),
                                child: CircleAvatar(
                                  backgroundColor: Config().appColorGreen.withOpacity(0.9),
                                  child: IconButton(
                                    alignment: Alignment.center,
                                    icon: Icon(
                                      LineIcons.arrowLeft,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),

                              Spacer(),

                              d.sourceUrl == null 
                              ? Container()
                              : IconButton(
                                icon: Icon(Feather.external_link, size: 22, color: Colors.white),
                                onPressed: ()=> AppService().openLinkWithCustomTab(context, d.sourceUrl!),
                              ), 
                              IconButton(
                                icon: Icon(Icons.share,
                                    size: 22, color: Colors.white),
                                onPressed: () {
                                  _handleShare();
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: context.watch<ThemeBloc>().darkTheme == false
                                          ? Config().appColorRed.withOpacity(0.9) //CustomColor().loadingColorLight
                                          : Config().appColorRed.withOpacity(0.9), //CustomColor().loadingColorDark
                                    ),
                                    child: AnimatedPadding(
                                      duration: Duration(milliseconds: 1000),
                                      padding: EdgeInsets.only(left: 10,right: rightPaddingValue,top: 5,bottom: 5),
                                      child: Text(
                                        d.category!,
                                        style: TextStyle(
                                          color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
                                Spacer(),
                                IconButton(
                                    icon: BuildLoveIcon(
                                        collectionName: 'contents',
                                        uid: sb.uid,
                                        timestamp: d.timestamp),
                                    onPressed: () {
                                      handleLoveClick();
                                    }),
                                IconButton(
                                    icon: BuildBookmarkIcon(
                                        collectionName: 'contents',
                                        uid: sb.uid,
                                        timestamp: d.timestamp),
                                    onPressed: () {
                                      handleBookmarkClick();
                                    }),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(CupertinoIcons.time_solid,
                                    size: 18, color: Colors.grey),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  d.date!,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              d.title!,
                              style: TextStyle(
                                fontSize: 20, 
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.6,
                                wordSpacing: 1
                              ),
                            ),
                            Divider(
                              color: Config().appColorRed,
                              endIndent: 200,
                              thickness: 2,
                              height: 20,
                            ),
                                SizedBox(height: 10,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    
                                    //views feature
                                    ViewsCount(article: d,),
                                    SizedBox(width: 20,),

                                    LoveCount(collectionName: 'contents',timestamp: d.timestamp),
                                    
                                    
                                  ],
                                ),
                            SizedBox(
                              height: 20,
                            ),
                            HtmlBodyWidget(htmlData: d.description!),


                            /// First User Reviews will show up in this section
                            SizedBox(
                              height: 15.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 0.0,
                              ),
                              child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Comments",
                                      style: TextStyle(
                                          fontFamily: "Sofia",
                                          fontSize: 20.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        nextScreen(
                                            context,
                                            CommentsPage(
                                                timestamp: widget
                                                    .data!.timestamp));
                                      },
                                      child: Text(
                                        "See All",
                                        style: TextStyle(
                                            fontFamily: "Sofia",
                                            color: Colors.black54,
                                            fontSize: 16.0,
                                            fontWeight:
                                            FontWeight.w400),
                                      ),
                                    ),
                                  ]),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            _hasData == false
                                ? Container(
                              width: MediaQuery. of(context). size. width,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    Container(
                                      child: Image.asset(
                                        "assets/images/no_reviews.jpeg",
                                        fit: BoxFit.cover,
                                        height: 170,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    Text(
                                      "No Comment Available yet",
                                      style: TextStyle(
                                          fontFamily: "Sofia",
                                          fontWeight:
                                          FontWeight.w600,
                                          color: Colors.black45,
                                          fontSize: 15.0),
                                    )
                                  ]),
                            )
                                : ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              primary: false,
                              padding: EdgeInsets.all(15),
                              itemCount: _data.length != 0 ? _data.length + 1 : 10,
                              separatorBuilder: (BuildContext context, int index) =>
                                  SizedBox(
                                    height: 10,
                                  ),
                              itemBuilder: (_, int index) {
                                if (index < _data.length) {
                                  return CommentCard(data: _data[index],);
                                }
                                return Opacity(
                                  opacity: _isLoading ? 1.0 : 0.0,
                                  child: _lastVisible == null
                                      ? LoadingCard(height: 100)
                                      : Center(
                                    child: SizedBox(
                                        width: 32.0,
                                        height: 32.0,
                                        child: new CupertinoActivityIndicator()),
                                  ),
                                );
                              },
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              child: RelatedArticles(
                              category: d.category,
                              timestamp: d.timestamp,
                              replace: true,)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ):Center(
              child: ColorLoader5(
                dotOneColor: Colors.green,
                dotTwoColor: Colors.red,
                dotThreeColor: Colors.yellow,
                dotType: DotType.circle,
                dotIcon: Icon(Icons.adjust),
                duration: Duration(seconds: 1),
              )),
        
        ));
      },
    );
  }
}
