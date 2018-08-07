# Configuration file for Jupyter Hub

c = get_config()

##### Server config
c.JupyterHub.log_level = 10
c.JupyterHub.port = 9976
c.JupyterHub.base_url = '/jupyter'

##### Authentication config
from oauthenticator.github import LocalGitHubOAuthenticator
c.JupyterHub.authenticator_class = LocalGitHubOAuthenticator

import os
c.GitHubOAuthenticator.oauth_callback_url = os.environ['OAUTH_CALLBACK_URL']
c.GitHubOAuthenticator.scope = ['read:org']
c.GitHubOAuthenticator.github_organization_whitelist = ['ZwickyTransientFacility']

##### User management config
c.Authenticator.admin_users = { 'mjuric' }
c.JupyterHub.admin_access = True
c.Spawner.cmd = '/srv/single-user.sh'
c.LocalAuthenticator.add_user_cmd = ["useradd", "-m", "-G", "ztf", "-s", "/bin/bash"]
c.LocalGitHubOAuthenticator.create_system_users = True
