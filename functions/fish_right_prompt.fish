function c_star_segment_divide_right
  set -l from_var "c_star_$argv[1]"
  set -l from_name "$from_var""_bg"
  set -l from $$from_name
  set -l to_var "c_star_$argv[2]"
  set -l to_name "$to_var""_bg"
  set -l to $$to_name

  if test -z "$$from_var"
    return
  end
  if test -z "$$to_var"
    set -f to normal
  end
  echo (set_color -b $to $from)\uE0B2(set_color normal)
end

function fish_right_prompt --description "The right side of the C-Star prompt"
  echo -e "$(c_star_segment_divide_right command_time normal)$c_star_command_time$(c_star_segment_divide_right datetime command_time)$c_star_datetime"
end