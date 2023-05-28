CREATE OR REPLACE PACKAGE crud_roles_pkg IS
  PROCEDURE create_role(
    p_name IN roles.name%TYPE
  );
  
  FUNCTION read_role(p_id IN roles.id%TYPE) RETURN roles%ROWTYPE;
  
  PROCEDURE update_role(
    p_id IN roles.id%TYPE,
    p_name IN roles.name%TYPE
  );
  
  PROCEDURE delete_role(p_id IN roles.id%TYPE);
END crud_roles_pkg;
/

SELECT *
FROM SYS_ERRORS
WHERE NAME = 'CRUD_ROLES_PKG';

CREATE OR REPLACE PACKAGE BODY crud_roles_pkg IS
  PROCEDURE create_role (
    p_name IN roles.name%TYPE
  ) IS
    v_id roles.id%TYPE;
    role_count NUMBER := 0;
  BEGIN
    SELECT COUNT(*) INTO role_count FROM roles WHERE name = p_name;
    IF role_count > 0 THEN
      RAISE exception_pkg.already_exists_exception;
    END IF;

    select count(*) into v_id from roles;
    INSERT INTO roles(id, name) VALUES (v_id + 1, p_name);
  END create_role;

  FUNCTION read_role(p_id IN roles.id%TYPE) RETURN roles%ROWTYPE IS
    l_role roles%ROWTYPE;
    row_count NUMBER;
  BEGIN
    SELECT count(*) into row_count from roles where id = p_id;
    if row_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;

    SELECT * INTO l_role FROM roles WHERE id = p_id;
    RETURN l_role;
  END read_role;

  PROCEDURE update_role(
    p_id IN roles.id%TYPE,
    p_name IN roles.name%TYPE
  ) IS
    row_count NUMBER;
  BEGIN
    SELECT count(*) into row_count from roles where id = p_id;
    if row_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;

    UPDATE roles SET name = p_name WHERE id = p_id;
  END update_role;

  PROCEDURE delete_role(p_id IN roles.id%TYPE) IS
    row_count NUMBER;
  BEGIN
    SELECT count(*) into row_count from roles where id = p_id;
    if row_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;

    DELETE FROM roles WHERE id = p_id;
  END delete_role;
END crud_roles_pkg;
/


BEGIN
  crud_roles_pkg.create_role('role');

  EXCEPTION
  when exception_pkg.already_exists_exception THEN
    dbms_output.put_line('Role already exists');
END;


DECLARE
  l_role roles%ROWTYPE;
BEGIN
  l_role := crud_roles_pkg.read_role(4);

  dbms_output.put_line(l_role.id || ' ' || l_role.name);

  EXCEPTION
  when exception_pkg.record_not_found_exception THEN
    dbms_output.put_line('Role not found');
END;
/

BEGIN
  crud_roles_pkg.update_role(4, 'Updated Role');


  EXCEPTION
  when exception_pkg.record_not_found_exception THEN
    dbms_output.put_line('Role not found');
END;
/

BEGIN
  crud_roles_pkg.delete_role(4);

  EXCEPTION
  when exception_pkg.record_not_found_exception THEN
    dbms_output.put_line('Role not found');
END;