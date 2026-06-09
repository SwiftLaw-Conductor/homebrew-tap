# SwiftLaw Homebrew formula.
#
# AUTO-GENERATED on release by .github/workflows/release-cli.yml in the
# SwiftLaw-Prod repo (it compiles the per-platform binaries, publishes them as
# a GitHub Release on THIS public tap repo, and rewrites this file with the new
# version + per-arch sha256). Hand-edits will be overwritten on the next release.
#
#   brew install SwiftLaw-Conductor/tap/swiftlaw
#
# The binaries are self-contained native executables (Bun-compiled) — no Node,
# no Python, no Anthropic key. The CLI authenticates to the SwiftLaw backend
# with a personal CLI token and proxies model inference through it, so end users
# need NO AWS credentials. Hosted on the PUBLIC tap repo's releases because the
# app repo is private (Homebrew's unauthenticated fetch can't reach private
# release assets).
class Swiftlaw < Formula
  desc "A law firm in your CLI — agentic legal assistant (drafts, edits, redlines)"
  homepage "https://github.com/SwiftLaw-Conductor/homebrew-tap"
  version "0.1.0"
  license :cannot_represent # proprietary — © SwiftLaw

  on_macos do
    on_arm do
      url "https://github.com/SwiftLaw-Conductor/homebrew-tap/releases/download/cli-v0.1.0/swiftlaw-darwin-arm64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
    on_intel do
      url "https://github.com/SwiftLaw-Conductor/homebrew-tap/releases/download/cli-v0.1.0/swiftlaw-darwin-x64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/SwiftLaw-Conductor/homebrew-tap/releases/download/cli-v0.1.0/swiftlaw-linux-x64"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000"
    end
  end

  def install
    # Single pre-compiled binary; Homebrew stages it under its arch-specific
    # name. Rename to `swiftlaw` on the user's PATH.
    bin.install Dir["swiftlaw-*"].first => "swiftlaw"
  end

  def caveats
    <<~EOS
      Authenticate the CLI with a personal token, then you're set:

        swiftlaw login        # paste an sl_… token from the web app
                              # (tryswiftlaw.com/app → avatar → CLI Tokens)
        swiftlaw              # interactive

      No AWS, Node, or API keys needed — inference is proxied through the
      SwiftLaw backend. The token lives in ~/.swiftlaw/config.json.
    EOS
  end

  test do
    # --version is hermetic (no network, no login), so this is a safe smoke test.
    assert_match version.to_s, shell_output("#{bin}/swiftlaw --version")
  end
end
