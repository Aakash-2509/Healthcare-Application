// validation.dart

import '../global/app_string.dart';

class Validators {
  // String? validateFirstName(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return "Enter your full name";
  //   }
  //   return null;
  // }

  String? validateFirstName(String? value) {
    final RegExp nameRegExp = RegExp(r'^[a-zA-Z\s]+$');

    if (value == null || value.isEmpty) {
      return "Enter your first name";
    } else if (!nameRegExp.hasMatch(value)) {
      return "Name can only contain alphabets and spaces";
    } else if (value.trim().isEmpty) {
      return "Name can not contain only spaces";
    }

    return null;
  }

  String? validateLastName(String? value) {
    final RegExp nameRegExp = RegExp(r'^[a-zA-Z\s]+$');

    if (value == null || value.isEmpty) {
      return "Enter your last name";
    } else if (!nameRegExp.hasMatch(value)) {
      return "Name can only contain alphabets and spaces";
    } else if (value.trim().isEmpty) {
      return "Name can not contain only spaces";
    }

    return null;
  }

  String? validatelastName(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter your full name";
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter valid email address";
    }
    const emailPattern = r'^[^@]+@[^@]+\.[^@]+';
    if (!RegExp(emailPattern).hasMatch(value)) {
      return "Enter correct email Id";
    }
    return null;
  }

  String? validateWebsite(String? value) {
    final RegExp urlRegExp = RegExp(
        r"^(https?:\/\/)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(\/[a-zA-Z0-9-._~:\/?#@!$&\'()*+,;=]*)?$");

    if (value == null || value.isEmpty) {
      return "Enter your website URL";
    } else if (!urlRegExp.hasMatch(value)) {
      return "Enter a valid website URL";
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter your password";
    } else if (value.length < 6) {
      return "Password should more than 6 letter";
    } else if (value.trim().isEmpty) {
      return "Password can not contain only spaces";
    }
    return null;
  }

  // String? validatePhoneNumber(String? value) {
  //   if (value == 10 || value!.isNotEmpty) {
  //     return null;
  //   }
  //   // Add phone number format validation logic here if needed
  //   return "Enter mobile Number";
  // }

  String? validatePhoneNumber(String? value) {
    // Check if value is not null and contains exactly 10 digits
    if (value != null && RegExp(r'^\d{10}$').hasMatch(value)) {
      return null;
    }
    return "Enter a valid 10-digit mobile number";
  }

  String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Please enter a name';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
      return 'Name contains invalid symbols';
    }
    return null;
  }

  String? validateKeyName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Please enter key name';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
      return 'Key Name contains invalid symbols';
    }
    return null;
  }

  String? validateDescription(String? description) {
    if (description == null || description.isEmpty) {
      return 'Please enter a description';
    }
    // if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(description)) {
    //   return 'Description contains invalid symbols';
    // }
    return null;
  }

  String? addressValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your address';
    }
    if (value.trim().isEmpty) {
      return 'Address cannot contain only spaces';
    }
    return null;
  }

  String? specialityValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your speciality in one word';
    }
    if (value.trim().isEmpty) {
      return 'Speciality cannot contain only spaces';
    }
    if (RegExp(r'[0-9]').hasMatch(value)) {
      return 'Speciality cannot contain numbers';
    }
    return null;
  }

  String? hospitalValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your hospital names';
    }
    if (value.trim().isEmpty) {
      return 'Hospital cannot contain only spaces';
    }
    if (RegExp(r'[0-9]').hasMatch(value)) {
      return 'Hospital cannot contain numbers';
    }
    return null;
  }

  String? pincodeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your pincode';
    }
    if (value.trim().isEmpty) {
      return 'Pincode cannot contain only spaces';
    }
    if (value.length != 6) {
      return 'Pincode must be exactly 6 digits long';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Pincode must contain only digits';
    }
    return null;
  }

  String? timingValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a time';
    }
    if (value.trim().isEmpty) {
      return 'Time cannot contain only spaces';
    }
    // Regex to match HH:MM format
    if (!RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$').hasMatch(value)) {
      return 'Time must be in HH:MM format';
    }
    return null;
  }

  //  String? validateDateOfBirth(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please enter your date of birth';
  //   }

  //   // Basic date format validation (YYYY-MM-DD)
  //   final RegExp dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
  //   if (!dateRegex.hasMatch(value)) {
  //     return null;
  //   }

  //   DateTime dob;
  //   try {
  //     dob = DateTime.parse(value);
  //   } catch (e) {
  //     return null;
  //   }

  //   final DateTime now = DateTime.now();
  //   final int age = now.year - dob.year;
  //   if (age < 18) {
  //     return Appstring.below18;
  //   }

  //   return null; // Return null if validation passes
  // }

  //  String? validatePinCode(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return Appstring.pincodevalidation;
  //   }

  //   // Basic pin code format validation (6 digits)
  //   final RegExp pinCodeRegex = RegExp(r'^\d{6}$');
  //   if (!pinCodeRegex.hasMatch(value)) {
  //     return Appstring.pincoderequired;
  //   }

  //   return null; // Return null if validation passes
  // }
}
