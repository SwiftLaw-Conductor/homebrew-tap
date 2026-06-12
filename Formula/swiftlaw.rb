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
  version "0.9.1"
  license :cannot_represent # proprietary — © SwiftLaw

  on_macos do
    on_arm do
      url "https://github.com/SwiftLaw-Conductor/homebrew-tap/releases/download/cli-v0.9.1/swiftlaw-darwin-arm64"
      sha256 "5f68089ba283f5b77df43a7e5ff1eb37adbea934138675e6a0921a1705ecb5bc"
    end
    on_intel do
      url "https://github.com/SwiftLaw-Conductor/homebrew-tap/releases/download/cli-v0.9.1/swiftlaw-darwin-x64"
      sha256 "5c895f2ac07e068107a6acf5f7eb238d00879708342f85214ae3c65c673ce910"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/SwiftLaw-Conductor/homebrew-tap/releases/download/cli-v0.9.1/swiftlaw-linux-x64"
      sha256 "22bd03a643a494000b6c9ac6fea0b134258cf0ec74f25bc74fe82c4d8021bf25"
    end
  end

  def install
    bin.install Dir["swiftlaw-*"].first => "swiftlaw"
  end

  def caveats
    <<~EOS
      Get started:

        swiftlaw login   # paste a token from https://tryswiftlaw.com/app/settings/cli-tokens
        swiftlaw         # start

      No AWS, Node, or API keys needed.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/swiftlaw --version")
  end
end
