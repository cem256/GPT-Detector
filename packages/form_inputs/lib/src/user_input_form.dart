import 'package:formz/formz.dart';

enum UserInputFormError {
  invalidInput,
}

class UserInputForm extends FormzInput<String, UserInputFormError> {
  const UserInputForm.pure() : super.pure('');

  const UserInputForm.dirty([super.value = '']) : super.dirty();
  @override
  UserInputFormError? validator(String value) {
    if (value.trim().length < 200) {
      return UserInputFormError.invalidInput;
    }
    return null;
  }
}
