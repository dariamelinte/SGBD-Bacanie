CREATE OR REPLACE PACKAGE exception_pkg  IS
  invalid_input_exception EXCEPTION;
  invalid_operation_exception EXCEPTION;
  record_not_found_exception EXCEPTION;
  already_exists_exception EXCEPTION;
  
  PRAGMA EXCEPTION_INIT(invalid_input_exception, -20001);
  PRAGMA EXCEPTION_INIT(invalid_operation_exception, -20002);
  PRAGMA EXCEPTION_INIT(record_not_found_exception, -20003);
  PRAGMA EXCEPTION_INIT(already_exists_exception, -20004);
END  exception_pkg;
/
