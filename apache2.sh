create table chai (
customer_id BIGINT NOT NULL,
created_at DATETIME NOT NULL,
pre_discount INT NOT NULL,
post_discount INT NOT NULL,
cashback_amount INT NOT NULL,
discount_amount INT NOT NULL,
total_promotion INT NOT NULL,
push_permission VARCHAR(8) NOT NULL,
gender VARCHAR(8) NOT NULL,
is_foreigner VARCHAR(8) NOT NULL,
birthday DATETIME NOT NULL,
sign_up_date DATETIME NOT NULL,
merchant_id INT NOT NULL
);



LOAD DATA local INFILE '/root/chai_ba_assesment.csv' 
INTO TABLE chai
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
