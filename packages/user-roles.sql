CREATE OR REPLACE PACKAGE crud_user_roles_pkg IS
  PROCEDURE create_user_role(
    p_id_role in user_roles.id_role%TYPE,
    p_id_user in user_roles.id_user%TYPE,
    p_is_confirmed in user_roles.is_confirmed%TYPE
  );
  
  FUNCTION get_user_roles(p_id_user IN user_roles.id_user%TYPE) RETURN string_varray_type;

  PROCEDURE confirm_user_role(p_id in user_roles.id%TYPE);

  PROCEDURE edit_user_role(
    p_id in user_roles.id%TYPE,
    p_id_role in user_roles.id_role%TYPE,
    p_id_user in user_roles.id_user%TYPE
  );
  
  PROCEDURE delete_user_role(p_id IN users.id%TYPE);
END crud_user_roles_pkg;

CREATE OR REPLACE PACKAGE BODY crud_user_roles_pkg IS
  PROCEDURE create_user_role (
    p_id_role in user_roles.id_role%TYPE,
    p_id_user in user_roles.id_user%TYPE,
    p_is_confirmed in user_roles.is_confirmed%TYPE
  ) IS
    v_id users.id%TYPE;
    user_count NUMBER := 0;
    role_count NUMBER := 0;
    user_role_count NUMBER := 0;
  BEGIN

    dbms_output.put_line(p_id_role || ' ' || p_id_user || ' ' || p_is_confirmed);

    select count(*) into user_count from users where id = p_id_user;
    if user_count = 0 THEN
      raise exception_pkg.invalid_input_exception;
    end if;

    select count(*) into role_count from roles where id = p_id_role;
    if role_count = 0 THEN
      raise exception_pkg.invalid_input_exception;
    end if; 

    SELECT COUNT(*) INTO user_role_count FROM user_roles WHERE id_role = p_id_role and id_user = p_id_user;
    IF user_role_count > 0 THEN
      RAISE exception_pkg.already_exists_exception;
    END IF;
    select count(*) into v_id from user_roles;

    INSERT INTO user_roles (
      id,
      id_role,
      id_user,
      is_confirmed
    ) VALUES (
      v_id + 1,
      p_id_role,
      p_id_user,
      p_is_confirmed
    );
  END create_user_role;
  
  FUNCTION get_user_roles(
    p_id_user IN user_roles.id_user%TYPE
  ) RETURN string_varray_type IS
    v_role VARCHAR2(255);
    user_count NUMBER := 0;
    roles string_varray_type;
  BEGIN
    select count(*) into user_count from users where id = p_id_user;
    if user_count = 0 THEN
      raise exception_pkg.invalid_input_exception;
    end if;

    FOR rec IN (SELECT id_role FROM user_roles WHERE id_user = p_id_user) LOOP
      select name into v_role from roles where id = rec.id_role;

      if v_role != NULL THEN
        roles.extend;
        roles(roles.last) := v_role;
      end if;
    END LOOP;

    return roles;
  END get_user_roles;
 
  PROCEDURE confirm_user_role(p_id in user_roles.id%TYPE) is
    user_role_count NUMBER := 0;
  BEGIN
    SELECT count(*) into user_role_count from user_roles where id = p_id;
    if user_role_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;
  
    UPDATE user_roles SET is_confirmed = 1 WHERE id = p_id;
  END confirm_user_role;

  PROCEDURE edit_user_role (
    p_id in user_roles.id%TYPE,
    p_id_role in user_roles.id_role%TYPE,
    p_id_user in user_roles.id_user%TYPE
  ) IS
    row_count NUMBER := 0;
  BEGIN
    select count(*) into row_count from user_roles where id_role = p_id_role and id_user = p_id_user;

    if row_count > 0 THEN
      RAISE exception_pkg.already_exists_exception;
    end if;

    UPDATE user_roles SET id_role = p_id_role, id_user = p_id_user WHERE id = p_id;
  END edit_user_role;

  PROCEDURE delete_user_role(p_id IN users.id%TYPE) IS
    row_count NUMBER;
  BEGIN
    SELECT count(*) into row_count from roles where id = p_id;
    if row_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;

    DELETE FROM roles WHERE id = p_id;
  END delete_user_role;
END crud_user_roles_pkg;


BEGIN
  crud_user_roles_pkg.create_user_role(10, 1, 0);

  EXCEPTION
  when exception_pkg.invalid_input_exception THEN
    dbms_output.put_line('User ID or Role ID are invalid');
  when exception_pkg.already_exists_exception THEN
    dbms_output.put_line('User already has this role');
END;

BEGIN
  crud_user_roles_pkg.create_user_role(1, 10, 0);

  EXCEPTION
  when exception_pkg.invalid_input_exception THEN
    dbms_output.put_line('User ID or Role ID are invalid');
  when exception_pkg.already_exists_exception THEN
    dbms_output.put_line('User already has this role');
END;

BEGIN
  crud_user_roles_pkg.create_user_role(1, 1, 0);

  EXCEPTION
  when exception_pkg.invalid_input_exception THEN
    dbms_output.put_line('User ID or Role ID are invalid');
  when exception_pkg.already_exists_exception THEN
    dbms_output.put_line('User already has this role');
END;

BEGIN
  crud_user_roles_pkg.create_user_role(1, 2, 0);

  EXCEPTION
  when exception_pkg.invalid_input_exception THEN
    dbms_output.put_line('User ID or Role ID are invalid');
  when exception_pkg.already_exists_exception THEN
    dbms_output.put_line('User already has this role');
  WHEN OTHERS THEN
      dbms_output.put_line('An error occurred: ' || SQLERRM);
END;

BEGIN
  crud_user_roles_pkg.create_user_role(1, 3, 0);

  EXCEPTION
  when exception_pkg.invalid_input_exception THEN
    dbms_output.put_line('User ID or Role ID are invalid');
  when exception_pkg.already_exists_exception THEN
    dbms_output.put_line('User already has this role');
END;
