DROP TABLE roles CASCADE CONSTRAINTS;
DROP TABLE users CASCADE CONSTRAINTS;
DROP TABLE user_roles CASCADE CONSTRAINTS;

CREATE TABLE roles (
  id NUMBER PRIMARY KEY,
  name VARCHAR2(255) NOT NULL,
  CONSTRAINT no_duplicates UNIQUE (name)
);

CREATE TABLE users (
  id INT NOT NULL PRIMARY KEY,
  first_name VARCHAR2(255) NOT NULL,
  last_name VARCHAR2(255) NOT NULL,
  email VARCHAR2(255) NOT NULL,
  phone_number VARCHAR2(255) NOT NULL,
  birth_date DATE NOT NULL,
  hashed_password VARCHAR2(255) NOT NULL,
  jwt VARCHAR2(255),
  CONSTRAINT no_duplicates_users UNIQUE (email)
);

CREATE TABLE user_roles (
  id INT NOT NULL PRIMARY KEY,
  id_role INT NOT NULL,
  id_user INT NOT NULL,
  is_confirmed INT NOT NULL,
  CONSTRAINT fk_user_roles_id_role FOREIGN KEY (id_role) REFERENCES roles(id),
  CONSTRAINT fk_user_roles_id_user FOREIGN KEY (id_user) REFERENCES users(id)
);

INSERT INTO roles (id, name) VALUES (1, 'admin');
INSERT INTO roles (id, name) VALUES (2, 'shop owner');
INSERT INTO roles (id, name) VALUES (3, 'buyer');

INSERT INTO users (id, first_name, last_name, email, phone_number, birth_date, hashed_password, jwt)
VALUES (1, 'John', 'Doe', 'john.doe@example.com', '1234567890', TO_DATE('23-05-2000', 'DD-MM-YYYY'), 'hash123', 'jwt123');
 INSERT INTO users (id, first_name, last_name, email, phone_number, birth_date, hashed_password, jwt)
VALUES  (2, 'Jane', 'Doe', 'jane.doe@example.com', '0987654321', TO_DATE('20-02-2003', 'DD-MM-YYYY'), 'hash456', 'jwt456');
  INSERT INTO users (id, first_name, last_name, email, phone_number, birth_date, hashed_password, jwt)
VALUES (3, 'Bob', 'Smith', 'bob.smith@example.com', '5551234567', TO_DATE('28-08-2002', 'DD-MM-YYYY'), 'hash789', 'jwt789');

INSERT INTO user_roles (id, id_role, id_user, is_confirmed) VALUES (1, 2, 1, 0); 
INSERT INTO user_roles (id, id_role, id_user, is_confirmed) VALUES (2, 3, 2, 1);
INSERT INTO user_roles (id, id_role, id_user, is_confirmed) VALUES (3, 1, 3, 1);

select * from roles;

commit;