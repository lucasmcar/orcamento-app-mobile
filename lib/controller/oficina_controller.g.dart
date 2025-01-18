// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oficina_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OficinaController on OficinaControllerBase, Store {
  late final _$exampleAtom =
      Atom(name: 'OficinaControllerBase.example', context: context);

  @override
  String get example {
    _$exampleAtom.reportRead();
    return super.example;
  }

  @override
  set example(String value) {
    _$exampleAtom.reportWrite(value, super.example, () {
      super.example = value;
    });
  }

  late final _$fetchDataAsyncAction =
      AsyncAction('OficinaControllerBase.fetchData', context: context);

  @override
  Future<void> fetchData() {
    return _$fetchDataAsyncAction.run(() => super.fetchData());
  }

  late final _$OficinaControllerBaseActionController =
      ActionController(name: 'OficinaControllerBase', context: context);

  @override
  void setExample(String value) {
    final _$actionInfo = _$OficinaControllerBaseActionController.startAction(
        name: 'OficinaControllerBase.setExample');
    try {
      return super.setExample(value);
    } finally {
      _$OficinaControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
example: ${example}
    ''';
  }
}
