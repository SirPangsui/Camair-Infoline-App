import 'package:cmer_infoline/blocs/theme_bloc.dart';
import 'package:cmer_infoline/models/comment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CommentCard extends StatelessWidget {
  final Comment? data;
  CommentCard({required this.data});



  @override
  Widget build(BuildContext context) {

    String pp = data!.imageUrl.toString();
    String review = data!.comment.toString();
    String name = data!.name.toString();
    String date=data!.date.toString();

    return Padding(
      padding: const EdgeInsets.only(left: 0.0, right: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                      image: NetworkImage(
                        pp,
                      ),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 17.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        date,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              padding: EdgeInsets.only(
                  left: 15.0, top: 15.0, bottom: 15.0, right: 15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0),
                ),
                color: Color(0xff006400).withOpacity(0.1),
              ),
              child: Text(
                review,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: context.read<ThemeBloc>().darkTheme == true ? Colors.white:Colors.black54,
                    fontSize: 17.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}