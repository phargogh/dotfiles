
# Custom override for the git prompt.  The git ref will:
# 1. Show a tag, if we are at a tag
# 2. Show the branch, if we are at a branch
# 3. Show the short revision hash otherwise
function git_prompt_info() {
  local ref
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
    ref=$(command git describe --exact-match --tags 2> /dev/null) || \
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}
