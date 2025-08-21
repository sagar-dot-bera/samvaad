class Validate {
  //method to validate phone number
  String? validatePhoneNumber(String? phoneNumber) {
    //regex pattern to check if phone number is valid or not
    RegExp phoneNumberPattern = RegExp('^[0-9]+\$');

    //check if length of phone number is less then 10 digit and phone number contains only digit
    if (phoneNumber != null) {
      if (!phoneNumberPattern.hasMatch(phoneNumber) && phoneNumber.isNotEmpty) {
        return "Only digit's are allowed";
      } else if (phoneNumber.isNotEmpty && phoneNumber.length < 10) {
        return "Must have 10 digits";
      } else if (phoneNumber.isEmpty) {
        return "Phone number is requried";
      } else {
        return null;
      }
    } else {
      return "phone number can'not be empty";
    }
  }

  String? checkIfFieldIsNull(String? value) {
    if (value!.isEmpty) {
      return "";
    } else {
      return null;
    }
  }

  String? isNameValidd(String? value) {
    if (value!.isEmpty) {
      return "Name is requried";
    } else {
      return null;
    }
  }
}
