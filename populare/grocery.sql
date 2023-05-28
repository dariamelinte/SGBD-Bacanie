DROP TABLE groceries CASCADE CONSTRAINTS;
DROP TABLE grocery_products CASCADE CONSTRAINTS;
DROP TABLE sell_types CASCADE CONSTRAINTS;
DROP TABLE category_grocery_products CASCADE CONSTRAINTS;


CREATE TABLE groceries (
  id INT NOT NULL PRIMARY KEY,
  id_user INT NOT NULL,
  name VARCHAR2(255) NOT NULL,
  latitude FLOAT NOT NULL,
  longitude FLOAT NOT NULL,
  CONSTRAINT fk_groceries_id_user FOREIGN KEY (id_user) REFERENCES users(id),
  CONSTRAINT no_duplicates_groceries UNIQUE (name)
);

CREATE TABLE sell_types (
  id INT NOT NULL PRIMARY KEY,
  name VARCHAR2(255) NOT NULL,
  CONSTRAINT no_duplicates_sell_type UNIQUE (name)
);

CREATE TABLE product_groceries (
  id INT NOT NULL PRIMARY KEY,
  id_grocery INT NOT NULL,
  id_product INT NOT NULL,
  id_sell_type INT NOT NULL,
  CONSTRAINT fk_product_groceries_id_grocery FOREIGN KEY (id_grocery) REFERENCES groceries(id),
  CONSTRAINT fk_product_groceries_id_product FOREIGN KEY (id_product) REFERENCES products(id),
  CONSTRAINT fk_product_groceries_id_sell_type FOREIGN KEY (id_sell_type) REFERENCES sell_types(id)
);

CREATE TABLE category_grocery_products (
  id INT NOT NULL PRIMARY KEY,
  id_product_grocery INT NOT NULL,
  id_category INT NOT NULL,
  CONSTRAINT fk_category_product_groceries_id_product_grocery FOREIGN KEY (id_product_grocery) REFERENCES product_groceries(id),
  CONSTRAINT fk_category_product_groceries_id_category FOREIGN KEY (id_category) REFERENCES categories(id)
);

INSERT INTO groceries (name, id_user) VALUES ('Prima mea bacanie', 1), ('A 2a mea bacanie', 1), ('A 3a mea bacanie', 1);

INSERT INTO sell_types (id, name) VALUES (1, 'Per piece');
INSERT INTO sell_types (id, name) VALUES (2, 'Per 100g');

INSERT INTO product_groceries (id_grocery, id_product, id_sell_type) VALUES
	(1, 1, 2), (2, 1, 2), (3, 1, 2), (1, 2, 2), (2, 2, 2), (3, 2, 2), (1, 3, 2), (1, 4, 2), (1, 5, 2), (1, 6, 1), (1, 7, 1), (1, 8, 1), (1, 9, 1), (1, 10, 1), (1, 11, 1);

INSERT INTO category_grocery_products (id_product_grocery, id_category) VALUES (1, 2), (2, 2), (3, 2), (4, 2), (5, 2), (6, 2), (7, 2), (8, 3), (9, 3), (10, 4), (11, 4), (12, 4), (13, 1), (14, 1), (15, 1);
	

