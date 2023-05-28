DROP TABLE tranzaction_types CASCADE CONSTRAINTS;
DROP TABLE tranzactions CASCADE CONSTRAINTS;

CREATE TABLE tranzaction_types (
  id INT NOT NULL PRIMARY KEY,
  name VARCHAR2(255) NOT NULL,

  CONSTRAINT no_duplicates_t1 UNIQUE (name)
);

CREATE TABLE tranzactions (
  id INT NOT NULL PRIMARY KEY,
  id_tranzaction_type INT NOT NULL,
  id_product_grocery INT NOT NULL,
  tranzaction_date DATE NOT NULL,
  quantity FLOAT NOT NULL,
  CONSTRAINT fk_tranzactions_id_t_type FOREIGN KEY (id_tranzaction_type) REFERENCES tranzaction_types(id),
  CONSTRAINT fk_tranzactions_id_p_g FOREIGN KEY (id_product_grocery) REFERENCES product_groceries(id)
);
