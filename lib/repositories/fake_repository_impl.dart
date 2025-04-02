import 'package:flutter_bloc_timer_trigger/repositories/fake_repository.dart';

class FakeRepositoryImpl implements FakeRepository {
  @override
  Future<void> fetchData() async {
    await Future.delayed(const Duration(milliseconds: 500), () {
      print("====== call api ======");
    });
  }
}
