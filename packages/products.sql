CREATE OR REPLACE PACKAGE crud_products_pkg IS
  PROCEDURE create_product(
    p_name IN products.name%TYPE,
    p_description IN PRODUCTS.DESCRIPTION%TYPE
  );
  
  FUNCTION read_product(p_id IN products.id%TYPE) RETURN products%ROWTYPE;

  FUNCTION get_product_by_name(p_name in PRODUCTS.NAME%TYPE) RETURN products%ROWTYPE;
  
  PROCEDURE update_product(
    p_id IN products.id%TYPE,
    p_name IN products.name%TYPE,
    p_description IN PRODUCTS.DESCRIPTION%TYPE
  );
  
  PROCEDURE delete_product(p_id IN products.id%TYPE);
END crud_products_pkg;

CREATE OR REPLACE PACKAGE BODY crud_products_pkg IS
  PROCEDURE create_product (
    p_name IN products.name%TYPE,
    p_description IN PRODUCTS.DESCRIPTION%TYPE
  ) IS
    v_id products.id%TYPE;
    product_count NUMBER := 0;
  BEGIN
    SELECT COUNT(*) INTO product_count FROM PRODUCTS WHERE NAME = p_name and DESCRIPTION = p_description;
    IF product_count > 0 THEN
      RAISE exception_pkg.already_exists_exception;
    END IF;

    select count(*) into v_id from products;
    INSERT INTO products(ID, NAME, DESCRIPTION) VALUES (v_id + 1, p_name, p_description);
  END create_product;

  FUNCTION read_product(p_id IN products.id%TYPE) RETURN products%ROWTYPE IS
    l_product products%ROWTYPE;
    row_count NUMBER;
  BEGIN
    SELECT count(*) into row_count from products where id = p_id;
    if row_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;

    SELECT * INTO l_product FROM products WHERE id = p_id;
    RETURN l_product;
  END read_product;

  FUNCTION get_product_by_name(p_name in PRODUCTS.NAME%TYPE) RETURN products%ROWTYPE IS
    l_product products%ROWTYPE;
    row_count NUMBER;
  BEGIN
    SELECT count(*) into row_count from products where name = p_name;
    if row_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;

    SELECT * INTO l_product FROM products WHERE name = p_name;
    RETURN l_product;
  END;

  PROCEDURE update_product(
    p_id IN products.id%TYPE,
    p_name IN products.name%TYPE,
    p_description IN PRODUCTS.DESCRIPTION%TYPE
  ) IS
    row_count NUMBER;
  BEGIN
    SELECT count(*) into row_count from products where id = p_id;
    if row_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;
    
    SELECT count(*) into row_count from products where name = p_name and description = p_description;
    if row_count > 0 then 
      RAISE exception_pkg.already_exists_exception;
    end if;

    UPDATE products SET name = p_name, description = p_description WHERE id = p_id;
  END update_product;

  PROCEDURE delete_product(p_id IN products.id%TYPE) IS
    row_count NUMBER;
  BEGIN
    SELECT count(*) into row_count from products where id = p_id;
    if row_count = 0 then 
      RAISE exception_pkg.record_not_found_exception;
    end if;

    DELETE FROM products WHERE id = p_id;
  END delete_product;
END crud_products_pkg;

BEGIN
  crud_products_pkg.create_product('eggs', 'some description');

  EXCEPTION
  when exception_pkg.already_exists_exception THEN
    dbms_output.put_line('product already exists');
END;

DECLARE
  l_product products%ROWTYPE;
BEGIN
  l_product := crud_products_pkg.get_product_by_name('products');

  dbms_output.put_line(l_product.id || ' ' || l_product.name || ' ' || l_product.description);

  EXCEPTION
  when exception_pkg.record_not_found_exception THEN
    dbms_output.put_line('product not found');
  WHEN exception_pkg.already_exists_exception THEN
    dbms_output.put_line('product already exists');
  
END;

DECLARE
  l_product products%ROWTYPE;
BEGIN
  l_product := crud_products_pkg.read_product(10);

  dbms_output.put_line(l_product.id || ' ' || l_product.name);

  EXCEPTION
  when exception_pkg.record_not_found_exception THEN
    dbms_output.put_line('product not found');
END;

BEGIN
  crud_products_pkg.update_product(1, 'eggs', 'some description');

  EXCEPTION
  when exception_pkg.record_not_found_exception THEN
    dbms_output.put_line('product not found');
  WHEN exception_pkg.already_exists_exception THEN
    dbms_output.put_line('product already exists');
END;

BEGIN
  crud_products_pkg.delete_product(3);

  EXCEPTION
  when exception_pkg.record_not_found_exception THEN
    dbms_output.put_line('product not found');
END;