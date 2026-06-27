class Validators {

  static String? validateName(String? value){

    if(value==null || value.isEmpty){
      return "Enter your name";
    }

    return null;
  }

  static String? validateEmail(String? value){

    if(value==null || value.isEmpty){
      return "Enter email";
    }

    if(!value.contains("@")){
      return "Invalid email";
    }

    return null;
  }

  static String? validatePassword(String? value){

    if(value==null || value.isEmpty){
      return "Enter password";
    }

    if(value.length<6){
      return "Password must be at least 6 characters";
    }

    return null;
  }

}
