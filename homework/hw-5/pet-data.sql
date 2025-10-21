
DROP TABLE IF EXISTS pet;

CREATE TABLE pet (
  id INT, 
  name VARCHAR NOT NULL,
  type VARCHAR NOT NULL DEFAULT 'dog',
  birthdate DATE,
  PRIMARY KEY (id)
);

INSERT INTO pet VALUES
  (1, 'bill', 'cat', '1982/06/13'), 
  (2, 'spike', 'dog', '1985/08/31'), 
  (3, 'hobbes', 'tiger', '1987/04/01'), 
  (4, 'toto', 'dog', '1933/11/17'),
  (5, 'babe', 'pig', '1995/01/01'),
  (6, 'snoopy', 'dog', '1965/08/10'),
  (7, 'donald', 'duck', '1934/06/03'),
  (8, 'tom', 'cat', '1920/02/10'),
  (9, 'jerry', 'mouse', '1920/02/10'),
  (10, 'odie', 'dog', '1978/08/08'),
  (11, 'garfield', 'cat', '1978/01/01');
