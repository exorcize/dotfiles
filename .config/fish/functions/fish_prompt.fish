# fish theme: gentoo

function _git_branch_name
  echo (command git symbolic-ref HEAD 2>/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty 2>/dev/null)
end

function fish_prompt
  set fish_greeting
  set -l cyan (set_color cyan)
  set -l red (set_color -o red)
  set -l blue (set_color -o blue)
  set -l green (set_color -o green)
  set -l normal (set_color normal)
  set -l white (set_color -o normal)

  set -l cwd (pwd | sed -e "s!^$HOME!~!g")
  # output the prompt, left to right:
  if [ (id -u) = "0" ];
    set cwd (basename $cwd)
    # display host
    echo -n -s $red (uname -n |cut -d . -f 1) " "
  else
    # display 'user@host:'
    echo -n -s $white (whoami) @ $white (uname -n|cut -d . -f 1) ":"
  end

  # display the current directory name:
  echo -n -s $cyan $cwd $normal

  # show git branch and dirty state, if applicable:
  if [ (_git_branch_name) ]
    set -l git_branch '[' (_git_branch_name) ']'

    if [ (_is_git_dirty) ]
      set git_info $red $git_branch "×"
    else
      set git_info $cyan $git_branch
    end
    echo -n -s ' ' $git_info $normal
  end

  # terminate with a nice prompt char:
  if [ (id -u) = "0" ];
    set indicate '#'
  else
    set indicate '$'
  end
  echo -n -s $normal "$indicate " $normal
end
