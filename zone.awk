/^[a-zA-Z0-9]/ {
    gsub("[()]", "", $1); printf $1;
    $1="";
    printf "\t IN TXT \"";
    printf substr($0,2);
    printf "\"\n"
}
