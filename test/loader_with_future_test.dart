
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zbot_app/resources/loader_with_future.dart';

void main() {
  testWidgets('should render circular loading while Future is not completed', (WidgetTester tester) async {
    await tester.pumpWidget(LoaderWithFutureWidget<String>(
      apiCall: Future<String>.delayed(Duration(seconds: 2)).then((value) => 'done'),
      create: (context, snapshot) {
        return FlutterLogo();
      },
    ).wrapWithMaterial());


    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(FlutterLogo), findsNothing);

    tester.pump(Duration(seconds: 3));
  });

  testWidgets('should render create widget when Future is completed', (WidgetTester tester) async {
    await tester.pumpWidget(LoaderWithFutureWidget<String>(
      apiCall: Future<String>.value('done value'),
      create: (context, snapshot) {
        return FlutterLogo();
      },
    ).wrapWithMaterial());

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(FlutterLogo), findsOneWidget);
  });
}

extension on Widget{
  Widget wrapWithMaterial() => MaterialApp(
    home: Scaffold(
      body: this,
    ),
  );
}
