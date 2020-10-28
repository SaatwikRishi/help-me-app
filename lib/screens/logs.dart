import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:helpmeapp/providers/logs_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LogsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final _logs =;
    final bool isloggedIn =
        FirebaseAuth.instance.currentUser == null ? false : true;

    return Scaffold(
        appBar: AppBar(
          title: Text("LOGS"),
        ),
        body: isloggedIn
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: !isloggedIn
                    ? null
                    : Column(
                        children: [
                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.90,
                              width: MediaQuery.of(context).size.width * 1,
                              child: FutureBuilder(
                                future: Provider.of<LogsProvider>(context)
                                    .retrievelog(),
                                builder: (ctx, snap) {
                                  final List<Log> _logs = snap.data;

                                  if (snap.hasData) {
                                    return ListView.separated(
                                        itemBuilder: (ctx, i) {
                                          return Dismissible(
                                            background: Container(
                                                padding:
                                                    EdgeInsets.only(right: 20),
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                )),
                                            key: Key(i.toString()),
                                            direction:
                                                DismissDirection.endToStart,
                                            onDismissed: (direction) {
                                              _logs.removeAt(i);
                                              return Provider.of<LogsProvider>(
                                                      context,
                                                      listen: false)
                                                  .deletelog(i);
                                            },
                                            child: Card(
                                              child: ListTile(
                                                trailing: Text(DateFormat(
                                                            "dd/MM/yyyy")
                                                        .format(_logs[i].time) +
                                                    " at" +
                                                    DateFormat(" hh:mm:ss")
                                                        .format(_logs[i].time)),
                                                leading:
                                                    Text((i + 1).toString()),
                                                title: Text(
                                                    "Longitude: ${_logs[i].location.longitude}, Latitude: ${_logs[i].location.latitude} "),
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (ctx, _) => Divider(),
                                        itemCount: _logs.length);
                                  }
                                  if (snap.hasError) {
                                    return Center(
                                      child: Text("An Error occoured"),
                                    );
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
              )
            : Center(
                child: Text("You're not logged in"),
              ));
  }
}
