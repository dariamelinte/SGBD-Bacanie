DROP TABLE IF EXISTS tranzaction_types CASCADE;
DROP TABLE IF EXISTS tranzactions CASCADE;

CREATE TABLE tranzaction_types (
  id INT NOT NULL PRIMARY KEY,
  name VARCHAR2(255) NOT NULL,

  CONSTRAINT no_duplicates UNIQUE (name)
);

CREATE TABLE tranzactions (
  id INT NOT NULL PRIMARY KEY,
  id_tranzaction_type INT NOT NULL,
  id_product_grocery INT NOT NULL,
  date DATE NOT NULL,
  quantity FLOAT NOT NULL,
  CONSTRAINT fk_tranzactions_id_tranzaction_type FOREIGN KEY (id_tranzaction_type) REFERENCES tranzaction_types(id),
  CONSTRAINT fk_tranzactions_id_product_grocery FOREIGN KEY (id_product_grocery) REFERENCES product_groceries(id)
);
