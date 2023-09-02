import 'package:equations/equations.dart';
import 'package:equations/src/utils/exceptions/types/numerical_integration_exception.dart';
import 'package:equations/src/utils/factorial.dart';
import 'package:test/test.dart';

// ignore_for_file: prefer_const_constructors

/// In order to achieve 100% code coverage, this file calls some constructors
/// containing `super` calls **WITHOUT** the `const` keyword. In this way, the
/// coverage report tool can mark as "covered" even constructors with `super`
/// calls.
void main() {
  group('Testing constructors of the classes', () {
    test('Exceptions constructors', () {
      expect(
        AlgebraicException('Message'),
        isA<AlgebraicException>(),
      );
      expect(
        ComplexException('Message'),
        isA<ComplexException>(),
      );
      expect(
        MatrixException('Message'),
        isA<MatrixException>(),
      );
      expect(
        NonlinearException('Message'),
        isA<NonlinearException>(),
      );
      expect(
        NumericalIntegrationException('Message'),
        isA<NumericalIntegrationException>(),
      );
      expect(
        SystemSolverException('Message'),
        isA<SystemSolverException>(),
      );
      expect(
        ExpressionParserException('Message'),
        isA<ExpressionParserException>(),
      );
      expect(
        PolynomialLongDivisionException('Message'),
        isA<PolynomialLongDivisionException>(),
      );
      expect(
        InterpolationException('Message'),
        isA<InterpolationException>(),
      );
    });

    test('Exception objects comparison', () {
      final testException = AlgebraicException('message');

      expect(testException.message, equals('message'));
      expect(testException.messagePrefix, equals('AlgebraicException'));
    });

    test('Nonlinear constructors', () {
      expect(
        Bisection(function: 'x+1', a: 0, b: 0),
        isA<Bisection>(),
      );
      expect(
        Brent(function: 'x+1', a: 0, b: 0),
        isA<Brent>(),
      );
      expect(
        Chords(function: 'x+1', a: 0, b: 0),
        isA<Chords>(),
      );
      expect(
        Newton(function: 'x+1', x0: 0),
        isA<Newton>(),
      );
      expect(
        RegulaFalsi(function: 'x+1', a: 0, b: 0),
        isA<RegulaFalsi>(),
      );
      expect(
        Secant(function: 'x+1', a: 0, b: 0),
        isA<Secant>(),
      );
      expect(
        Steffensen(function: 'x+1', x0: 0),
        isA<Steffensen>(),
      );
    });

    test('Interpolation constructors', () {
      const nodesList = [
        InterpolationNode(x: 1, y: 3),
        InterpolationNode(x: -4, y: 6),
      ];

      expect(
        LinearInterpolation(nodes: nodesList),
        isA<LinearInterpolation>(),
      );
      expect(
        PolynomialInterpolation(nodes: nodesList),
        isA<PolynomialInterpolation>(),
      );
      expect(
        NewtonInterpolation(nodes: nodesList),
        isA<NewtonInterpolation>(),
      );
      expect(
        SplineInterpolation(nodes: nodesList),
        isA<SplineInterpolation>(),
      );
    });

    test('Numerical integration constructors', () {
      expect(
        TrapezoidalRule(function: 'x', lowerBound: 0, upperBound: 0),
        isA<TrapezoidalRule>(),
      );
      expect(
        SimpsonRule(function: 'x', lowerBound: 0, upperBound: 0),
        isA<SimpsonRule>(),
      );
      expect(
        MidpointRule(function: 'x', lowerBound: 0, upperBound: 0),
        isA<MidpointRule>(),
      );
      expect(
        AdaptiveQuadrature(function: 'x', lowerBound: 0, upperBound: 0),
        isA<AdaptiveQuadrature>(),
      );
    });

    test('Other constructors', () {
      expect(
        Factorial(),
        isA<Factorial>(),
      );
    });
  });
}
