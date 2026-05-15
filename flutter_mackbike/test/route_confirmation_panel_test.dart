import 'package:flutter/material.dart';
import 'package:flutter_mackbike/features/navigation/models/route_model.dart';
import 'package:flutter_mackbike/features/navigation/view_models/navigation_view_model.dart';
import 'package:flutter_mackbike/features/navigation/widgets/route_confirmation_panel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('RouteConfirmationPanel shows route info and buttons', (
    WidgetTester tester,
  ) async {
    final viewModel = NavigationViewModel();
    final route = RouteModel(
      polylinePoints: [LatLng(0, 0)],
      distance: 12345,
      instructions: [],
    );
    viewModel.forceRoute(route);
    viewModel.forceState(NavigationState.preview);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: viewModel,
        child: MaterialApp(
          home: Scaffold(
            body: Stack(children: const [RouteConfirmationPanel()]),
          ),
        ),
      ),
    );

    expect(find.text('Route to Destination'), findsOneWidget);
    expect(find.text('Distance: 12.35 km'), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('RouteConfirmationPanel calls cancelRoutePreview on cancel tap', (
    WidgetTester tester,
  ) async {
    final viewModel = NavigationViewModel();
    final route = RouteModel(
      polylinePoints: [LatLng(0, 0)],
      distance: 12345,
      instructions: [],
    );
    viewModel.forceRoute(route);
    viewModel.forceState(NavigationState.preview);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: viewModel,
        child: MaterialApp(
          home: Scaffold(
            body: Stack(children: const [RouteConfirmationPanel()]),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Cancel'));
    await tester.pump();

    expect(viewModel.navigationState, NavigationState.idle);
    expect(viewModel.currentRoute, isNull);
  });
}
