import 'package:flutter/material.dart';
import 'package:helpmeapp/providers/friends_provider.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatefulWidget {
  final Function callback;
  final TextEditingController _controller;
  SearchBar(this.callback, this._controller);
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  FocusNode _focusNode = new FocusNode();

  TextEditingController _controller;
  bool _issearch = false;
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onfocusChange);
  }

  void _onfocusChange() {
    setState(() {
      _focusNode.hasFocus ? _issearch = true : _issearch = false;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
          margin: _issearch
              ? EdgeInsets.only(top: 28, left: 10, right: 10)
              : EdgeInsets.all(28),
          child: TextFormField(
            controller: widget._controller,
            onFieldSubmitted: (value) {
              widget.callback(value, context);
            },
            focusNode: _focusNode,
            decoration: InputDecoration(
                icon: _issearch
                    ? null
                    : Container(
                        margin: EdgeInsets.all(14),
                        child: Icon(Icons.search),
                      ),
                labelText: "Who is your friend"),
          )),
    );
  }
}
