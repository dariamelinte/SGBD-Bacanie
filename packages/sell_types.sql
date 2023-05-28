CREATE OR REPLACE PACKAGE crud_sell_types_pkg IS
  PROCEDURE create_sell_type(
    p_name IN sell_types.name%TYPE
  );
  
  FUNCTION read_sell_type(p_id IN sell_types.id%TYPE) RETURN sell_types%ROWTYPE;
  
  PROCEDURE update_sell_type(
    p_id IN sell_types.id%TYPE,
    p_name IN sell_types.name%TYPE
  );
  
  PROCEDURE delete_sell_type(p_id IN sell_types.id%TYPE);
END crud_sell_types_pkg;

CREATE OR REPLACE PACKAGE BODY crud_sell_types_pkg IS
  PROCEDURE create_sell_type (
    p_name IN sell_types.name%TYPE
  ) IS
    v_id sell_types.id%TYPE;
    sell_type_count NUMBER := 0;
  BEGIN
    SELECT COUNT(*) INTO sell_type_count FROM sell_types WHERE name = p_name;
    IF sell_type_count > 0 THEN
      RAISE exception_pkg.already_exists_exception;
    END IF;

    select count(*) into v_id from sell_types;
    INSERT INTO sell_types(id, name) VALUES (v_id + 1, p_name);
  END create_sell_type;

  FUNCTION read_sell_type(p_id IN sell_types.id%TYPE) RETURN sell_types%ROWTYPE IS
    l_sell_type sell_types%ROWTYPE;
    row_count NUMBER;
  BEGIN
    SELECT count(*) into row_count from sell_types where id = p_id;
    if row_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;

    SELECT * INTO l_sell_type FROM sell_types WHERE id = p_id;
    RETURN l_sell_type;
  END read_sell_type;

  PROCEDURE update_sell_type(
    p_id IN sell_types.id%TYPE,
    p_name IN sell_types.name%TYPE
  ) IS
    row_count NUMBER;
    name_count NUMBER;
  BEGIN
    SELECT count(*) into row_count from sell_types where id = p_id;
    if row_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;

    SELECT count(*) into name_count from sell_types where name = p_name;
    if name_count > 0 then 
      RAISE exception_pkg.already_exists_exception;
    end if;

    UPDATE sell_types SET name = p_name WHERE id = p_id;
  END update_sell_type;

  PROCEDURE delete_sell_type(p_id IN sell_types.id%TYPE) IS
    row_count NUMBER;
  BEGIN
    SELECT count(*) into row_count from sell_types where id = p_id;
    if row_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;

    DELETE FROM sell_types WHERE id = p_id;
  END delete_sell_type;
END crud_sell_types_pkg;

BEGIN
  crud_sell_types_pkg.create_sell_type('sell_type');

  EXCEPTION
  when exception_pkg.already_exists_exception THEN
    dbms_output.put_line('sell_type already exists');
END;

DECLARE
  l_sell_type sell_types%ROWTYPE;
BEGIN
  l_sell_type := crud_sell_types_pkg.read_sell_type(2);

  dbms_output.put_line(l_sell_type.id || ' ' || l_sell_type.name);

  EXCEPTION
  when exception_pkg.record_not_found_exception THEN
    dbms_output.put_line('sell_type not found');
END;

BEGIN
  crud_sell_types_pkg.update_sell_type(3, 'sell_type');


  EXCEPTION
  when exception_pkg.record_not_found_exception THEN
    dbms_output.put_line('sell_type not found');

  when exception_pkg.already_exists_exception THEN
    dbms_output.put_line('sell_type already exists');
END;

BEGIN
  crud_sell_types_pkg.delete_sell_type(3);

  EXCEPTION
  when exception_pkg.record_not_found_exception THEN
    dbms_output.put_line('sell_type not found');
END;