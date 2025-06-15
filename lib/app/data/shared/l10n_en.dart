import 'l10n.dart';
class L10nEn extends L10n {
  L10nEn([super.locale = 'en']);
  @override
  String get appTitle => 'Story App';
  @override
  String get login => 'Login';
  @override
  String get register => 'Register';
  @override
  String get email => 'Email';
  @override
  String get password => 'Password';
  @override
  String get name => 'Name';
  @override
  String get confirmPassword => 'Confirm Password';
  @override
  String get loginButton => 'Login';
  @override
  String get registerButton => 'Register';
  @override
  String get dontHaveAccount => "Don't have an account?";
  @override
  String get alreadyHaveAccount => 'Already have an account?';
  @override
  String get stories => 'Stories';
  @override
  String get addStory => 'Add Story';
  @override
  String get logout => 'Logout';
  @override
  String get description => 'Description';
  @override
  String get camera => 'Camera';
  @override
  String get gallery => 'Gallery';
  @override
  String get upload => 'Upload';
  @override
  String get loading => 'Loading...';
  @override
  String get error => 'Error';
  @override
  String get noData => 'No data available';
  @override
  String get tryAgain => 'Try Again';
  @override
  String get success => 'Success';
  @override
  String get storyUploaded => 'Story uploaded successfully';
  @override
  String get pleaseSelectImage => 'Please select an image';
  @override
  String get pleaseEnterDescription => 'Please enter description';
  @override
  String get emailRequired => 'Email is required';
  @override
  String get passwordRequired => 'Password is required';
  @override
  String get nameRequired => 'Name is required';
  @override
  String get passwordMismatch => 'Passwords do not match';
  @override
  String get invalidEmail => 'Invalid email format';
  @override
  String get passwordTooShort => 'Password must be at least 8 characters';
}
