import 'package:formz/formz.dart';

enum UserInputFormError {
  tooShort,
  tooLong,
}

class UserInputForm extends FormzInput<String, UserInputFormError> {
  const UserInputForm.pure() : super.pure('');

  const UserInputForm.dirty([super.value = '']) : super.dirty();
  @override
  UserInputFormError? validator(String value) {
    if (value.trim().length < 250) {
      return UserInputFormError.tooShort;
    }
    if (value.trim().length > 3000) {
      return UserInputFormError.tooLong;
    }
    return null;
  }
}
