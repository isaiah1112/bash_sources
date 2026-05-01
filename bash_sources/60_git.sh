### Git Additions
### Author: Jesse Almanrode (https://about.me/JesseAlmanrode)
### License: GNU GPLv3 (https://choosealicense.com/licenses/gpl-3.0/)
### Aliases and functions which load if you have git installed

if ! command -v git &>/dev/null; then
    echo "git is not installed. Not loading source.";
    return 0;
fi

alias gdiff='diff -burN';
# ensure we always rebase on a 'git pull'
git config --global pull.rebase true

# git aliases
git config --global alias.mod 'diff --cached --name-only --diff-filter=ACM';
git config --global alias.grep 'log -p -q -S';
git config --global alias.s status;
git config --global alias.d diff;
git config --global alias.co checkout;
git config --global alias.br branch;
git config --global alias.last 'log -1 HEAD';
git config --global alias.cane 'commit --amend --no-edit';
git config --global alias.pr 'pull --rebase';
git config --global alias.lo 'log --oneline -n 10';

function gitmerged() {
    if [ ! -d .git ]; then
        echo "Error: not a git repository"
        return 1
    fi
    
    if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
        echo "List and delete branches in git that have been merged to master"
        echo "USAGE: gitmerged [--delete]"
        return 0
    fi
    
    local branches
    branches=$(git branch -r --merged origin/master | \
        grep -v "^.*master" | \
        grep -v "^.*upstream" | \
        grep -v "^.*develop" | \
        sed 's:origin/::')
    
    if [ "$1" == "--delete" ]; then
        echo "$branches" | xargs -n 1 git push origin --delete
    else
        echo "$branches"
    fi
}

function branchup() {
    if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
        echo "Run git pull on all branches in $(pwd)"
        return 0
    fi
    
    if [ ! -d .git ]; then
        echo "Error: not a git repository"
        return 1
    fi
    
    local original_branch
    original_branch=$(git branch --show-current)
    
    for branch in $(git branch | awk '{print $NF}'); do
        git checkout "$branch" 2>/dev/null || continue
        git pull || echo "Warning: failed to pull $branch"
    done
    
    git checkout "$original_branch" 2>/dev/null
}

function repoup() {
    if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
        echo "Run git pull in all repos under $(pwd)"
        return 0
    fi
    
    local original_dir
    original_dir=$(pwd)
    local separator="----------------"
    
    while IFS= read -r dir; do
        if [ -d "${dir}/.git" ]; then
            echo -e "${separator}\n${dir}\n${separator}"
            cd "$dir"
            git pull || echo "Warning: failed to pull in $dir"
            cd "$original_dir"
        fi
    done < <(find . -maxdepth 2 -type d -name .git | cut -d '/' -f2)
}

function git_release_notes() {
    if [ ! -d .git ]; then
        echo "Error: not a git repository"
        return 1
    fi
    
    if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
        echo "USAGE: git_release_notes [start_tag] [end_tag]"
        return 0
    fi
    
    local last_release
    if [ -z "$1" ]; then
        last_release=$(git tag | tail -1)
    else
        last_release="$1"
    fi
    
    local this_release
    if [ -z "$2" ]; then
        this_release=""
        echo "# Release $(git branch --show-current)"
    else
        this_release="refs/tags/$2"
        echo "# Release $2"
    fi
    
    git shortlog --no-merges "${last_release}..${this_release}" --format="* %s [%h]" | sed 's/      / /'
}

function git_mirror() {
    if [ "$1" == "--help" ] || [ "$1" == "-h" ] || [ $# -ne 2 ]; then
        echo "USAGE: git_mirror <src_repo_url> <dst_repo_url>"
        return 0
    fi
    
    local src_repo="$1"
    local dst_repo="$2"
    
    echo "Cloning repo $src_repo"
    local repo
    repo=$(basename "$src_repo")
    
    git clone --mirror "$src_repo" || {
        echo "Error: failed to clone repository"
        return 1
    }
    
    cd "$repo" || {
        echo "Error: failed to enter cloned repository"
        return 1
    }
    
    echo "Mirroring to $dst_repo"
    git remote set-url origin "$dst_repo"
    git push --mirror origin
    cd ..
}
