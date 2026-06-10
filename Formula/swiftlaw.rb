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
  version "0.3.0"
  license :cannot_represent # proprietary — © SwiftLaw

  on_macos do
    on_arm do
      url "https://github.com/SwiftLaw-Conductor/homebrew-tap/releases/download/cli-v0.3.0/swiftlaw-darwin-arm64"
      sha256 "e59381dfd37b85faf2aedc6303d253e8f0552528898b34dd28aa8e3c31887374"
    end
    on_intel do
      url "https://github.com/SwiftLaw-Conductor/homebrew-tap/releases/download/cli-v0.3.0/swiftlaw-darwin-x64"
      sha256 "7aeab01866173b23e19d4aec5bb8d13d958bea8aa29accc86c4175c2671a2945"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/SwiftLaw-Conductor/homebrew-tap/releases/download/cli-v0.3.0/swiftlaw-linux-x64"
      sha256 "77c93006014ef2d81f99e8b23d86fe9046a4275b259d1b7262e496061d6a342d"
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
