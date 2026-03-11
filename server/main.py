"""
Thin entry point for the email MCP extension.

This module launches the upstream mcp-email-server in stdio mode.
All configuration is passed via environment variables set by the
manifest's user_config → env mapping.

When running via the .mcpb bundle, Claude Desktop invokes `uvx mcp-email-server@latest stdio`
directly (see manifest.json mcp_config), so this file is only used as a
fallback entry point for local development.
"""

import subprocess
import sys


def main():
    try:
        subprocess.run(
            [sys.executable, "-m", "mcp_email_server", "stdio"],
            check=True,
        )
    except FileNotFoundError:
        # Fall back to uvx if the package isn't installed locally
        subprocess.run(
            ["uvx", "mcp-email-server@latest", "stdio"],
            check=True,
        )


if __name__ == "__main__":
    main()
