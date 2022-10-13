import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmer_infoline/blocs/comments_bloc.dart';
import 'package:cmer_infoline/config/config.dart';
import 'package:cmer_infoline/libraries/intro_views_flutter-2.4.0/lib/Clipper/circular_reveal_clipper.dart';
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
import 'package:cmer_infoline/widgets/banner_ad_admob.dart'; //admob
//import 'package:news_app/widgets/banner_ad_fb.dart';      //fb ad
import 'package:cmer_infoline/widgets/bookmark_icon.dart';
import 'package:cmer_infoline/widgets/html_body.dart';
import 'package:cmer_infoline/widgets/love_count.dart';
import 'package:cmer_infoline/widgets/love_icon.dart';
import 'package:cmer_infoline/widgets/related_articles.dart';
import 'package:cmer_infoline/widgets/views_count.dart';
import 'package:line_icons/line_icons.dart';
import 'package:share/share.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import '../utils/next_screen.dart';

class ArticleDetails extends StatefulWidget {
  final Article? data;
  final String? tag;

  const ArticleDetails({Key? key, required this.data, required this.tag})
      : super(key: key);

  @override
  _ArticleDetailsState createState() => _ArticleDetailsState();
}

class _ArticleDetailsState extends State<ArticleDetails> {
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

  void _handleShare() {
    final sb = context.read<SignInBloc>();
    final String _shareTextAndroid = '${widget.data!.title}' +
        '\n' +
        'check out this app to explore more android'.tr() +
        'https://play.google.com/store/apps/details?id=${sb.packageName}';
    final String _shareTextiOS = '${widget.data!.title}' +
        '\n' +
        'check out this app to explore more ios'.tr() +
        'https://play.google.com/store/apps/details?id=${sb.packageName}';

    if (Platform.isAndroid) {
      Share.share(_shareTextAndroid);
    } else {
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

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    final Article article = widget.data!;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: true,
          top: false,
          maintainBottomViewPadding: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///Check if the data is still loading and show layout only when loading is complete
              _isLoading!=true?Expanded(
                child: CustomScrollView(
                  slivers: <Widget>[
                    _customAppBar(article, context),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: context
                                                      .watch<ThemeBloc>()
                                                      .darkTheme ==
                                                  false
                                              ? Config().appColorRed.withOpacity(
                                                  0.9) //CustomColor().loadingColorLight
                                              : Config().appColorRed.withOpacity(
                                                  0.9), //CustomColor().loadingColorDark
                                        ),
                                        child: AnimatedPadding(
                                          duration:
                                              Duration(milliseconds: 1000),
                                          padding: EdgeInsets.only(
                                              left: 10,
                                              right: rightPaddingValue,
                                              top: 5,
                                              bottom: 5),
                                          child: Text(
                                            article.category!,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )),
                                    Spacer(),
                                    IconButton(
                                        icon: BuildLoveIcon(
                                            collectionName: 'contents',
                                            uid: sb.uid,
                                            timestamp: article.timestamp),
                                        onPressed: () {
                                          handleLoveClick();
                                        }),
                                    IconButton(
                                        icon: BuildBookmarkIcon(
                                            collectionName: 'contents',
                                            uid: sb.uid,
                                            timestamp: article.timestamp),
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
                                      article.date!,
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
                                  article.title!,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.6,
                                      wordSpacing: 1),
                                ),
                                Divider(
                                  color: Config().appColorRed,
                                  endIndent: 200,
                                  thickness: 2,
                                  height: 20,
                                ),

                                SizedBox(
                                  height: 10,
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    //views feature
                                    ViewsCount(
                                      article: article,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),

                                    LoveCount(
                                        collectionName: 'contents',
                                        timestamp: article.timestamp),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                HtmlBodyWidget(
                                  htmlData: article.description!,
                                ),
                                SizedBox(
                                  height: 20,
                                ),

                                /// First User Reviews
                                SizedBox(
                                  height: 25.0,
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
                                          height: 200,
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
                                  height: 20.0,
                                ),
                              ],
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.all(20),
                              child: RelatedArticles(
                                category: article.category,
                                timestamp: article.timestamp,
                                replace: true,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ):Center(
                  child: ColorLoader5(
                    dotOneColor: Colors.green,
                    dotTwoColor: Colors.red,
                    dotThreeColor: Colors.yellow,
                    dotType: DotType.circle,
                    dotIcon: Icon(Icons.adjust),
                    duration: Duration(seconds: 1),
                  )),

              // -- Banner ads --

              context.watch<AdsBloc>().bannerAdEnabled == false
                  ? Container()
                  : BannerAdAdmob() //admob
              //: BannerAdFb()    //fb
            ],
          ),
        ));
  }

  SliverAppBar _customAppBar(Article article, BuildContext context) {
    return SliverAppBar(
      expandedHeight: 270,
      flexibleSpace: FlexibleSpaceBar(
          background: widget.tag == null
              ? CustomCacheImage(
                  imageUrl: article.thumbnailImagelUrl, radius: 0.0)
              : Hero(
                  tag: widget.tag!,
                  child: CustomCacheImage(
                      imageUrl: article.thumbnailImagelUrl, radius: 0.0),
                )),
      leading: Container(
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
      actions: <Widget>[
        article.sourceUrl == null
            ? Container()
            : IconButton(
                icon: const Icon(Feather.external_link,
                    size: 22, color: Colors.white),
                onPressed: () => AppService()
                    .openLinkWithCustomTab(context, article.sourceUrl!),
              ),
        IconButton(
          icon: const Icon(Icons.share, size: 30, color: Colors.white),
          onPressed: () {
            _handleShare();
          },
        ),
        SizedBox(
          width: 5,
        )
      ],
    );
  }
}


