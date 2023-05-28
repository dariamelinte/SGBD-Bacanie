CREATE OR REPLACE PACKAGE crud_categories_pkg IS
  PROCEDURE create_category(
    p_name IN categories.name%TYPE
  );
  
  FUNCTION read_category(p_id IN categories.id%TYPE) RETURN categories%ROWTYPE;
  
  PROCEDURE update_category(
    p_id IN categories.id%TYPE,
    p_name IN categories.name%TYPE
  );
  
  PROCEDURE delete_category(p_id IN categories.id%TYPE);
END crud_categories_pkg;

CREATE OR REPLACE PACKAGE BODY crud_categories_pkg IS
  PROCEDURE create_category (
    p_name IN categories.name%TYPE
  ) IS
    v_id categories.id%TYPE;
    category_count NUMBER := 0;
  BEGIN
    SELECT COUNT(*) INTO category_count FROM categories WHERE name = p_name;
    IF category_count > 0 THEN
      RAISE exception_pkg.already_exists_exception;
    END IF;

    select count(*) into v_id from categories;
    INSERT INTO categories(id, name) VALUES (v_id + 1, p_name);
  END create_category;

  FUNCTION read_category(p_id IN categories.id%TYPE) RETURN categories%ROWTYPE IS
    l_category categories%ROWTYPE;
    row_count NUMBER;
  BEGIN
    SELECT count(*) into row_count from categories where id = p_id;
    if row_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;

    SELECT * INTO l_category FROM categories WHERE id = p_id;
    RETURN l_category;
  END read_category;

  PROCEDURE update_category(
    p_id IN categories.id%TYPE,
    p_name IN categories.name%TYPE
  ) IS
    row_count NUMBER;
  BEGIN
    SELECT count(*) into row_count from categories where id = p_id;
    if row_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;

    SELECT count(*) into row_count from categories where name = p_name;
    if row_count > 0 then 
      RAISE exception_pkg.already_exists_exception;
    end if;

    UPDATE categories SET name = p_name WHERE id = p_id;
  END update_category;

  PROCEDURE delete_category(p_id IN categories.id%TYPE) IS
    row_count NUMBER;
  BEGIN
    SELECT count(*) into row_count from categories where id = p_id;
    if row_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;

    DELETE FROM categories WHERE id = p_id;
  END delete_category;
END crud_categories_pkg;

BEGIN
  crud_categories_pkg.create_category('category');

  EXCEPTION
  when exception_pkg.already_exists_exception THEN
    dbms_output.put_line('Category already exists');
END;

DECLARE
  l_category categories%ROWTYPE;
BEGIN
  l_category := crud_categories_pkg.read_category(10);

  dbms_output.put_line(l_category.id || ' ' || l_category.name);

  EXCEPTION
  when exception_pkg.record_not_found_exception THEN
    dbms_output.put_line('Category not found');
END;

BEGIN
  crud_categories_pkg.update_category(4, 'food');

  EXCEPTION
  when exception_pkg.already_exists_exception THEN
    dbms_output.put_line('Category already exists');
END;

BEGIN
  crud_categories_pkg.update_category(5, 'Updated category');

  EXCEPTION
  when exception_pkg.record_not_found_exception THEN
    dbms_output.put_line('Category not found');
END;

BEGIN
  crud_categories_pkg.delete_category(5);

  EXCEPTION
  when exception_pkg.record_not_found_exception THEN
    dbms_output.put_line('Category not found');
END;