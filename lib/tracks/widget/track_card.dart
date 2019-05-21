import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:smart_house/tracks/model/track_model.dart';
class TrackCard extends StatefulWidget {
  final Track track;
  final VoidCallback onTapPlay;
  final VoidCallback onTapFavourite;
  final List<Widget> secondary;
  TrackCard({Key key, this.track, this.onTapPlay, this.onTapFavourite, this.secondary}) : super(key: key);

  @override
  _TrackCardState createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(Random().nextInt(100000).toString()),
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.5,
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onDismissed: (actionType) {
          print(actionType);
        },
        dismissThresholds: <SlideActionType, double>{
          SlideActionType.primary: 1.0
        },
      ),
      secondaryActions: widget.secondary,
      actions: <Widget>[
        SlideAction(
          child: ListView(
            children: <Widget>[
            Text('Training description',style: TextStyle(fontSize: 20.0,color: Colors.white),textAlign: TextAlign.center,),
            Padding(
              padding: EdgeInsets.only(left: 8.0,top: 8.0),
              child: Text('${widget.track.description}',textAlign: TextAlign.left,style: TextStyle(color: Colors.white),),
            )
          ],),
          color: Colors.indigo,
          onTap: () => (){},
        ),
      ],
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  child: Card(
                    elevation: 0.0,
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: CachedNetworkImage(
                      imageUrl: widget.track.trackImageUrl,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.image),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0,left: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(child: Text('Training name: ${widget.track.trackName}')),
                        ],
                      ),
//                      Row(
//                        children: <Widget>[
//                          Expanded(child: Text('Training author: ${widget.track.trackAuthor}')),
//                        ],
//                      ),
                      Row(
                        children: <Widget>[
                          Expanded(child: Text('Best score: ${80}')),
                        ],
                      ),
                        Row(
                          children: <Widget>[
                            Expanded(child: Text('Training difficult: ${widget.track.difficult}')),
                          ],
                        ),
                    ],),
                  ),
                ),
              ],),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                widget.onTapFavourite == null ? Container():IconButton(icon: Icon(Icons.favorite,color: Colors.red,),onPressed: (){
                  widget.onTapFavourite();
                },),
                IconButton(icon: Icon(Icons.play_circle_filled),onPressed: (){
                  widget.onTapPlay();
                },)
              ],
            ),
          ],
        )
      ),
    );
  }
}
