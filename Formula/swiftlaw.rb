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
  version "0.1.0"
  license :cannot_represent # proprietary — © SwiftLaw

  on_macos do
    on_arm do
      url "https://github.com/SwiftLaw-Conductor/homebrew-tap/releases/download/cli-v0.1.0/swiftlaw-darwin-arm64"
      sha256 "931e4897c1db179d82a4d873071d6dad15d5cb3b78a09de52963d8a25831658f"
    end
    on_intel do
      url "https://github.com/SwiftLaw-Conductor/homebrew-tap/releases/download/cli-v0.1.0/swiftlaw-darwin-x64"
      sha256 "05f98c8222e3bae15e2709cc6d77bba2f6400ea05cbe9eebd28d2b0f343f8615"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/SwiftLaw-Conductor/homebrew-tap/releases/download/cli-v0.1.0/swiftlaw-linux-x64"
      sha256 "3a97e23e076ce53a1badabc48bd9c964d2b2dd30313304bbf5ce65a543545816"
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
