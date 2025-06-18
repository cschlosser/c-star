set -q cstar_date_format || set -g cstar_date_format "%Y-%m-%dT%H:%M:%S%z"
set -g cstar_default_bg 333333
set -g cstar_default_fg a9b7c6
set -q cstar_user_bg || set -g cstar_user_bg $cstar_default_fg
set -q cstar_user_fg || set -g cstar_user_fg $cstar_default_bg
set -q cstar_pwd_bg || set -g cstar_pwd_bg $cstar_default_bg
set -q cstar_pwd_fg || set -g cstar_pwd_fg $cstar_default_fg
set -q cstar_git_bg || set -g cstar_git_bg $cstar_default_fg
set -q cstar_git_fg || set -g cstar_git_fg $cstar_default_bg
set -q cstar_user_marker_default_bg || set -g cstar_user_marker_default_bg $cstar_default_bg
set -q cstar_user_marker_fg || set -g cstar_user_marker_fg $cstar_default_fg
set -q cstar_datetime_bg || set -g cstar_datetime_bg $cstar_default_bg
set -q cstar_datetime_fg || set -g cstar_datetime_fg $cstar_default_fg
set -q cstar_command_time_bg || set -g cstar_command_time_bg $cstar_default_fg
set -q cstar_command_time_fg || set -g cstar_command_time_fg $cstar_default_bg

set -g _cstar_git_async _cstar_git_async_$fish_pid
set -g _cstar_git_cached_pwd _cstar_git_cached_pwd_$fish_pid

function cstar_colorize
  set -l bg $argv[3]
  set -l fg $argv[4]
  set -g "$argv[1]" "$(set_color -b $bg $fg) $argv[2] $(set_color normal)"
end

function cstar_command_time --on-event fish_postexec --on-variable cstar_command_time_bg --on-variable cstar_command_time_fg
  cstar_colorize cstar_command_time $CMD_DURATION'ms' $cstar_command_time_bg $cstar_command_time_fg
end

function cstar_datetime --on-event fish_prompt --on-event fish_postexec --on-variable cstar_date_format  --on-variable cstar_datetime_bg --on-variable cstar_datetime_fg
  cstar_colorize cstar_datetime (date "+$cstar_date_format") $cstar_datetime_bg $cstar_datetime_fg
end

function cstar_git_query_async --on-event fish_prompt --on-variable PWD --on-variable cstar_git_bg --on-variable cstar_git_fg
  if test "$(git rev-parse --is-inside-work-tree 2> /dev/null)" != "true"
    set -Ue $_cstar_git_async
    set -Ue $_cstar_git_cached_pwd
  end

  set -l cached_pwd $$_cstar_git_cached_pwd

  if test "$PWD" != "$cached_pwd"
    set -Ue $_cstar_git_async
  end

  fish --private --command "set -x __fish_git_prompt_show_informative_status 1 && \
      set -U $_cstar_git_async (fish_git_prompt '%s') && \
      set -q $_cstar_git_async || set -Ue $_cstar_git_async $git_status && \
      set -U $_cstar_git_cached_pwd \"$PWD\"
  "&
end

function cstar_git --on-variable $_cstar_git_async
  set git_status $$_cstar_git_async
  if test -n "$git_status"
    cstar_colorize cstar_git $git_status $cstar_git_bg $cstar_git_fg
  else
    set -ge cstar_git
  end
  commandline --function repaint
end

function cstar_user --on-event fish_prompt --on-variable cstar_user_bg --on-variable cstar_user_fg --on-variable SSH_CONNECTION
  set -l user_string (whoami)
  if test -n "$SSH_CONNECTION"
    set -f user_string "$user_string@$(hostname)"
  end
  cstar_colorize cstar_user "$user_string" $cstar_user_bg $cstar_user_fg
end

function cstar_user_marker --on-event fish_prompt  --on-variable cstar_user_marker_default_bg --on-variable cstar_user_marker_fg
  switch (whoami)
    case "root"
      set -g cstar_user_marker_bg red
      set -f char "#"
    case '*'
      set -g cstar_user_marker_bg $cstar_user_marker_default_bg
      set -f char "\$"
  end
  cstar_colorize cstar_user_marker $char $cstar_user_marker_bg $cstar_user_marker_fg
end

function cstar_pwd --on-variable PWD --on-event fish_prompt --on-variable cstar_pwd_bg --on-variable cstar_pwd_fg
  cstar_colorize cstar_pwd (prompt_pwd) $cstar_pwd_bg $cstar_pwd_fg
end

function cstar_cleanup --on-event fish_exit
    set -Ue $_cstar_git_async
    set -Ue $_cstar_git_cached_pwd
end
