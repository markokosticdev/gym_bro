import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gym_bro/schema/enums/exercise_enum.dart';
import 'package:gym_bro/schema/structs/workout_set_struct.dart';
import 'package:gym_bro/screens/widgets/workout_set_card/workout_set_card_widget.dart';

void main() {
  testWidgets('WorkoutSetCardWidget displays correct information and handles onEdit',
          (WidgetTester tester) async {
        // Sample WorkoutSetStruct data
        final workoutSet = WorkoutSetStruct(exercise: Exercise.BarbellRow, weight: 25, repetitions: 15);

        // Variable to track whether onEdit is called
        bool onEditCalled = false;

        // Create the widget
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold( // Wrap in Scaffold to provide Material context
              body: WorkoutSetCardWidget(
                workoutSet: workoutSet,
                onEdit: (WorkoutSetStruct workoutSet) async {
                  onEditCalled = true;
                },
                index: 0,
              ),
            ),
          ),
        );

        // Verify the text is displayed correctly
        expect(find.text('1 - BarbellRow'), findsOneWidget);
        expect(find.text('25 kg'), findsOneWidget);
        expect(find.text('15 reps'), findsOneWidget);

        // Simulate tapping the edit button
        await tester.tap(find.byKey(ValueKey('editWorkoutSet')));
        await tester.pumpAndSettle();

        // Verify that onEdit was called
        expect(onEditCalled, true);
      });
}
