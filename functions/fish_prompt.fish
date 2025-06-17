function fish_prompt --description "The left side of the C-Star prompt"
  echo -e "$c_star_user$c_star_host $c_star_pwd $c_star_git\n$c_star_user_marker$c_star_prompt_symbol "
end