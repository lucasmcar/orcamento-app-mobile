import 'package:mobx/mobx.dart';

// Include the generated file
part 'oficina_controller.g.dart';

class OficinaController = OficinaControllerBase with _$OficinaController;

abstract class OficinaControllerBase with Store {
  // Observables
  @observable
  String example = '';

  // Actions
  @action
  void setExample(String value) {
    example = value;
  }

  // Async Actions
  @action
  Future<void> fetchData() async {
    try {
      example = 'Loading...';
      await Future.delayed(Duration(seconds: 2));
      example = 'Data loaded';
    } catch (e) {
      print('Error: $e');
    }
  }
}
