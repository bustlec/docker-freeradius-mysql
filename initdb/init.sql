use radius;
source /opt/sql/schema.sql
source /opt/sql/setup.sql

INSERT INTO radcheck (username,attribute,op,value) values("im_bustlec", "Cleartext-Password", ":=", "password");
