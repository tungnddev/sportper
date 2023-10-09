import 'package:sportper/app/app.dart';

import 'environment.dart';

void main(){
  Environment.setEnvironment(EnvironmentType.PROD);
  mainDelegate();
}