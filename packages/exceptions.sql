CREATE OR REPLACE PACKAGE exception_pkg IS
  invalid_input_exception EXCEPTION;
  invalid_operation_exception EXCEPTION;
  record_not_found_exception EXCEPTION;
  already_exists_exception EXCEPTION;

  c_invalid_input_code CONSTANT NUMBER := -20001;
  c_invalid_operation_code CONSTANT NUMBER := -20002;
  c_record_not_found_code CONSTANT NUMBER := -20003;
  c_already_exist_code CONSTANT NUMBER := -20004;

  c_invalid_input_message CONSTANT VARCHAR2(255) := 'Invalid input.';
  c_invalid_operation_message CONSTANT VARCHAR2(255) := 'Invalid operation.';
  c_record_not_found_message CONSTANT VARCHAR2(255) := 'Record not found.';
  c_already_exists_message CONSTANT VARCHAR2(255) := 'Already exists.';

  FUNCTION get_exception_message(p_exception IN EXCEPTION) RETURN VARCHAR2;
END exception_pkg;
/

CREATE OR REPLACE PACKAGE BODY exception_pkg IS

  FUNCTION get_exception_message(p_exception IN EXCEPTION) RETURN VARCHAR2 IS
  BEGIN
    IF p_exception = invalid_input_exception THEN
      RETURN c_invalid_input_message;
    ELSIF p_exception = invalid_operation_exception THEN
      RETURN c_invalid_operation_message;
    ELSIF p_exception = record_not_found_exception THEN
      RETURN c_record_not_found_message;
    ELSIF p_exception = already_exists_exception THEN
      RETURN c_already_exists_message;
    ELSE
      RETURN SQLERRM;
    END IF;
  END get_exception_message;

END exception_pkg;
/
