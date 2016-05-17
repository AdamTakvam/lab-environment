# Source me!

function gitcp() {
    msg=${1:-"auto-commit"}
    git commit -am "$msg" || return 1
    unset msg

    git status
    echo -n "Push it (y,N)?"
    read input

    if [[ ${input,,} =~ ^y ]]  # True if $input = y, Y, yes, Yes, YES, etc
      then echo "Push it real good."
      git push
    else 
      echo "Changes have been committed, but not pushed."
    fi
    unset input
}

function gitacp() {
    git add .
    gitcp "$1"
}