import 'package:flutter/material.dart';
import 'package:flutter_mackbike/features/navigation/models/instruction_model.dart';
import 'package:flutter_mackbike/features/navigation/models/route_model.dart';
import 'package:flutter_mackbike/features/navigation/view_models/navigation_view_model.dart';
import 'package:flutter_mackbike/features/navigation/widgets/instructions_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'instructions_widget_test.mocks.dart';

@GenerateMocks([NavigationViewModel])
void main() {
  group('InstructionsWidget', () {
    late MockNavigationViewModel mockViewModel;

    setUp(() {
      mockViewModel = MockNavigationViewModel();
    });

    testWidgets('displays distance and instructions when route is available', (
      WidgetTester tester,
    ) async {
      final route = RouteModel(
        polylinePoints: [LatLng(0, 0), LatLng(1, 1)],
        distance: 1500.0,
        instructions: [
          InstructionModel(
            text: 'Turn left',
            streetName: 'Main St',
            distance: 500.0,
            time: 60,
            sign: -2,
            interval: [0, 1],
          ),
          InstructionModel(
            text: 'Turn right',
            streetName: 'Second St',
            distance: 1000.0,
            time: 120,
            sign: 2,
            interval: [1, 2],
          ),
        ],
      );

      when(mockViewModel.currentRoute).thenReturn(route);

      await tester.pumpWidget(
        ChangeNotifierProvider<NavigationViewModel>.value(
          value: mockViewModel,
          child: const MaterialApp(
            home: Scaffold(body: Stack(children: [InstructionsWidget()])),
          ),
        ),
      );

      expect(find.text('Distance: 1.50 km'), findsOneWidget);
      expect(find.text('Instructions:'), findsOneWidget);
      expect(find.text('Turn left'), findsOneWidget);
      expect(find.text('500.0 m'), findsOneWidget);
      expect(find.text('Turn right'), findsOneWidget);
      expect(find.text('1000.0 m'), findsOneWidget);
      expect(find.byIcon(Icons.turn_left), findsOneWidget);
      expect(find.byIcon(Icons.turn_right), findsOneWidget);
    });

    testWidgets('does not display anything when route is null', (
      WidgetTester tester,
    ) async {
      when(mockViewModel.currentRoute).thenReturn(null);

      await tester.pumpWidget(
        ChangeNotifierProvider<NavigationViewModel>.value(
          value: mockViewModel,
          child: const MaterialApp(
            home: Scaffold(body: Stack(children: [InstructionsWidget()])),
          ),
        ),
      );

      expect(find.text('Distance: 1.50 km'), findsNothing);
      expect(find.text('Instructions:'), findsNothing);
    });
  });
}
