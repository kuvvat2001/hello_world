import 'package:math_app/domain/models/task_response_data.dart';

abstract class IRepository {
  Future<TaskResponse> getTasks();
  Future<TaskResponse> getLesson();
}
