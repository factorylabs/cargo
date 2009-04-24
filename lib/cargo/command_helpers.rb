require 'readline'

def git_branch
  `git branch | grep "*"`.strip[2..-1]
end

def compare_git_ver
  m = /git version (\d+).(\d+).(\d+)/.match(`git version`.strip)
  return true  if m[1].to_i > 1
  return false if m[1].to_i < 1
  return true  if m[2].to_i > 5
  return false if m[2].to_i < 5
  return true  if m[3].to_i >= 3
  return false
end

def check_git_ver
  raise "Invalid git version, use at least 1.5.3" unless compare_git_ver
end