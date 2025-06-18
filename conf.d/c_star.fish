set -q c_star_date_format || set -g c_star_date_format "%Y-%m-%dT%H:%M:%S%z"
set -g c_star_default_bg 333333
set -g c_star_default_fg a9b7c6
set -q c_star_user_bg || set -g c_star_user_bg $c_star_default_fg
set -q c_star_user_fg || set -g c_star_user_fg $c_star_default_bg
set -q c_star_pwd_bg || set -g c_star_pwd_bg $c_star_default_bg
set -q c_star_pwd_fg || set -g c_star_pwd_fg $c_star_default_fg
set -q c_star_git_bg || set -g c_star_git_bg $c_star_default_fg
set -q c_star_git_fg || set -g c_star_git_fg $c_star_default_bg
set -q c_star_user_marker_default_bg || set -g c_star_user_marker_default_bg $c_star_default_bg
set -q c_star_user_marker_fg || set -g c_star_user_marker_fg $c_star_default_fg
set -q c_star_datetime_bg || set -g c_star_datetime_bg $c_star_default_bg
set -q c_star_datetime_fg || set -g c_star_datetime_fg $c_star_default_fg
set -q c_star_command_time_bg || set -g c_star_command_time_bg $c_star_default_fg
set -q c_star_command_time_fg || set -g c_star_command_time_fg $c_star_default_bg

set -g _c_star_git_async _c_star_git_async_$fish_pid

function c_star_colorize
  set -l bg $argv[3]
  set -l fg $argv[4]
  set -g "$argv[1]" "$(set_color -b $bg $fg) $argv[2] $(set_color normal)"
end

# TODO: Clear this after pressing enter?
function c_star_command_time --on-event fish_postexec --on-variable c_star_command_time_bg --on-variable c_star_command_time_fg
  c_star_colorize c_star_command_time $CMD_DURATION'ms' $c_star_command_time_bg $c_star_command_time_fg
end

function c_star_datetime --on-event fish_prompt --on-event fish_postexec --on-variable c_star_date_format  --on-variable c_star_datetime_bg --on-variable c_star_datetime_fg
  c_star_colorize c_star_datetime (date "+$c_star_date_format") $c_star_datetime_bg $c_star_datetime_fg
end

function c_star_git_query_async --on-event fish_prompt --on-variable PWD --on-variable c_star_git_bg --on-variable c_star_git_fg
  # TODO cache the current git repo to minimize calls
  set -Ue $_c_star_git_async
  fish --private --command "set -x __fish_git_prompt_show_informative_status 1 && \
      set -U $_c_star_git_async (fish_git_prompt '%s') && \
      set -q $_c_star_git_async || set -Ue $_c_star_git_async $git_status
  "&
end

function c_star_git --on-variable $_c_star_git_async
  set git_status $$_c_star_git_async
  if test -n "$git_status"
    c_star_colorize c_star_git $git_status $c_star_git_bg $c_star_git_fg
  else
    set -ge c_star_git
  end
  commandline --function repaint
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

function c_star_cleanup --on-event fish_exit
    set -Ue $_c_star_git_async
end