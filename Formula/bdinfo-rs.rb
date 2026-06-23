class BdinfoRs < Formula
  desc "bdinfo-rs — a memory-safe command-line Blu-ray analyzer (no GUI)."
  homepage "https://github.com/agentjp/bdinfo-rs"
  version "1.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v1.0.1/bdinfo-rs-aarch64-apple-darwin.tar.gz"
      sha256 "808f0ccf108f03822ebc4f38163c8f69befae9ce6be73ac0658ebcd6df208aba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v1.0.1/bdinfo-rs-x86_64-apple-darwin.tar.gz"
      sha256 "902fed5c350a3981142fcc8dc5bfcf7125d0248de2463d16122f3b81c48c6051"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v1.0.1/bdinfo-rs-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7401567ccce7dfd3baad8a56ef559a14fef2b821ef0e4c6a49072287a978936f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v1.0.1/bdinfo-rs-x86_64-unknown-linux-musl.tar.gz"
      sha256 "251fc415c05136ba7ac783064d09e12b1a807999e3de8195ed62c98c18aad899"
    end
  end
  license "LGPL-2.1-only"

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
