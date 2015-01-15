# Vagrant
set -x VAGRANT_DEFAULT_PROVIDER virtualbox
alias v='vagrant'
alias vu='vagrant up; boxcar "Vagrant up!"'
alias vp='vagrant provision; boxcar "Vagrant provisioned!"'
alias vr='vagrant reload'
alias vs='vagrant suspend'
alias vd='vagrant destroy'
alias vdf='vagrant destroy --force'
alias vh='vagrant halt'
alias vredo='vagrant destroy --force; vagrant up; boxcar "Vagrant up!"'

function fish_prompt
  if not set -q -g __fish_robbyrussell_functions_defined
    set -g __fish_robbyrussell_functions_defined

    function _git_branch_name
      # echo (git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
      echo (git branch ^/dev/null | grep '\*' | sed -E -e 's/^..\(?([\w]*)/\1/' -e 's|)$||')
    end

    function _is_git_dirty
      echo (git status -s --ignore-submodules=dirty ^/dev/null)
    end

    function _git_changes
      # echo (git status --porcelain)
      echo (git status --porcelain ^/dev/null | grep -E '^.\?|^\?|^U|^.U')
    end
  end

  set -l cyan (set_color -o cyan)
  set -l yellow (set_color yellow)
  set -l red (set_color -o red)
  set -l blue (set_color -o blue)
  set -l green (set_color -o green)
  set -l normal (set_color normal)
  set -l ok_color $green

  set -l usr $ok_color (whoami)
  set -l cwd $normal ' in ' $ok_color (prompt_pwd)

  if [ (_git_branch_name) ]
    set -l git_branch (_git_branch_name)

    if [ (_is_git_dirty) ]
      set git_info $normal " on " $red $git_branch " ✗"
    else
      set git_info $normal " on " $ok_color $git_branch " ✔︎"
    end

    if [ (_git_changes) ]
      set git_changes (git status --porcelain ^/dev/null | grep -E '^.\?|^\?|^U|^.U')
    end
  end

  echo -s $usr $cwd $git_info
  if [ (_git_branch_name) ]
    echo -n $yellow
    for var in $git_changes; echo $var; end
  end
  echo -s $yellow "➜ " $normal

end
