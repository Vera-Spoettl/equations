import 'dart:math' as math;
import 'package:equations_solver/blocs/navigation_bar/navigation_bar.dart';
import 'package:equations_solver/routes/utils/breakpoints.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/bottom_navigation_bar.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/navigation_item.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/rail_navigation.dart';
import 'package:equations_solver/routes/utils/equation_scaffold/tabbed_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _assertionError = 'There must be at least 1 navigation item.';

/// A simple wrapper of [Scaffold]. This widget is meant to be used across the
/// entire app to setup the minimal "skeleton" of the UI. This scaffold is made
/// up of two parts:
///
///  - an [AppBar] with no title and a dark/light theme switcher;
///  - the body of the [Scaffold];
///  - an optional [FloatingActionButton].
///
/// This widget also contains a responsive navigation bar which can be either a
/// [BottomNavigationBar] or a [NavigationRail] according with the screen's size.
class EquationScaffold extends StatefulWidget {
  /// The body of the [Scaffold]. When there's a [navigationItems] list defined,
  /// this widget is ignored because the actual body of the scaffold will be
  /// determined by the contents of the list.
  final Widget body;

  /// A list of items for a responsive navigation bar. If the list is empty,
  /// then no navigation bars appear on the screen.
  final List<NavigationItem> navigationItems;

  /// A [FloatingActionButton] widget placed on the bottom-left corner of the
  /// screen.
  final FloatingActionButton? fab;

  /// Creates a custom [Scaffold] widget with no built-in navigation.
  const EquationScaffold({
    super.key,
    required this.body,
    this.fab,
  }) : navigationItems = const [];

  /// Creates a custom [Scaffold] widget with built-in tabbed navigation. There
  /// must be at least 1 navigation item.
  const EquationScaffold.navigation({
    super.key,
    required this.navigationItems,
    this.fab,
  })  : body = const SizedBox.shrink(),
        assert(
          navigationItems.length > 0,
          _assertionError,
        );

  @override
  _EquationScaffoldState createState() => _EquationScaffoldState();
}

class _EquationScaffoldState extends State<EquationScaffold>
    with SingleTickerProviderStateMixin {
  /// Controls the position of the currently visible page.
  late final tabController = TabController(
    length: widget.navigationItems.length,
    vsync: this,
  );

  @override
  void dispose() {
    // The 'tabController' is lazily initialized and it may never be used if
    // there are no navigation items. For this reason, it has to be disposed
    // only when a tabbed layout is used, which is when there are navigation
    // items defined.
    if (widget.navigationItems.isNotEmpty) {
      tabController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If there are NO navigation items, then no navigation bars are required
    if (widget.navigationItems.isEmpty) {
      return LayoutBuilder(
        builder: (context, dimensions) => Scaffold(
          body: _ScaffoldContents(
            body: widget.body,
            extraBackground: dimensions.maxWidth >= extraBackgroundBreakpoint,
          ),
          floatingActionButton: widget.fab,
        ),
      );
    }

    // At this point, there's at least 1 navigation item and thus the widget
    // requires some responsiveness!
    return BlocProvider<NavigationCubit>(
      create: (_) => NavigationCubit(),
      child: LayoutBuilder(
        builder: (context, dimensions) {
          final hasExtra = dimensions.maxWidth >= extraBackgroundBreakpoint;

          // If the dimension of the screen is "small" enough, a bottom navigation
          // bar fits better
          if (dimensions.maxWidth <= bottomNavigationBreakpoint) {
            return Scaffold(
              key: const Key('TabbedNavigationLayout-Scaffold'),
              body: _ScaffoldContents(
                body: TabbedNavigationLayout(
                  tabController: tabController,
                  navigationItems: widget.navigationItems,
                ),
                extraBackground: hasExtra,
              ),
              bottomNavigationBar: BottomNavigation(
                navigationItems: widget.navigationItems,
              ),
              floatingActionButton: widget.fab,
            );
          }

          return Scaffold(
            key: const Key('RailNavigationLayout-Scaffold'),
            body: _ScaffoldContents(
              body: RailNavigation(
                tabController: tabController,
                navigationItems: widget.navigationItems,
              ),
              extraBackground: hasExtra,
            ),
            floatingActionButton: widget.fab,
          );
        },
      ),
    );
  }
}

/// The content of the [EquationScaffold] scaffold, which is simply a [Stack]
/// with two children:
///
///   - A background widget that draws an SVG image as background,
///   - A foreground widget which is the actual content of the page.
///
/// If there is enough space in the horizontal axis, an additional background
/// image is added.
class _ScaffoldContents extends StatelessWidget {
  /// The body of the [Scaffold]
  final Widget body;

  /// Determines whether there's enough space in the horizontal axis to add
  /// another background image
  final bool extraBackground;

  /// Creates a [_ScaffoldContents] widget.
  const _ScaffoldContents({
    required this.body,
    required this.extraBackground,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // The background image of the page
          const Positioned(
            bottom: -70,
            left: -30,
            child: _ScaffoldBackground(),
          ),

          if (extraBackground)
            const Positioned(
              top: 20,
              right: 80,
              child: _ScaffoldExtraBackground(),
            ),

          // The actual contents in the foreground
          Positioned.fill(
            child: body,
          ),
        ],
      ),
    );
  }
}

/// The contents of the scaffold in the background.
class _ScaffoldBackground extends StatelessWidget {
  /// Creates a [_ScaffoldBackground] widget.
  const _ScaffoldBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height / 1.2;

    return Transform.rotate(
      angle: -math.pi / 8,
      child: SvgPicture.asset(
        'assets/axis.svg',
        key: const Key('ScaffoldBackground'),
        height: size,
        width: size,
      ),
    );
  }
}

/// The contents of the scaffold in the background.
class _ScaffoldExtraBackground extends StatelessWidget {
  /// Creates a [_ScaffoldExtraBackground] widget.
  const _ScaffoldExtraBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.shortestSide / 2;

    return SvgPicture.asset(
      'assets/plot_opacity.svg',
      key: const Key('ScaffoldExtraBackground'),
      height: size,
      width: size,
    );
  }
}
