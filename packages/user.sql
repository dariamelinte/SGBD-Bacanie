CREATE OR REPLACE PACKAGE crud_users_pkg IS
  PROCEDURE create_user(
    p_first_name IN users.first_name%TYPE,
    p_last_name IN users.last_name%TYPE,
    p_email IN users.email%TYPE,
    p_phone_number IN users.phone_number%TYPE,
    p_birth_date IN users.birth_date%TYPE,
    p_hashed_password IN users.hashed_password%TYPE,
    p_jwt IN users.jwt%TYPE DEFAULT NULL
  );
  
  FUNCTION read_user(p_id IN users.id%TYPE) RETURN users%ROWTYPE;
  
  PROCEDURE update_user(
    p_id IN users.id%TYPE,
    p_first_name IN users.first_name%TYPE,
    p_last_name IN users.last_name%TYPE,
    p_email IN users.email%TYPE,
    p_phone_number IN users.phone_number%TYPE,
    p_birth_date IN users.birth_date%TYPE,
    p_hashed_password IN users.hashed_password%TYPE,
    p_jwt IN users.jwt%TYPE DEFAULT NULL
  );
  
  PROCEDURE delete_user(p_id IN users.id%TYPE);
END crud_users_pkg;

CREATE OR REPLACE PACKAGE BODY crud_users_pkg IS
  PROCEDURE create_user(
    p_first_name IN users.first_name%TYPE,
    p_last_name IN users.last_name%TYPE,
    p_email IN users.email%TYPE,
    p_phone_number IN users.phone_number%TYPE,
    p_birth_date IN users.birth_date%TYPE,
    p_hashed_password IN users.hashed_password%TYPE,
    p_jwt IN users.jwt%TYPE DEFAULT NULL
  ) IS
    v_id users.id%TYPE;
    email_count NUMBER := 0;
  BEGIN
    SELECT COUNT(*) INTO email_count FROM users WHERE email = p_email;

    IF email_count > 0 THEN
      RAISE exception_pkg.already_exists_exception;
    END IF;

    select count(*) into v_id from users;

    INSERT INTO users (
      id,
      first_name,
      last_name,
      email,
      phone_number,
      birth_date,
      hashed_password,
      jwt
    ) VALUES (
      v_id + 1,
      p_first_name,
      p_last_name,
      p_email,
      p_phone_number,
      p_birth_date,
      p_hashed_password,
      p_jwt
    );
  END create_user;
  
  FUNCTION read_user(p_id IN users.id%TYPE) RETURN users%ROWTYPE IS
    l_user users%ROWTYPE;
    row_count NUMBER;
  BEGIN
    SELECT count(*) into row_count from users where id = p_id;
    if row_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;

    SELECT * INTO l_user FROM users WHERE id = p_id;
    RETURN l_user;
  END read_user;

  PROCEDURE update_user(
    p_id IN users.id%TYPE,
    p_first_name IN users.first_name%TYPE,
    p_last_name IN users.last_name%TYPE,
    p_email IN users.email%TYPE,
    p_phone_number IN users.phone_number%TYPE,
    p_birth_date IN users.birth_date%TYPE,
    p_hashed_password IN users.hashed_password%TYPE,
    p_jwt IN users.jwt%TYPE DEFAULT NULL
  ) IS
    row_count NUMBER;
    email_count NUMBER;
  BEGIN
    SELECT count(*) into row_count from users where id = p_id;
    if row_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;

    SELECT count(*) into email_count from users where email = p_email;
    if email_count = 0 then 
      RAISE exception_pkg.already_exists_exception;
    end if;

    UPDATE users SET
        first_name = NVL(p_first_name, first_name),
        last_name = NVL(p_last_name, last_name),
        email = NVL(p_email, email),
        phone_number = NVL(p_phone_number, phone_number),
        birth_date = NVL(p_birth_date, birth_date),
        hashed_password = NVL(p_hashed_password, hashed_password),
        jwt = NVL(p_jwt, jwt)
    WHERE id = p_id;
  END update_user;

  PROCEDURE delete_user(p_id IN users.id%TYPE) IS
    row_count NUMBER;
  BEGIN
    SELECT count(*) into row_count from users where id = p_id;
    if row_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;

    DELETE FROM users WHERE id = p_id;
  END delete_user;
END crud_users_pkg;

SELECT * FROM USER_ERRORS WHERE NAME = 'CRUD_USERS_PKG';


BEGIN
  crud_users_pkg.create_user(
    'Daria Elena',
    'Melinte',
    'dariamelinte2003@gmail.com',
    '0749639919',
    TO_DATE('20-02-2003', 'DD-MM-YYYY'),
    'parolamea',
    'ceva si aici'
  );

  EXCEPTION
  when exception_pkg.already_exists_exception THEN
    dbms_output.put_line('User already exists');
END;


DECLARE
  l_user users%ROWTYPE;
BEGIN
  l_user := crud_users_pkg.read_user(4);

  dbms_output.put_line(
    l_user.id || ' ' || 
    l_user.first_name || ' ' || 
    l_user.last_name || ' ' || 
    l_user.email || ' ' || 
    l_user.phone_number || ' ' || 
    l_user.birth_date || ' ' || 
    l_user.hashed_password || ' ' || 
    l_user.jwt
  );

  EXCEPTION
  when exception_pkg.record_not_found_exception THEN
    dbms_output.put_line('User not found');
END;


BEGIN
  crud_users_pkg.update_user(
    4,
    'Daria',
    'Melinte',
    'dariamelinte2003@gmail.com',
    '0749639919',
    TO_DATE('20-02-2003', 'DD-MM-YYYY'),
    'parolamea',
    'ceva si aici'
  );

  EXCEPTION
  when exception_pkg.record_not_found_exception THEN
    dbms_output.put_line('User not found');
END;

BEGIN
  crud_users_pkg.delete_user(4);

  EXCEPTION
  when exception_pkg.record_not_found_exception THEN
    dbms_output.put_line('user not found');
END;