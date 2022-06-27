class CustomValidator {
  static String? email(String? value) {
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value!)) {
      return 'Email is invalid';
    }
    return null;
  }

  static String? passwordregex(String? value) {
    if (!RegExp(
            r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$")
        .hasMatch(value!)) {
      return 'Password should contain at least one upper case,one lower case, one digit,one Special character and 8 characters';
    }
    return null;
  }

  static String? password(String? value) {
    if (value!.length < 6) {
      return 'Password should be greater then 6 digits';
    }
    return null;
  }

  static String? isEmpty(String? value) {
    return (value!.isEmpty) ? 'Field could not be empty' : null;
  }

  static String? lessThen2(String? value) {
    return (value!.length < 2) ? 'Enter more then 1 characters' : null;
  }

  static String? lessThen3(String? value) {
    return (value!.length < 3) ? 'Enter more then 2 characters' : null;
  }

  static String? lessThen4(String? value) {
    return (value!.length < 4) ? 'Enter more then 3 characters' : null;
  }

  static String? lessThen5(String? value) {
    return (value!.length < 5) ? 'Enter more then 4 characters' : null;
  }

  static String? retaunNull(String? value) => null;
}
