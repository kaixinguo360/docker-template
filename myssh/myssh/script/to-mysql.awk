BEGIN {
    print "CREATE TABLE IF NOT EXISTS passwords (insert_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, time DATETIME, user VARCHAR(32), password VARCHAR(64), rhost CHAR(15))ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;"
    printf "INSERT INTO %s (time, user, password, rhost) VALUES\n", table
}
NR>1 {
    printf "('%s %s', '%s', '%s', '%s'),\n", date, time, user, pw, rhost
}
{
    date=$1
    time=$2
    user=substr($3 ,6)
    pw=substr($4 ,4)
    rhost=substr($5, 7)
    gsub("\\\\", "\\\\\\", user)
    gsub("'", "\'", user)
    gsub("\\\\", "\\\\\\", pw)
    gsub("'", "\'", pw)
}
END {
    printf "('%s %s', '%s', '%s', '%s');\n", date, time, user, pw, rhost
}
