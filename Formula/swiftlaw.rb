# SwiftLaw Homebrew formula — SOURCE TEMPLATE.
#
# The release workflow (.github/workflows/release-cli.yml) substitutes the
# version + per-arch sha256 placeholders with the real release values and pushes
# the result to the public tap repo (SwiftLaw-Conductor/homebrew-tap) as
# Formula/swiftlaw.rb. Edit THIS file to change the formula; the tap copy is
# generated. Placeholders are unique per arch so a simple sed can target each.
#
#   brew install SwiftLaw-Conductor/tap/swiftlaw
#
# The binaries are self-contained native executables (Bun-compiled) — no Node,
# no Python, no Anthropic key. The CLI authenticates to the SwiftLaw backend
# with a personal CLI token and proxies model inference through it, so end users
# need NO AWS credentials. Hosted on the PUBLIC tap repo's releases because the
# app repo is private.
class Swiftlaw < Formula
  desc "A law firm in your CLI — agentic legal assistant (drafts, edits, redlines)"
  homepage "https://github.com/SwiftLaw-Conductor/homebrew-tap"
  version "0.2.1"
  license :cannot_represent # proprietary — © SwiftLaw

  on_macos do
    on_arm do
      url "https://github.com/SwiftLaw-Conductor/homebrew-tap/releases/download/cli-v0.2.1/swiftlaw-darwin-arm64"
      sha256 "e01af4189980c28393c961bda35f8c6250e4b6897b204586bd152db5dca7a9ff"
    end
    on_intel do
      url "https://github.com/SwiftLaw-Conductor/homebrew-tap/releases/download/cli-v0.2.1/swiftlaw-darwin-x64"
      sha256 "18c3981f8a717f92b4a23daf536fbe645d4a3f0b5f9178a38b259454135f7b51"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/SwiftLaw-Conductor/homebrew-tap/releases/download/cli-v0.2.1/swiftlaw-linux-x64"
      sha256 "d63a2aa270fc9adad42e33042f3118a506ade806aab33fefa7ae26340bbbe74f"
    end
  end

  def install
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
    assert_match version.to_s, shell_output("#{bin}/swiftlaw --version")
  end
end
