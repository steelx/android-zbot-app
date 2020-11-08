import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class StreamProxyProvider<T,R> extends SingleChildStatelessWidget{
  final Stream<R> Function(BuildContext context, T parentValue) _streamProvider;
  final R _initialReturnValue;


  StreamProxyProvider({
    @required Stream<R> Function(BuildContext context, T parentValue) streamProvider,
    @required R initialReturnValue,
  }):
        _streamProvider = streamProvider,
        _initialReturnValue = initialReturnValue;

  @override
  Widget buildWithChild(BuildContext context, Widget child) {

    T parentValue = Provider.of<T>(context);
    Stream<R> stream = _streamProvider(context, parentValue);
    return StreamProvider<R>(
      initialData: _initialReturnValue,
      create: (context) => stream,
      child: child,
    );

  }

}
