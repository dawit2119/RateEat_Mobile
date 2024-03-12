String getProperUserName({String? firstName, String? lastName}) =>
    "${firstName?.isNotEmpty == true ? firstName![0].toUpperCase() + firstName.substring(1) : ''} ${lastName?.isNotEmpty == true ? lastName![0].toUpperCase() + lastName.substring(1) : ''}"
        .trim();
