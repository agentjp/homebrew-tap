class BdinfoRs < Formula
  desc "bdinfo-rs — a memory-safe command-line Blu-ray analyzer (no GUI)."
  homepage "https://github.com/agentjp/bdinfo-rs"
  version "3.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v3.0.0/bdinfo-rs-aarch64-apple-darwin.tar.gz"
      sha256 "e3271d2e73f3fc2179fd4bbb30968ebfb6a8e53d04011197e4c2d4fd927ff919"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v3.0.0/bdinfo-rs-x86_64-apple-darwin.tar.gz"
      sha256 "461e55044d6a493864d8d5b8a11710182b58f7af94900bac56c02d1d18bfe49b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v3.0.0/bdinfo-rs-aarch64-unknown-linux-musl.tar.gz"
      sha256 "adc1270f01fcb70f3c1cb89f409d09fef89aaf50a5f2ec11b2c24c74b847b1c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v3.0.0/bdinfo-rs-x86_64-unknown-linux-musl.tar.gz"
      sha256 "d9d8ccb2c359d48c5edf513426f7e8c2966c53563897eadec665d700c5daa84c"
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
