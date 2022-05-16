import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_data_input.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Dropdown button used to choose which root finding algorithm has to be used
/// in a [NonlinearDataInput] widget.
class NonlinearDropdownSelection extends StatefulWidget {
  /// Creates a [NonlinearDropdownSelection] widget.
  const NonlinearDropdownSelection({super.key});

  @override
  NonlinearDropdownSelectionState createState() =>
      NonlinearDropdownSelectionState();
}

/// The state of the [NonlinearDropdownSelection] class.
@visibleForTesting
class NonlinearDropdownSelectionState
    extends State<NonlinearDropdownSelection> {
  /// The cached dropdown items.
  late final dropdownItems = nonlinearType == NonlinearType.singlePoint
      ? const [
          DropdownMenuItem<NonlinearDropdownItems>(
            key: Key('Newton-Dropdown'),
            value: NonlinearDropdownItems.newton,
            child: Text('Newton'),
          ),
          DropdownMenuItem<NonlinearDropdownItems>(
            key: Key('Steffensen-Dropdown'),
            value: NonlinearDropdownItems.steffensen,
            child: Text('Steffensen'),
          ),
        ]
      : const [
          DropdownMenuItem<NonlinearDropdownItems>(
            key: Key('Bisection-Dropdown'),
            value: NonlinearDropdownItems.bisection,
            child: Text('Bisection'),
          ),
          DropdownMenuItem<NonlinearDropdownItems>(
            key: Key('Secant-Dropdown'),
            value: NonlinearDropdownItems.secant,
            child: Text('Secant'),
          ),
          DropdownMenuItem<NonlinearDropdownItems>(
            key: Key('Brent-Dropdown'),
            value: NonlinearDropdownItems.brent,
            child: Text('Brent'),
          ),
        ];

  /// Updates the currently selected value in the dropdown.
  void changeSelected(NonlinearDropdownItems newValue) =>
      context.read<DropdownCubit>().changeValue(newValue.asString());

  /// The currently selected nonlinear type.
  NonlinearType get nonlinearType =>
      context.read<NonlinearBloc>().nonlinearType;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: nonlinearDropdownWidth,
        child: BlocBuilder<DropdownCubit, String>(
          builder: (context, state) {
            return DropdownButtonFormField<NonlinearDropdownItems>(
              key: const Key('Dropdown-Button-Selection'),
              isExpanded: true,
              value: state.toNonlinearDropdownItems(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
              onChanged: (value) => changeSelected(value!),
              items: dropdownItems,
            );
          },
        ),
      ),
    );
  }
}

/// The possible values of the [NonlinearDropdownSelection] dropdown.
enum NonlinearDropdownItems {
  /// Newton's method.
  newton,

  /// Steffensen's method.
  steffensen,

  /// Bisection method.
  bisection,

  /// Secant method.
  secant,

  /// Brent's method.
  brent,
}

/// Extension method on [NonlinearDropdownItems] to convert a value to a string.
extension NonlinearDropdownItemsExt on NonlinearDropdownItems {
  /// Converts the enum into a [String].
  String asString() {
    switch (this) {
      case NonlinearDropdownItems.newton:
        return 'Newton';
      case NonlinearDropdownItems.steffensen:
        return 'Steffensen';
      case NonlinearDropdownItems.bisection:
        return 'Bisection';
      case NonlinearDropdownItems.secant:
        return 'Secant';
      case NonlinearDropdownItems.brent:
        return 'Brent';
    }
  }
}

/// Extension method on [String] to convert into a [NonlinearDropdownItems] the
/// string value.
extension StringExt on String {
  /// Converts a [String] into a [NonlinearDropdownItems] value.
  NonlinearDropdownItems toNonlinearDropdownItems() {
    switch (toLowerCase()) {
      case 'newton':
        return NonlinearDropdownItems.newton;
      case 'steffensen':
        return NonlinearDropdownItems.steffensen;
      case 'bisection':
        return NonlinearDropdownItems.bisection;
      case 'secant':
        return NonlinearDropdownItems.secant;
      case 'brent':
        return NonlinearDropdownItems.brent;
      default:
        throw ArgumentError(
          'The given string does NOT map to a NonlinearDropdownItems value',
        );
    }
  }
}
