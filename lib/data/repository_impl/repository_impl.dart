import 'package:math_app/data/handlers/data_handlers.dart';
import 'package:math_app/domain/models/task_response_data.dart';
import 'package:math_app/domain/repository/repository.dart';

class Repository implements IRepository {
  final _handler = DataHandlers();
  @override
  Future<TaskResponse> getTasks() async {
    final data = await _handler.fetchJsonCompute(
        'assets/quastion.json', TaskResponse.fromJson);
    return data;
  }
  
  @override
  Future<TaskResponse> getLesson() {
    // TODO: #1 implement getLesson
    throw UnimplementedError();
  }
}
