# typed: strict
# frozen_string_literal: true

# Cask for the agentjp/homebrew-tap third-party tap. The `gui-publish.yml`
# homebrew leg replaces 5.0.0 / 94aeeea6c2934a7ff063bedd53e8b5f686168e22bfe29d52eb1cdb2f51fbcd95 / d82e4a5f0169db4791fc1420cc17ec6ddf267934d97e83315eb075b640b2b76f from the
# release's verified SHA256SUMS and commits the result to the tap as
# Casks/bdinfo-rs-gui.rb — one commit per release, like the CLI formula.
#
# The app is ad-hoc signed and never notarized, which is why this lives in our
# own tap — homebrew/cask rejects apps that need Gatekeeper bypassed,
# third-party taps are exempt from that audit — and why the caveats walk the
# user past the first-launch block.
cask "bdinfo-rs-gui" do
  arch arm: "aarch64", intel: "x86_64"

  version "5.0.0"
  sha256 arm:   "94aeeea6c2934a7ff063bedd53e8b5f686168e22bfe29d52eb1cdb2f51fbcd95",
         intel: "d82e4a5f0169db4791fc1420cc17ec6ddf267934d97e83315eb075b640b2b76f"

  url "https://github.com/agentjp/bdinfo-rs/releases/download/gui-v#{version}/bdinfo-rs-gui-#{arch}-apple-darwin.dmg"
  name "bdinfo-rs GUI"
  desc "Native desktop app for the bdinfo-rs Blu-ray disc analyzer"
  homepage "https://github.com/agentjp/bdinfo-rs"

  # The repo's releases interleave the CLI's v* tags with the GUI's gui-v*;
  # the anchored regex keeps livecheck on the GUI lane.
  livecheck do
    url :url
    regex(/^gui-v(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  app "bdinfo-rs GUI.app"

  zap trash: [
    "~/Library/Application Support/bdinfo-rs",
    "~/Library/Caches/io.github.agentjp.bdinfo-rs-gui",
    "~/Library/Preferences/io.github.agentjp.bdinfo-rs-gui.plist",
    "~/Library/Saved Application State/io.github.agentjp.bdinfo-rs-gui.savedState",
  ]

  caveats <<~EOS
    bdinfo-rs GUI is ad-hoc signed and not notarized, so macOS Gatekeeper
    blocks the first launch — on newer macOS the dialog may claim the app
    "is damaged". Allow it under System Settings → Privacy & Security →
    "Open Anyway", or clear the quarantine flag:

      xattr -d com.apple.quarantine "#{appdir}/bdinfo-rs GUI.app"
  EOS
end
