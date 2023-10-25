/^[a-zA-Z0-9]/ {
    printf "  {\"" $1; $1="";
    printf "\",\t \"";
    printf substr($0,2);
    printf "\"},\n"
}
