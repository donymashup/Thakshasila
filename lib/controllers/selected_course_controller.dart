import 'package:get/get.dart';
import 'package:takshasila_app/models/available_courses_model.dart';

class CourseController extends GetxController {
  Rx<CourseDetails?> selectedCourse = Rx<CourseDetails?>(null);

  void setCourse(CourseDetails course) {
    selectedCourse.value = course;
  }
}