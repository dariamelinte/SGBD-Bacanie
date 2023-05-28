CREATE OR REPLACE PACKAGE crud_tranzaction_types_pkg IS
  PROCEDURE create_tranzaction_type(
    p_name IN tranzaction_types.name%TYPE
  );
  
  FUNCTION read_tranzaction_type(p_id IN tranzaction_types.id%TYPE) RETURN tranzaction_types%ROWTYPE;
  
  PROCEDURE update_tranzaction_type(
    p_id IN tranzaction_types.id%TYPE,
    p_name IN tranzaction_types.name%TYPE
  );
  
  PROCEDURE delete_tranzaction_type(p_id IN tranzaction_types.id%TYPE);
END crud_tranzaction_types_pkg;

CREATE OR REPLACE PACKAGE BODY crud_tranzaction_types_pkg IS
  PROCEDURE create_tranzaction_type (
    p_name IN tranzaction_types.name%TYPE
  ) IS
    v_id tranzaction_types.id%TYPE;
    tranzaction_type_count NUMBER := 0;
  BEGIN
    SELECT COUNT(*) INTO tranzaction_type_count FROM tranzaction_types WHERE name = p_name;
    IF tranzaction_type_count > 0 THEN
      RAISE exception_pkg.already_exists_exception;
    END IF;

    select count(*) into v_id from tranzaction_types;
    INSERT INTO tranzaction_types(id, name) VALUES (v_id + 1, p_name);
  END create_tranzaction_type;

  FUNCTION read_tranzaction_type(p_id IN tranzaction_types.id%TYPE) RETURN tranzaction_types%ROWTYPE IS
    l_tranzaction_type tranzaction_types%ROWTYPE;
    row_count NUMBER;
  BEGIN
    SELECT count(*) into row_count from tranzaction_types where id = p_id;
    if row_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;

    SELECT * INTO l_tranzaction_type FROM tranzaction_types WHERE id = p_id;
    RETURN l_tranzaction_type;
  END read_tranzaction_type;

  PROCEDURE update_tranzaction_type(
    p_id IN tranzaction_types.id%TYPE,
    p_name IN tranzaction_types.name%TYPE
  ) IS
    row_count NUMBER;
    name_count NUMBER;
  BEGIN
    SELECT count(*) into row_count from tranzaction_types where id = p_id;
    if row_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;

    SELECT count(*) into name_count from tranzaction_types where name = p_name;
    if name_count > 0 then 
      RAISE exception_pkg.already_exists_exception;
    end if;

    UPDATE tranzaction_types SET name = p_name WHERE id = p_id;
  END update_tranzaction_type;

  PROCEDURE delete_tranzaction_type(p_id IN tranzaction_types.id%TYPE) IS
    row_count NUMBER;
  BEGIN
    SELECT count(*) into row_count from tranzaction_types where id = p_id;
    if row_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;

    DELETE FROM tranzaction_types WHERE id = p_id;
  END delete_tranzaction_type;
END crud_tranzaction_types_pkg;

BEGIN
  crud_tranzaction_types_pkg.create_tranzaction_type('tranzaction_type');

  EXCEPTION
  when exception_pkg.already_exists_exception THEN
    dbms_output.put_line('tranzaction_type already exists');
END;

DECLARE
  l_tranzaction_type tranzaction_types%ROWTYPE;
BEGIN
  l_tranzaction_type := crud_tranzaction_types_pkg.read_tranzaction_type(8);

  dbms_output.put_line(l_tranzaction_type.id || ' ' || l_tranzaction_type.name);

  EXCEPTION
  when exception_pkg.record_not_found_exception THEN
    dbms_output.put_line('tranzaction_type not found');
END;

BEGIN
  crud_tranzaction_types_pkg.update_tranzaction_type(3, 'tranzaction_type jdkaw,');


  EXCEPTION
  when exception_pkg.record_not_found_exception THEN
    dbms_output.put_line('tranzaction_type not found');

  when exception_pkg.already_exists_exception THEN
    dbms_output.put_line('tranzaction_type already exists');
END;

BEGIN
  crud_tranzaction_types_pkg.delete_tranzaction_type(3);

  EXCEPTION
  when exception_pkg.record_not_found_exception THEN
    dbms_output.put_line('tranzaction_type not found');
END;