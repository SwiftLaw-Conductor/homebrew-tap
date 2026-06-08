# SwiftLaw Homebrew formula.
#
# Source of truth lives in the CLI repo at packaging/homebrew/swiftlaw.rb.
# On each release, copy this file to the tap repo
# (SwiftLaw-Conductor/homebrew-tap) at Formula/swiftlaw.rb with the url + sha256
# updated to the new release. Users then install with:
#
#   brew install SwiftLaw-Conductor/tap/swiftlaw
#
class Swiftlaw < Formula
  desc "A law firm in your CLI — agentic legal assistant (drafts, edits, redlines, researches)"
  homepage "https://github.com/SwiftLaw-Conductor/cli"
  # Hosted on the PUBLIC tap repo's releases: the cli repo is INTERNAL, so its
  # release assets aren't downloadable by Homebrew's unauthenticated fetch.
  url "https://github.com/SwiftLaw-Conductor/homebrew-tap/releases/download/v0.1.0/swiftlaw-0.1.0.tar.gz"
  sha256 "2954e6b68a9eeda3faa456b8897b661e352e9976215013c9547d20aa05481a06"
  version "0.1.0"
  license :cannot_represent # proprietary — © SwiftLaw

  depends_on "node"
  depends_on "uv"

  def install
    # The release tarball is a self-contained bundle: dist/, assets/,
    # package.json, and a production node_modules (incl. @swiftlaw/core).
    libexec.install Dir["*"]

    # Wrapper that runs the bundled CLI on the brewed Node so it never depends
    # on whatever Node the user may (or may not) have on PATH.
    (bin/"swiftlaw").write <<~SH
      #!/bin/bash
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/dist/index.js" "$@"
    SH
    chmod 0755, bin/"swiftlaw"
  end

  def caveats
    <<~EOS
      SwiftLaw needs an Anthropic API key and provisions a Python document
      engine on first run (via uv, installed as a dependency). Get started:

        swiftlaw init

      Keys live in ~/.swiftlaw/config.json (or the ANTHROPIC_API_KEY env var).
    EOS
  end

  test do
    # --version is handled locally (no API call, no engine bootstrap), so this
    # is a safe, hermetic smoke test of the bundle + wrapper.
    assert_match version.to_s, shell_output("#{bin}/swiftlaw --version")
  end
end
