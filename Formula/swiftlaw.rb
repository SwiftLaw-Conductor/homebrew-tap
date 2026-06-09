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
  version "0.2.0"
  license :cannot_represent # proprietary — © SwiftLaw

  on_macos do
    on_arm do
      url "https://github.com/SwiftLaw-Conductor/homebrew-tap/releases/download/cli-v0.2.0/swiftlaw-darwin-arm64"
      sha256 "48896caa841711fdc8d6a4fe47fe8af2c3fd7471dd98d264b0f38a35bf224fdb"
    end
    on_intel do
      url "https://github.com/SwiftLaw-Conductor/homebrew-tap/releases/download/cli-v0.2.0/swiftlaw-darwin-x64"
      sha256 "810d6064f975efa4703616c193fdc64b6be498f4eacbecb5578e3a67f35cb04b"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/SwiftLaw-Conductor/homebrew-tap/releases/download/cli-v0.2.0/swiftlaw-linux-x64"
      sha256 "14a548abd0a3e187ebcb431f4abc6019c786e49aa677500590f46ea5742dbd91"
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
