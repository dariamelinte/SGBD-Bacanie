CREATE OR REPLACE PACKAGE roles_pkg IS
  duplicate_role_exception EXCEPTION;
  role_not_found_exception EXCEPTION;

  PROCEDURE create_role(
    p_name IN VARCHAR2
  );

  FUNCTION get_role(p_id IN NUMBER) RETURN roles%ROWTYPE;

  PROCEDURE update_role(
    p_id IN NUMBER,
    p_name IN VARCHAR2
  );

  PROCEDURE delete_role(p_id IN NUMBER);

END roles_pkg;
/

CREATE OR REPLACE PACKAGE BODY roles_pkg IS
  duplicate_role_exception EXCEPTION;
  PRAGMA EXCEPTION_INIT(duplicate_role_exception, -20001);

  role_not_found_exception EXCEPTION;
  PRAGMA EXCEPTION_INIT(role_not_found_exception, -20002);

  PROCEDURE create_role(
    p_name IN VARCHAR2
  ) IS
    v_id INT
  BEGIN
    select count(*) into v_id from roles;
    INSERT INTO roles (id, name)
    VALUES (v_id, p_name);
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001, 'Role already exists.');
  END create_role;

  FUNCTION get_role(p_id IN NUMBER) RETURN roles%ROWTYPE IS
    role roles%ROWTYPE;
  BEGIN
    SELECT *
    INTO role
    FROM roles
    WHERE id = p_id;

    RETURN role;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20002, 'Role not found.');
  END get_role;

  PROCEDURE update_role(
    p_id IN NUMBER,
    p_name IN VARCHAR2
  ) IS
  BEGIN
    UPDATE roles
    SET name = p_name
    WHERE id = p_id;

    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20002, 'Role not found.');
    END IF;
  END update_role;

  PROCEDURE delete_role(p_id IN NUMBER) IS
  BEGIN
    DELETE FROM roles
    WHERE id = p_id;

    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20002, 'Role not found.');
    END IF;
  END delete_role;

END roles_pkg;
/
