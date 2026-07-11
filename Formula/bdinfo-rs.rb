class BdinfoRs < Formula
  desc "bdinfo-rs — a memory-safe command-line Blu-ray analyzer (no GUI)."
  homepage "https://github.com/agentjp/bdinfo-rs"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v1.2.0/bdinfo-rs-aarch64-apple-darwin.tar.gz"
      sha256 "2d9fa2114ec3c06fa65f203d0566e81f496b7375e3f951cf7d5a6cdefb04fb63"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v1.2.0/bdinfo-rs-x86_64-apple-darwin.tar.gz"
      sha256 "71c8464d196f4cc95e51c0e13c5fea6a892829c30c67a174929fe0a840ebe621"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v1.2.0/bdinfo-rs-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3191ebb7f9634baf17c317c89cc486474d5d5539d5258160fc60218c8c061453"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v1.2.0/bdinfo-rs-x86_64-unknown-linux-musl.tar.gz"
      sha256 "cdff0a3114a8658a1acd6541402047dcd88309f743d577bcc7b552333b48bb5a"
    end
  end
  license "LGPL-2.1-or-later"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-pc-windows-gnu":             {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "bdinfo-rs" if OS.mac? && Hardware::CPU.arm?
    bin.install "bdinfo-rs" if OS.mac? && Hardware::CPU.intel?
    bin.install "bdinfo-rs" if OS.linux? && Hardware::CPU.arm?
    bin.install "bdinfo-rs" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!
    man1.install "bdinfo-rs.1"
    bash_completion.install "bdinfo-rs.bash" => "bdinfo-rs"
    zsh_completion.install "_bdinfo-rs"
    fish_completion.install "bdinfo-rs.fish"

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
