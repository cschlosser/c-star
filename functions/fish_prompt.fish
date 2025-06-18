function c_star_segment_divide_left
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
  echo (set_color -b $to $from)\uE0B0(set_color normal)
end

function fish_prompt --description "The left side of the C-Star prompt"
  echo -e "$c_star_user$c_star_host$(c_star_segment_divide_left user pwd)$c_star_pwd$(c_star_segment_divide_left pwd git)$c_star_git$(c_star_segment_divide_left git normal)\n$c_star_user_marker$(c_star_segment_divide_left user_marker normal) "
end