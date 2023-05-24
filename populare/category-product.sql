DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS product_categories CASCADE;

CREATE TABLE categories (
  id INT NOT NULL PRIMARY KEY,
  name VARCHAR2(255) NOT NULL,
  CONSTRAINT no_duplicates UNIQUE (name)
);

CREATE TABLE products (
  id INT NOT NULL PRIMARY KEY,
  name VARCHAR2(255) NOT NULL,
  description VARCHAR2(255) NOT NULL,
  CONSTRAINT no_duplicates UNIQUE (name)
);


INSERT INTO categories (name) VALUES ('food'), ('fruits'), ('vegetables'), ('dairy');

INSERT INTO products (name, description)
VALUES 
  ('Apple', 'Fresh and juicy fruit'),
  ('Orange', 'Sweet and tangy fruit'),
  ('Banana', 'Soft and sweet fruit'),
  ('Carrot', 'Crunchy and nutritious vegetable'),
  ('Tomato', 'Juicy and versatile fruit'),
  ('Cheese', 'Creamy and delicious dairy product'),
  ('Yogurt', 'Healthy and refreshing dairy product'),
  ('Milk', 'Rich and creamy dairy product'),
  ('Bread', 'Soft and fluffy food staple'),
  ('Pasta', 'Versatile and filling food staple'),
  ('Rice', 'Nutritious and filling food staple');