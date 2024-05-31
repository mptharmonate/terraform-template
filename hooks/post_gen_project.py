import os
import subprocess

def init_git(initial_commit_message):
    subprocess.run(['git', 'init'], check=True)
    subprocess.run(['git', 'add', '.'], check=True)
    subprocess.run(['git', 'commit', '-m', initial_commit_message], check=True)

def create_github_repo_function(repo_name):
    org_name = 'harmonate'
    print (f'Creating GitHub repository {org_name}/{repo_name}')
    #Create the repository on GitHub within the organization using the gh CLI
    subprocess.run(['gh', 'repo', 'create', f'{org_name}/{repo_name}', '--internal', '--source=.', '--remote=origin'], check=True)
    # Update the remote URL to use the git@github.work alias
    remote_url = f'git@github.work:{org_name}/{repo_name}.git'
    subprocess.run(['git', 'remote', 'set-url', 'origin', remote_url], check=True)
    # Push the initial commit to the new repository
    subprocess.run(['git', 'push', '-u', 'origin', 'main'], check=True)

# Check if git initialization is desired
initialize_git_repo = '{{ cookiecutter.initialize_git_repo }}'.lower()
initial_commit_message = '{{ cookiecutter.initial_commit_message }}'
if initialize_git_repo in ['yes', 'y']:
    init_git(initial_commit_message)

# Check if GitHub repository creation is desired
create_repo = '{{ cookiecutter.create_github_repo }}'.lower()
if create_repo in ['yes', 'y']:
    repo_name = '{{ cookiecutter.project_name }}'
    create_github_repo_function(repo_name)
