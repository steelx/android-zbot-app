import 'package:flutter/material.dart';

class LoaderWithFutureWidget<T> extends StatelessWidget{

  final Future<T> _apiCall;
  final Widget Function(T, BuildContext) _create;
  final Widget Function(String, BuildContext) _error;

  LoaderWithFutureWidget({
    Future<T> apiCall,
    Widget Function(T, BuildContext) create,
    Widget Function(String, BuildContext) error,
  }) : _apiCall = apiCall, _create = create, _error = error;

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<T>(
      future: _apiCall,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _create(snapshot.data, context);
        }
        if (snapshot.hasError) {
          if (this._error == null) {
            return Text('' + snapshot.error.toString() + ':' + snapshot.data.toString());
          }
          print(snapshot.error.toString());
          return _error(snapshot.error.toString(), context);
        }
        return Container(
          alignment: Alignment.center,
          child: Transform.scale(scale: 2.0, child: CircularProgressIndicator()),
        );
      },
    );
  }

}
