#!/bin/sh

cd $(dirname $0)

echo "CREATE TABLE IF NOT EXISTS history \
    ENGINE=InnoDB \
    DEFAULT CHARSET=utf8mb4 \
    SELECT * FROM passwords WHERE 1=2;" | mysql-cli.sh

echo "BEGIN; \
    INSERT INTO history \
        SELECT * FROM passwords \
        WHERE time < DATE_SUB(CURDATE(), INTERVAL 7 DAY);
    DELETE FROM passwords \
        WHERE time < DATE_SUB(CURDATE(), INTERVAL 7 DAY);
    COMMIT;" | mysql-cli.sh
