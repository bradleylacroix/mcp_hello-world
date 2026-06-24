# mcp_hello-world

Minimal hello-world scaffold for an MCP-style service.

Run the simple HTTP server locally:

```bash
python3 src/mcp_server.py
```

Then open or curl the hello endpoint:

```bash
curl http://localhost:8000/hello
```

This project contains:

- `src/mcp_server.py`: minimal HTTP server responding at `/hello`
- `.gitignore`: common Python ignores
- `requirements.txt`: empty for this minimal example

Azure Function deploy (Bicep)

Files added:

- `infra/main.bicep`: Bicep template creating storage, app insights, app plan, and function app
- `infra/deploy.sh`: helper script that creates `rg_hello-world` and deploys the Bicep template
- `src/func_app`: Python Azure Functions scaffold (HTTP-triggered `Hello` function)

Deploy steps:

```bash
# ensure you are logged in to the correct Azure subscription
az login
# create resource group and deploy infra
bash infra/deploy.sh
```

Naming notes:

- You requested resources named using the pattern `<abbr>_hello-world`. Some Azure services (storage account, hostname-based names) have stricter naming rules that disallow underscores and uppercase letters; the Bicep template sanitizes names where required.


