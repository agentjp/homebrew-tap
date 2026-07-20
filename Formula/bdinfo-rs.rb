class BdinfoRs < Formula
  desc "bdinfo-rs — a memory-safe command-line Blu-ray analyzer (no GUI)."
  homepage "https://github.com/agentjp/bdinfo-rs"
  version "2.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v2.0.0/bdinfo-rs-aarch64-apple-darwin.tar.gz"
      sha256 "a1050075b96ea7789d086a744917535f1000707268c355b93ffa10073f71744f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v2.0.0/bdinfo-rs-x86_64-apple-darwin.tar.gz"
      sha256 "ade1bee1ff99d42b46fc3fa62baa3f8111a713df370674e53a5338532d4d7bdc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v2.0.0/bdinfo-rs-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c6231760f37c3819392d3d764f2a933bbfdca7d46ba5d836daedf0206b8f8837"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v2.0.0/bdinfo-rs-x86_64-unknown-linux-musl.tar.gz"
      sha256 "805c06d8cb14ee1e6ce03e6d703eecc511525ba781bee6a2fe2afe2f66bdf7c8"
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
