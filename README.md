# SwiftLaw CLI

A law firm in your terminal — draft, edit, and redline fund-formation documents
with an AI agent, right from the command line.

Install one way, then `swiftlaw login`. No Node, no Python, no API keys, no AWS —
the binary is fully self-contained and inference is proxied through the SwiftLaw
backend. You only need a personal **CLI token**.

### macOS / Linux — curl
```bash
curl -fsSL https://raw.githubusercontent.com/SwiftLaw-Conductor/homebrew-tap/main/install.sh | bash
swiftlaw login
```

### macOS / Linux — Homebrew
```bash
brew install SwiftLaw-Conductor/tap/swiftlaw
swiftlaw login
```

### Windows — winget
```powershell
winget install SwiftLaw.CLI
swiftlaw login
```

## Getting a token

`swiftlaw login` asks for an `sl_…` token. Get one from the web app:
**tryswiftlaw.com/app → your avatar (top-right) → CLI Tokens → Generate**. The
token is shown once — paste it into `swiftlaw login`. (Don't see the menu item?
Token generation is currently admin-only — ask your SwiftLaw admin to mint one
for you.)

## Usage

```bash
swiftlaw                       # interactive REPL
#  › /open ~/path/to/lpa.docx  load a document
#  › raise the management fee to 2.5%   review the redline (accept / deny / talk)
#  › /save
#  › /funds · /entity · /keyterms       backend-synced features
```

Run `/help` inside the REPL for the full command list.

---

_Releases (binaries + this formula) are published here automatically by the
SwiftLaw-Prod release pipeline. The app repo is private, so this public tap repo
hosts the downloadable binaries._
