DROP TABLE categories CASCADE CONSTRAINTS;
DROP TABLE products CASCADE CONSTRAINTS;
DROP TABLE product_categories CASCADE CONSTRAINTS;

CREATE TABLE categories (
  id INT NOT NULL PRIMARY KEY,
  name VARCHAR2(255) NOT NULL,
  CONSTRAINT no_duplicates_categories UNIQUE (name)
);

CREATE TABLE products (
  id INT NOT NULL PRIMARY KEY,
  name VARCHAR2(255) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  CONSTRAINT no_duplicates_products UNIQUE (name)
);


INSERT INTO categories (id, name) VALUES (1,'food'); 
INSERT INTO categories (id, name) VALUES(2,'fruits');
INSERT INTO categories (id, name) VALUES (3,'vegetables');
INSERT INTO categories (id, name) VALUES (4,'dairy');

INSERT INTO products (id,name, description) VALUES (1,'Apple', 'Fresh and juicy fruit');
INSERT INTO products (id,name, description) VALUES  (2,'Orange', 'Sweet and tangy fruit');
INSERT INTO products (id,name, description) VALUES (3,'Banana', 'Soft and sweet fruit');
INSERT INTO products (id,name, description) VALUES (4,'Carrot', 'Crunchy and nutritious vegetable');
INSERT INTO products (id,name, description) VALUES (5,'Tomato', 'Juicy and versatile fruit');
INSERT INTO products (id,name, description) VALUES (6,'Cheese', 'Creamy and delicious dairy product');
INSERT INTO products (id,name, description) VALUES (7,'Yogurt', 'Healthy and refreshing dairy product');
INSERT INTO products (id,name, description) VALUES (8,'Milk', 'Rich and creamy dairy product');
INSERT INTO products (id,name, description) VALUES (9,'Bread', 'Soft and fluffy food staple');
INSERT INTO products (id,name, description) VALUES (10,'Pasta', 'Versatile and filling food staple');
INSERT INTO products (id,name, description) VALUES (11,'Rice', 'Nutritious and filling food staple');
