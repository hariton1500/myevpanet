import 'package:flutter/material.dart';
import 'package:myevpanet/api/api.dart';
import 'package:myevpanet/main.dart';
import 'package:myevpanet/push_screen/notif.dart';

class PushScreen extends StatefulWidget {
  @override
  _PushScreenState createState() => _PushScreenState();
}

class _PushScreenState extends State<PushScreen> {
  Pushes pushes = Pushes();

  @override
  void initState() {
    pushes.loadSavedPushes().then((pushesList) {
      pushesList.sort((a, b) => b.date.compareTo(a.date));
      setState(() {});
    });
    //pushes = Pushes();
    //setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        pushes.pushes.length > 0
            ? IconButton(
                icon: Icon(Icons.delete_forever_rounded),
                onPressed: () async {
                  pushes.pushes.clear();
                  await pushes.savePushes();
                  setState(() {});
                },
              )
            : Text('')
      ], backgroundColor: Color(0xff32506a), title: Text('Мои уведомления')),
      body: ListView(children: listRows()),
    );
  }

  List<Widget> listRows() {
    List<Widget> _list = [];
    dprintD('forming pushes widgets list...', verbose);
    pushes.pushes.forEach((_push) {
      dprintD(_push, verbose);
      _list.add(
        GestureDetector(
          onTap: () async {
            setState(() {
              _push.seen = true;
              pushes.savePushes();
            });
            dprintL('go to one push show screen');
            var toDelete = await Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => OneNotif(_push)));
            if (toDelete.runtimeType.toString() != 'bool') toDelete = false;
            if (toDelete) {
              pushes.pushes.remove(_push);
              pushes.savePushes();
              setState(() {});
            }
          },
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: CustomListItemTwo(
              thumbnail: Container(
                decoration: BoxDecoration(
                    color: _push.seen ? Color(0xff42617e) : Colors.redAccent,
                    shape: BoxShape.circle),
                alignment: Alignment(0.0, 0.0),
                child: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 32.0,
                ),
              ),
              title: "ID: " + _push.id.toString(),
              subtitle: _push.body,
              author: _push.title,
              publishDate: _push.date
                  .toString()
                  .substring(0, _push.date.toString().length - 7),
              isFullSubtitle: false,
            ),
          ),
        ),
      );
      _list.add(Divider());
    });
    return _list;
  }
}

class CustomListItemTwo extends StatelessWidget {
  CustomListItemTwo(
      {Key key,
      this.thumbnail,
      this.title,
      this.subtitle,
      this.author,
      this.publishDate,
      this.readDuration,
      this.isFullSubtitle})
      : super(key: key);

  final Widget thumbnail;
  final String title;
  final String subtitle;
  final String author;
  final String publishDate;
  final String readDuration;
  final bool isFullSubtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: isFullSubtitle ? 190 : 90,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 0.3,
              child: thumbnail,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                child: _ArticleDescription(
                  title: title,
                  subtitle: subtitle,
                  author: author,
                  publishDate: publishDate,
                  isFullSubtitle: isFullSubtitle,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ArticleDescription extends StatelessWidget {
  _ArticleDescription(
      {Key key,
      this.title,
      this.subtitle,
      this.author,
      this.publishDate,
      this.readDuration,
      this.isFullSubtitle})
      : super(key: key);

  final String title;
  final String subtitle;
  final String author;
  final String publishDate;
  final String readDuration;
  final bool isFullSubtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$title',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Text(
                '$subtitle',
                maxLines: isFullSubtitle ? null : 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                '$author',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black87,
                ),
              ),
              Text(
                '$publishDate ★',
                style: const TextStyle(
                  fontSize: 10.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
