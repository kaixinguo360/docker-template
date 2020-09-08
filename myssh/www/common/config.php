<?php

# Set MySQL Server
define("DB_HOST", "db");
define("DB_USER", "myssh");
define("DB_PASS", "1234567");
define("DB_NAME", "myssh");

# Connect To Database
$db = new mysqli(DB_HOST,DB_USER,DB_PASS,DB_NAME);
if(mysqli_connect_error()){
    echo 'ERROR: ';
    echo mysqli_connect_error();
    exit;
}

#mysqli_set_charset($db, "utf8");
$data_table="passwords";
