CREATE OR REPLACE PACKAGE crud_groceries_pkg IS
  PROCEDURE create_grocery(
    p_id_user IN groceries.id_user%TYPE,
    p_name in groceries.name%TYPE,
    p_latitude in groceries.latitude%TYPE,
    p_longitude in groceries.longitude%TYPE
  );
  
  FUNCTION read_grocery(p_id IN groceries.id%TYPE) RETURN groceries%ROWTYPE;

  FUNCTION get_users_groceries(p_id_user in groceries.id_user%TYPE) RETURN groceries%ROWTYPE;
  
  PROCEDURE update_grocery(
    p_id IN groceries.id%TYPE,
    p_id_user IN groceries.id_user%TYPE,
    p_name in groceries.name%TYPE,
    p_latitude in groceries.latitude%TYPE,
    p_longitude in groceries.longitude%TYPE
  );
  
  PROCEDURE delete_grocery(p_id IN groceries.id%TYPE);
END crud_groceries_pkg;

CREATE OR REPLACE PACKAGE BODY crud_groceries_pkg IS
  PROCEDURE create_grocery(
    p_id_user IN groceries.id_user%TYPE,
    p_name in groceries.name%TYPE,
    p_latitude in groceries.latitude%TYPE,
    p_longitude in groceries.longitude%TYPE
  ) IS
    v_id groceries.id%TYPE;
    row_count NUMBER := 0;
  BEGIN
    select count(*) into row_count from users where id = p_id_user;
    if row_count = 0 THEN
      raise exception_pkg.invalid_input_exception;
    end if;

    select count(*) into row_count from groceries where name = p_name and latitude = p_latitude and longitude = p_longitude;
    if row_count > 0 THEN
      raise exception_pkg.already_exists_exception;
    end if;

    select count(*) into v_id from groceries;

    INSERT INTO groceries (
      id,
      id_user,
      name,
      latitude,
      longitude
    ) VALUES (
      v_id + 1,
      p_id_user,
      p_name,
      p_latitude,
      p_longitude
    );
  END create_grocery;
  
  FUNCTION read_grocery(p_id IN groceries.id%TYPE) RETURN groceries%ROWTYPE IS
    l_grocery groceries%ROWTYPE;
    row_count NUMBER;
  BEGIN
    SELECT count(*) into row_count from groceries where id = p_id;
    if row_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;

    SELECT * INTO l_grocery FROM groceries WHERE id = p_id;
    RETURN l_grocery;
  END read_grocery;

  FUNCTION get_users_groceries(p_id_user in groceries.id_user%TYPE) RETURN groceries%ROWTYPE IS
    l_grocery groceries%ROWTYPE;
    row_count NUMBER;
  BEGIN
    select count(*) into row_count from users where id = p_id_user;
    if row_count = 0 THEN
      raise exception_pkg.invalid_input_exception;
    end if;

    SELECT count(*) into row_count from groceries where id_user = p_id_user;
    if row_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;

    SELECT * INTO l_grocery FROM groceries WHERE id_user = p_id_user;
    RETURN l_grocery;
  END get_users_groceries;

  PROCEDURE update_grocery(
    p_id IN groceries.id%TYPE,
    p_id_user IN groceries.id_user%TYPE,
    p_name in groceries.name%TYPE,
    p_latitude in groceries.latitude%TYPE,
    p_longitude in groceries.longitude%TYPE
  ) IS
    row_count NUMBER;
  BEGIN
    SELECT count(*) into row_count from groceries where id = p_id;
    if row_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;

    SELECT count(*) into row_count from users where id = p_id_user;
    if row_count = 0 then 
      RAISE exception_pkg.invalid_input_exception;
    end if;

    SELECT count(*) into row_count from groceries where name = p_name and latitude = p_latitude and longitude = p_longitude;
    if row_count > 0 then 
      RAISE exception_pkg.already_exists_exception;
    end if;
    

    UPDATE groceries SET
      id_user = p_id_user,
      name = p_name,
      latitude = p_latitude,
      longitude = p_longitude
    WHERE id = p_id;
  END update_grocery;

  PROCEDURE delete_grocery(p_id IN groceries.id%TYPE) IS
    row_count NUMBER;
  BEGIN
    SELECT count(*) into row_count from groceries where id = p_id;
    if row_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;

    DELETE FROM groceries WHERE id = p_id;
  END delete_grocery;
END crud_groceries_pkg;

SELECT * FROM USER_ERRORS WHERE NAME = 'CRUD_GROCERIES_PKG';
