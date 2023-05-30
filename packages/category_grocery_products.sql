CREATE OR REPLACE PACKAGE crud_cat_grocery_products_pkg IS
  TYPE cgp_varray_type IS VARRAY(99) OF category_grocery_products%ROWTYPE;
  PROCEDURE create_cgp(
    p_id_product_grocery in category_grocery_products.id_product_grocery%TYPE,
    p_id_category in category_grocery_products.id_category%TYPE
  );
  
  FUNCTION get_by_id(p_id IN category_grocery_products.id%TYPE) RETURN category_grocery_products%ROWTYPE;
  FUNCTION get_by_id_product_grocery(p_id_product_grocery in category_grocery_products.id_product_grocery%TYPE) RETURN cgp_varray_type;
  FUNCTION get_by_id_category(p_id_category in category_grocery_products.id_category%TYPE) RETURN cgp_varray_type;

  PROCEDURE edit_cgp(
    p_id in category_grocery_products.id%TYPE,
    p_id_product_grocery in category_grocery_products.id_product_grocery%TYPE,
    p_id_category in category_grocery_products.id_category%TYPE
  );
  
  PROCEDURE delete_cgp(p_id IN products.id%TYPE);
END crud_cat_grocery_products_pkg;

CREATE OR REPLACE PACKAGE BODY crud_cat_grocery_products_pkg IS
  PROCEDURE create_cgp (
    p_id_product_grocery in category_grocery_products.id_product_grocery%TYPE,
    p_id_category in category_grocery_products.id_category%TYPE
  ) IS
    v_id category_grocery_products.id%TYPE;
    row_count NUMBER := 0;
  BEGIN
    select count(*) into row_count from product_groceries where id = p_id_product_grocery;
    if row_count = 0 THEN
      raise exception_pkg.invalid_input_exception;
    end if;

    select count(*) into row_count from categories where id = p_id_category;
    if row_count = 0 THEN
      raise exception_pkg.invalid_input_exception;
    end if;

    select count(*) into v_id from category_grocery_products;

    INSERT INTO category_grocery_products (
      id,
      id_product_grocery,
      id_category
    ) VALUES (
      v_id + 1,
      p_id_product_grocery,
      p_id_category
    );
  END create_cgp;
  
  FUNCTION get_by_id(
    p_id IN category_grocery_products.id%TYPE
  ) RETURN category_grocery_products%ROWTYPE IS
    v_row category_grocery_products%ROWTYPE;
    row_count NUMBER := 0;
  BEGIN
    select count(*) into row_count from category_grocery_products where id = p_id;
    if row_count = 0 THEN
      raise exception_pkg.record_not_found_exception;
    end if;

    SELECT * INTO v_row FROM category_grocery_products WHERE id = p_id;
    RETURN v_row;
  END get_by_id;
  
  FUNCTION get_by_id_product_grocery(
    p_id_product_grocery in category_grocery_products.id_product_grocery%TYPE
  ) RETURN cgp_varray_type IS
    v_rows cgp_varray_type;
    rec category_grocery_products%ROWTYPE;
    row_count NUMBER := 0;
  BEGIN
    select count(*) into row_count from product_groceries where id = p_id_product_grocery;
    if row_count = 0 THEN
      raise exception_pkg.invalid_input_exception;
    end if;

    select count(*) into row_count from category_grocery_products where id_product_grocery = p_id_product_grocery;
    if row_count = 0 THEN
      raise exception_pkg.record_not_found_exception;
    end if;

    FOR rec IN (select * from category_grocery_products where id_product_grocery = p_id_product_grocery) LOOP
      v_rows.extend;
      v_rows(v_rows.last) := rec;
    END LOOP;
    return v_rows;
  END get_by_id_product_grocery;
   
  FUNCTION get_by_id_category(
    p_id_category in category_grocery_products.id_category%TYPE
  ) RETURN cgp_varray_type IS
    v_rows cgp_varray_type;
    rec category_grocery_products%ROWTYPE;
    row_count NUMBER := 0;
  BEGIN
    select count(*) into row_count from categories where id = p_id_category;
    if row_count = 0 THEN
      raise exception_pkg.invalid_input_exception;
    end if;

    select count(*) into row_count from category_grocery_products where id_category = p_id_category;
    if row_count = 0 THEN
      raise exception_pkg.record_not_found_exception;
    end if;

    FOR rec IN (SELECT * FROM category_grocery_products WHERE id_category = p_id_category) LOOP
      v_rows.extend;
      v_rows(v_rows.last) := rec;
    END LOOP;
    return v_rows;
  END get_by_id_category;

  PROCEDURE edit_cgp (
    p_id in category_grocery_products.id%TYPE,
    p_id_product_grocery in category_grocery_products.id_product_grocery%TYPE,
    p_id_category in category_grocery_products.id_category%TYPE
  ) IS
    row_count NUMBER := 0;
  BEGIN
    select count(*) into row_count from category_grocery_products where id = p_id;
    if row_count = 0 THEN
      raise exception_pkg.record_not_found_exception;
    end if;

    select count(*) into row_count from product_groceries where id = p_id_product_grocery;
    if row_count = 0 THEN
      raise exception_pkg.invalid_input_exception;
    end if;

    select count(*) into row_count from categories where id = p_id_category;
    if row_count = 0 THEN
      raise exception_pkg.invalid_input_exception;
    end if;

    SELECT count(*) into row_count from category_grocery_products where id_product_grocery = p_id_product_grocery and id_category = p_id_category;
    if row_count > 0 then 
      RAISE exception_pkg.already_exists_exception;
    end if;
  
    UPDATE category_grocery_products SET id_product_grocery = p_id_product_grocery, id_category = p_id_category WHERE id = p_id;
  END edit_cgp;

  PROCEDURE delete_cgp(p_id IN products.id%TYPE) IS
    row_count NUMBER;
  BEGIN
    SELECT count(*) into row_count from category_grocery_products where id = p_id;
    if row_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;

    DELETE FROM category_grocery_products WHERE id = p_id;
  END delete_cgp;
END crud_cat_grocery_products_pkg;

SELECT * FROM USER_ERRORS WHERE NAME = 'CRUD_CAT_GROCERY_PRODUCTS_PKG';
