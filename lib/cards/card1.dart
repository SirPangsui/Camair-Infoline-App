import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cmer_infoline/models/article.dart';
import 'package:cmer_infoline/utils/cached_image.dart';
import 'package:cmer_infoline/utils/next_screen.dart';
import 'package:cmer_infoline/widgets/video_icon.dart';

class Card1 extends StatelessWidget {
  final Article d;
  final String heroTag;
  const Card1({Key? key, required this.d, required this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(5),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Theme.of(context).shadowColor,
                    blurRadius: 10,
                    offset: Offset(0, 3))
              ]),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          d.title!,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.red),
                          child: Text(
                            d.category!,
                            style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                            ),
                            child: Hero(
                              tag: heroTag,
                              child: CustomCacheImage(imageUrl: d.thumbnailImagelUrl, radius: 5.0)),
                          ),
                          VideoIcon(contentType: d.contentType, iconSize: 40,)
                        ],
                      ),
                    ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Icon(
                    CupertinoIcons.time,
                    color: Colors.grey,
                    size: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    d.date!,
                    style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 13),
                  ),
                  Spacer(),
                  Icon(
                    Icons.favorite,
                    color: Theme.of(context).secondaryHeaderColor,
                    size: 20,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(d.loves.toString(),
                      style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 13)),
                ],
              )
            ],
          )),
      onTap: () => navigateToDetailsScreen(context, d, heroTag),
    );
  }
}
