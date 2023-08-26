import 'package:hmanager/models/employee_model.dart';

UserType getUserTypeFromString(String userTypeString) {
  if (userTypeString == 'Admin') {
    return UserType.Admin;
  } else if (userTypeString == 'Cutter') {
    return UserType.Cutter;
  } else if (userTypeString == 'Finisher') {
    return UserType.Finisher;
  } else if (userTypeString == 'Tailer') {
    return UserType.Tailer;
  } else if (userTypeString == 'Accountant') {
    return UserType.Accountant;
  } else if (userTypeString == 'Sales') {
    return UserType.Sales;
  } else if (userTypeString == 'Purchaser') {
    return UserType.Purchaser;
  } else {
    return UserType.Production;
  }
}

Status getStatusFromString(String statusString) {
  if (statusString == 'Active') {
    return Status.Active;
  } else {
    return Status.Inactive;
  }
}
