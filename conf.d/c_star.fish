set -q c_star_date_format || set -g c_star_date_format "%Y-%m-%dT%H:%M:%S%z"
set -q c_star_user_bg || set -g c_star_user_bg a9b7c6
set -q c_star_user_fg || set -g c_star_user_fg 333333
set -q c_star_pwd_bg || set -g c_star_pwd_bg $c_star_user_fg
set -q c_star_pwd_fg || set -g c_star_pwd_fg $c_star_user_bg
set -q c_star_git_bg || set -g c_star_git_bg $c_star_user_bg
set -q c_star_git_fg || set -g c_star_git_fg $c_star_user_fg
set -q c_star_user_marker_default_bg || set -g c_star_user_marker_default_bg $c_star_user_fg
set -q c_star_user_marker_fg || set -g c_star_user_marker_fg $c_star_user_bg
set -q c_star_datetime_bg || set -g c_star_datetime_bg $c_star_user_fg
set -q c_star_datetime_fg || set -g c_star_datetime_fg $c_star_user_bg
set -q c_star_command_time_bg || set -g c_star_command_time_bg $c_star_user_bg
set -q c_star_command_time_fg || set -g c_star_command_time_fg $c_star_user_fg

function c_star_colorize
  set -l bg $argv[3]
  set -l fg $argv[4]
  set -g "$argv[1]" "$(set_color -b $bg $fg) $argv[2] $(set_color normal)"
end

# TODO: Clear this after enter?
function c_star_command_time --on-event fish_postexec --on-variable c_star_command_time_bg --on-variable c_star_command_time_fg
  c_star_colorize c_star_command_time $CMD_DURATION'ms' $c_star_command_time_bg $c_star_command_time_fg
end

function c_star_datetime --on-event fish_prompt --on-event fish_postexec --on-variable c_star_date_format  --on-variable c_star_datetime_bg --on-variable c_star_datetime_fg
  c_star_colorize c_star_datetime (date "+$c_star_date_format") $c_star_datetime_bg $c_star_datetime_fg
end

function c_star_git --on-event fish_prompt --on-variable PWD --on-variable c_star_git_bg --on-variable c_star_git_fg
  set -lx __fish_git_prompt_show_informative_status 1
  set -l git_status (fish_git_prompt)
  if test -n "$git_status"
    c_star_colorize c_star_git $git_status $c_star_git_bg $c_star_git_fg
  else
    set -ge c_star_git
  end
end

function c_star_user --on-event fish_prompt --on-variable c_star_user_bg --on-variable c_star_user_fg --on-variable SSH_CONNECTION
  set -l user_string (whoami)
  if test -n "$SSH_CONNECTION"
    set -f user_string "$user_string@$(hostname)"
  end
  c_star_colorize c_star_user "$user_string" $c_star_user_bg $c_star_user_fg
end

function c_star_user_marker --on-event fish_prompt  --on-variable c_star_user_marker_default_bg --on-variable c_star_user_marker_fg
  switch (whoami)
    case "root"
      set -g c_star_user_marker_bg red
      set -f char "#"
    case '*'
      set -g c_star_user_marker_bg $c_star_user_marker_default_bg
      set -f char "\$"
  end
  c_star_colorize c_star_user_marker $char $c_star_user_marker_bg $c_star_user_marker_fg
end

function c_star_pwd --on-variable PWD --on-event fish_prompt --on-variable c_star_pwd_bg --on-variable c_star_pwd_fg
  c_star_colorize c_star_pwd (prompt_pwd) $c_star_pwd_bg $c_star_pwd_fg
end