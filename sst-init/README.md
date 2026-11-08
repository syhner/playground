# saas-starter

## Setup

```sh
# Install dependencies
pnpm install

# Create GitHub app - https://github.com/settings/apps
# Set secrets
sst secret set DatabaseUrl "<your-database-url>"
sst secret set GithubClientId "<your-github-client-id>"
sst secret set GithubClientSecret "<your-github-client-secret>"

# Run modules in dev mode
sst dev

# Check auth URL from sst dev output
# Set GitHub app callback URL to `<your-auth-url>/github/callback`
```
