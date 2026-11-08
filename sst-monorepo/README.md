# CDSS

## Getting started

Configure AWS credentials

`~./aws/config`

```
[default]
region = eu-west-2
mfa_serial = arn:aws:iam::<arn>:mfa/<identifier>

[profile dev]
source_profile = default
role_arn = arn:aws:iam::<arn>:role/<role>
```

`~/.aws/credentials`

```
[default]
aws_access_key_id = <access_key_id>
aws_secret_access_key = <secret_access_key>
```

Assume dev role

```
awsume dev
```

Install [pnpm](https://pnpm.io), [uv](https://docs.astral.sh/uv/), and [go](https://go.dev)

Install dependencies

```sh
pnpm install
uv sync --all-packages
go mod download
```

Deploy resources in dev mode

- Save changes to [sst.config.ts](sst.config.ts) or [infra/](infra/) to redeploy changed modules
- Uses different stage names for dev and deploy to avoid redeploying dev stubs

```sh
pnpm run dev
```

Run CI checks locally

```sh
pnpm run check
```
