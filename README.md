# saas-starter

## Setup

```sh
# Install dependencies
pnpm install

# Create Neon api key - https://console.neon.tech/app/settings/api-keys
# Set environment variables
echo "NEON_API_KEY=<your-api-key>" >> .env

# Create GitHub app - https://github.com/settings/apps
# Set secrets
sst secret set GITHUB_CLIENT_ID "<your-github-client-id>"
sst secret set GITHUB_CLIENT_SECRET "<your-github-client-secret>"

# Run modules in dev mode
sst dev

# Check auth URL from sst dev output
# Set GitHub app callback URL to `<your-auth-url>/github/callback`
```
