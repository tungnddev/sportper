import 'package:sportper/domain/entities/user.dart';
import 'package:sportper/utils/definded/strings.dart';

import 'course_vm.dart';

class SportperUserVM {
  SportperUser _user;

  SportperUserVM(this._user);

  SportperUser get user => _user;

  int get age {
    if (_user.birthday == null) return 0;
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - _user.birthday!.year;
    int month1 = currentDate.month;
    int month2 = _user.birthday!.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = _user.birthday!.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  String get ageText => _user.birthday == null ? '${Strings.age}: ${Strings.notSet}' : '${Strings.age} $age ${Strings.years}';

  String get phoneNumber => _user.phoneNumber.isEmpty ? '${Strings.notSetPhone}' : '${_user.phoneNumber}';

  CourseVM? get course => _user.course == null ? null : CourseVM(_user.course!);
}