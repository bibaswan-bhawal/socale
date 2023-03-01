import 'package:socale/navigation/main/main_route_path.dart';

class OnboardingRoutePath extends AppRoutePath {
  final int pageNumber;

  OnboardingRoutePath.introOnePage() : pageNumber = 0;
  OnboardingRoutePath.introTwoPage() : pageNumber = 1;
  OnboardingRoutePath.introThreePage() : pageNumber = 2;
  OnboardingRoutePath.basicInfoPage() : pageNumber = 3;
  OnboardingRoutePath.academicInfoPage() : pageNumber = 4;
}
