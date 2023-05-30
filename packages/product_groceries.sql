CREATE OR REPLACE PACKAGE crud_product_groceries_pkg IS
  TYPE pg_varray_type IS VARRAY(99) OF product_groceries%ROWTYPE;
  PROCEDURE create_product_grocery(
    p_id_grocery in product_groceries.id_grocery%TYPE,
    p_id_product in product_groceries.id_product%TYPE,
    p_id_sell_type in product_groceries.id_sell_type%TYPE
  );
  
  FUNCTION get_by_id(p_id IN product_groceries.id%TYPE) RETURN product_groceries%ROWTYPE;
  FUNCTION get_by_id_grocery(p_id_grocery IN product_groceries.id_grocery%TYPE) RETURN pg_varray_type;
  FUNCTION get_by_id_product(p_id_product IN product_groceries.id_product%TYPE) RETURN pg_varray_type;

  PROCEDURE edit_product_grocery(
    p_id in product_groceries.id%TYPE,
    p_id_grocery in product_groceries.id_grocery%TYPE,
    p_id_product in product_groceries.id_product%TYPE,
    p_id_sell_type in product_groceries.id_sell_type%TYPE
  );
  
  PROCEDURE delete_product_grocery(p_id IN products.id%TYPE);
END crud_product_groceries_pkg;

CREATE OR REPLACE PACKAGE BODY crud_product_groceries_pkg IS
  PROCEDURE create_product_grocery (
    p_id_grocery in product_groceries.id_grocery%TYPE,
    p_id_product in product_groceries.id_product%TYPE,
    p_id_sell_type in product_groceries.id_sell_type%TYPE
  ) IS
    v_id products.id%TYPE;
    row_count NUMBER := 0;
  BEGIN
    select count(*) into row_count from products where id = p_id_product;
    if row_count = 0 THEN
      raise exception_pkg.invalid_input_exception;
    end if;

    select count(*) into row_count from groceries where id = p_id_grocery;
    if row_count = 0 THEN
      raise exception_pkg.invalid_input_exception;
    end if; 

    select count(*) into row_count from sell_types where id = p_id_sell_type;
    if row_count = 0 THEN
      raise exception_pkg.invalid_input_exception;
    end if; 

    SELECT COUNT(*) INTO row_count FROM product_groceries WHERE id_grocery = p_id_grocery and id_product = p_id_product;
    IF row_count > 0 THEN
      RAISE exception_pkg.already_exists_exception;
    END IF;

    select count(*) into v_id from product_groceries;

    INSERT INTO product_groceries (
      id,
      id_grocery,
      id_product,
      id_sell_type
    ) VALUES (
      v_id + 1,
      p_id_grocery,
      p_id_product,
      p_id_sell_type
    );
  END create_product_grocery;
  
  FUNCTION get_by_id(
    p_id IN product_groceries.id%TYPE
  ) RETURN product_groceries%ROWTYPE IS
    v_row product_groceries%ROWTYPE;
    row_count NUMBER := 0;
  BEGIN
    select count(*) into row_count from product_groceries where id = p_id;
    if row_count = 0 THEN
      raise exception_pkg.record_not_found_exception;
    end if;

    SELECT * INTO v_row FROM product_groceries WHERE id = p_id;
    RETURN v_row;
  END get_by_id;
  
  FUNCTION get_by_id_grocery(
    p_id_grocery IN product_groceries.id_grocery%TYPE
  ) RETURN pg_varray_type IS
    v_rows pg_varray_type;
    rec product_groceries%ROWTYPE;
    row_count NUMBER := 0;
  BEGIN
    select count(*) into row_count from groceries where id = p_id_grocery;
    if row_count = 0 THEN
      raise exception_pkg.invalid_input_exception;
    end if;

    select count(*) into row_count from product_groceries where id_grocery = p_id_grocery;
    if row_count = 0 THEN
      raise exception_pkg.record_not_found_exception;
    end if;

    FOR rec IN (SELECT * FROM product_groceries WHERE id_grocery = p_id_grocery) LOOP
      v_rows.extend;
      v_rows(v_rows.last) := rec;
    END LOOP;
    return v_rows;
  END get_by_id_grocery;
   
  FUNCTION get_by_id_product(
    p_id_product IN product_groceries.id_product%TYPE
  ) RETURN pg_varray_type IS
    v_rows pg_varray_type;
    rec product_groceries%ROWTYPE;
    row_count NUMBER := 0;
  BEGIN
    select count(*) into row_count from products where id = p_id_product;
    if row_count = 0 THEN
      raise exception_pkg.invalid_input_exception;
    end if;

    select count(*) into row_count from product_groceries where id_product = p_id_product;
    if row_count = 0 THEN
      raise exception_pkg.record_not_found_exception;
    end if;

    FOR rec IN (SELECT * FROM product_groceries WHERE id_product = p_id_product) LOOP
      v_rows.extend;
      v_rows(v_rows.last) := rec;
    END LOOP;
    return v_rows;
  END get_by_id_product;

  PROCEDURE edit_product_grocery (
    p_id in product_groceries.id%TYPE,
    p_id_grocery in product_groceries.id_grocery%TYPE,
    p_id_product in product_groceries.id_product%TYPE,
    p_id_sell_type in product_groceries.id_sell_type%TYPE
  ) IS
    row_count NUMBER := 0;
  BEGIN
    select count(*) into row_count from product_groceries where id = p_id;
    if row_count = 0 THEN
      raise exception_pkg.record_not_found_exception;
    end if;

    select count(*) into row_count from groceries where id = p_id_grocery;
    if row_count = 0 THEN
      raise exception_pkg.invalid_input_exception;
    end if;

    select count(*) into row_count from products where id = p_id_product;
    if row_count = 0 THEN
      raise exception_pkg.invalid_input_exception;
    end if;

    SELECT count(*) into row_count from sell_types where id = p_id_sell_type;
    if row_count = 0 then 
      RAISE exception_pkg.invalid_input_exception;
    end if;

    SELECT count(*) into row_count from product_groceries where id_product = p_id_product and id_grocery = p_id_grocery and id_sell_type = p_id_sell_type;
    if row_count > 0 then 
      RAISE exception_pkg.already_exists_exception;
    end if;
  
    UPDATE product_groceries SET id_grocery = p_id_grocery, id_product = p_id_product WHERE id = p_id;
  END edit_product_grocery;

  PROCEDURE delete_product_grocery(p_id IN products.id%TYPE) IS
    row_count NUMBER;
  BEGIN
    SELECT count(*) into row_count from product_groceries where id = p_id;
    if row_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;

    DELETE FROM product_groceries WHERE id = p_id;
  END delete_product_grocery;
END crud_product_groceries_pkg;

SELECT * FROM USER_ERRORS WHERE NAME = 'CRUD_PRODUCT_GROCERIES_PKG';
