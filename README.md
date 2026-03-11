# Email for Claude

A Claude Desktop extension that gives Claude the ability to read, send, and manage email via IMAP/SMTP. Wraps [ai-zerolab/mcp-email-server](https://github.com/ai-zerolab/mcp-email-server).

## Features

- **Read emails** — filter by sender, recipient, subject, body, and date range with pagination
- **Send emails** — compose messages with To, CC, BCC, subject and body
- **Reply threading** — replies appear in the correct conversation thread
- **Attachments** — download email attachments (opt-in)
- **Multi-account** — configure more than one email account
- **Secure config** — passwords are stored in OS-level secure storage (Keychain / Credential Manager)

## Tools Provided

| Tool | Description |
|------|-------------|
| `add_email_account` | Add or update an email account configuration |
| `list_email_accounts` | List all configured email accounts |
| `get_emails` | Search and list emails with filters and pagination |
| `get_emails_content` | Fetch the full content of specific emails by ID |
| `send_email` | Send an email (supports threading via `in_reply_to` / `references`) |
| `download_attachment` | Save an attachment to disk (must be enabled in config) |

---

## Installation

### Option A — One-click install (`.mcpb` bundle)

1. **Download** the latest `email-mcp.mcpb` from [Releases](https://github.com/fingerskier/email-claude-extension/releases)
2. **Double-click** the `.mcpb` file — Claude Desktop will open an install dialog
3. **Fill in** your email credentials when prompted (see [Configuration](#configuration) below)
4. **Done** — the email tools are now available in Claude

### Option B — Build from source

Prerequisites: [Git](https://git-scm.com/), [zip](https://linux.die.net/man/1/zip) CLI

```bash
git clone https://github.com/fingerskier/email-claude-extension.git
cd email-claude-extension
./build.sh              # produces email-mcp.mcpb
./build.sh --install    # build + open to install
```

### Option C — Manual Claude Desktop config

If you prefer to configure the MCP server directly (no extension bundle), add the
following to your Claude Desktop config file:

- **macOS:** `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows:** `%APPDATA%\Claude\claude_desktop_config.json`

```json
{
  "mcpServers": {
    "email": {
      "command": "uvx",
      "args": ["mcp-email-server@latest", "stdio"],
      "env": {
        "MCP_EMAIL_SERVER_EMAIL_ADDRESS": "you@gmail.com",
        "MCP_EMAIL_SERVER_PASSWORD": "your-app-password",
        "MCP_EMAIL_SERVER_IMAP_HOST": "imap.gmail.com",
        "MCP_EMAIL_SERVER_IMAP_PORT": "993",
        "MCP_EMAIL_SERVER_SMTP_HOST": "smtp.gmail.com",
        "MCP_EMAIL_SERVER_SMTP_PORT": "465"
      }
    }
  }
}
```

> Requires [uv](https://docs.astral.sh/uv/getting-started/installation/) to be installed.

---

## Configuration

When you install the extension (Option A/B), Claude Desktop will prompt you for these settings:

| Field | Required | Description |
|-------|----------|-------------|
| **Email Address** | Yes | Your email address (e.g. `you@gmail.com`) |
| **Password / App Password** | Yes | Your password or app-specific password (stored securely) |
| **IMAP Host** | Yes | IMAP server (e.g. `imap.gmail.com`) |
| **SMTP Host** | Yes | SMTP server (e.g. `smtp.gmail.com`) |
| Login Username | No | Only needed if it differs from your email address |
| Display Name | No | Name shown on sent emails (defaults to email prefix) |
| Account Name | No | Label for the account (defaults to `default`) |
| IMAP Port | No | Defaults to `993` (SSL) |
| SMTP Port | No | Defaults to `465` (SSL) |

### Provider Quick Reference

| Provider | IMAP Host | SMTP Host | Notes |
|----------|-----------|-----------|-------|
| **Gmail** | `imap.gmail.com` | `smtp.gmail.com` | Use an [App Password](https://myaccount.google.com/apppasswords) |
| **Outlook / Office 365** | `outlook.office365.com` | `smtp.office365.com` | SMTP port `587` |
| **Yahoo Mail** | `imap.mail.yahoo.com` | `smtp.mail.yahoo.com` | Use an App Password |
| **iCloud** | `imap.mail.me.com` | `smtp.mail.me.com` | Use an App Password |
| **ProtonMail Bridge** | `127.0.0.1` (port `1143`) | `127.0.0.1` (port `1025`) | Requires [ProtonMail Bridge](https://proton.me/mail/bridge) running locally |
| **Fastmail** | `imap.fastmail.com` | `smtp.fastmail.com` | Use an App Password |

### Gmail Setup

Gmail requires an **App Password** instead of your regular password:

1. Go to [myaccount.google.com/apppasswords](https://myaccount.google.com/apppasswords)
2. Sign in and select **Mail** as the app
3. Copy the 16-character password
4. Use that as your password in the extension config

> You must have 2-Step Verification enabled on your Google account to generate App Passwords.

---

## Advanced Configuration

For features not exposed in the extension UI (attachment downloads, separate IMAP/SMTP
credentials, SSL toggles, multiple accounts), you can create a TOML config file:

**Location:** `~/.config/zerolib/mcp_email_server/config.toml`

```toml
enable_attachment_download = true

[[emails]]
account_name = "work"
full_name = "Jane Doe"
email_address = "jane@company.com"
user_name = "jane@company.com"
password = "app-password-here"

[emails.incoming]
host = "imap.gmail.com"
port = 993
ssl = true
verify_ssl = true

[emails.outgoing]
host = "smtp.gmail.com"
port = 465
ssl = true
verify_ssl = true

[[emails]]
account_name = "personal"
email_address = "jane@protonmail.com"

[emails.incoming]
host = "127.0.0.1"
port = 1143
verify_ssl = false

[emails.outgoing]
host = "127.0.0.1"
port = 1025
verify_ssl = false
```

---

## Usage Examples

Once installed, you can ask Claude things like:

- *"Check my email for anything from Alice in the last week"*
- *"Send a reply to that thread thanking them for the update"*
- *"Summarize my unread emails from today"*
- *"Draft a response to the latest email from support@example.com"*
- *"Download the PDF attachment from that email"*

---

## Development

```bash
git clone https://github.com/fingerskier/email-claude-extension.git
cd email-claude-extension

# Run the MCP server locally for testing
uvx mcp-email-server@latest ui     # interactive config UI
uvx mcp-email-server@latest stdio  # stdio mode (for MCP clients)

# Build the bundle
./build.sh
```

---

## Credits

- [ai-zerolab/mcp-email-server](https://github.com/ai-zerolab/mcp-email-server) — the upstream MCP email server
- [MCP Bundles (MCPB)](https://github.com/modelcontextprotocol/mcpb) — the extension packaging format

## License

MIT
