set -q c_star_prompt_symbol || set -g c_star_prompt_symbol ">"
set -q c_star_date_format || set -g c_star_date_format "%Y-%m-%dT%H:%M:%S%z"

function c_star_command_time --on-event fish_postexec
  set -g c_star_command_time $CMD_DURATION'ms'
end

function c_star_datetime --on-event fish_prompt --on-event fish_postexec --on-variable c_star_date_format
  set -g c_star_datetime (date "+$c_star_date_format")
end

function c_star_git --on-variable PWD
  set -g c_star_git "$(fish_git_prompt)"
end

function c_star_user  --on-event fish_prompt
  set -g c_star_user "$(whoami)"
end

function c_star_host  --on-event fish_prompt
  if test -n "$SSH_CONNECTION"
    set -g c_star_host "@$(hostname)"
  end
end

function c_star_user_marker --on-event fish_prompt
  switch (whoami)
    case "root"
      set -g c_star_user_marker "$(set_color red)#$(set_color normal)"
    case '*'
      set -g c_star_user_marker '$'
  end
end

function c_star_pwd --on-variable PWD --on-event fish_prompt
  set -g c_star_pwd "$(prompt_pwd)"
end