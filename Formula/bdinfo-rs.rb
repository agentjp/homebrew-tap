class BdinfoRs < Formula
  desc "bdinfo-rs — a memory-safe command-line Blu-ray analyzer (no GUI)."
  homepage "https://github.com/agentjp/bdinfo-rs"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v1.1.0/bdinfo-rs-aarch64-apple-darwin.tar.gz"
      sha256 "b2cd9517ac6ff706656c289a7107dbf8d394990b82f2a237e48889633070f139"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v1.1.0/bdinfo-rs-x86_64-apple-darwin.tar.gz"
      sha256 "d7ea266a7c2073ed921ba4fb6e62b0cf64fb4613203bfa61d4d6f3eef3fabdec"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v1.1.0/bdinfo-rs-aarch64-unknown-linux-musl.tar.gz"
      sha256 "53b36226bf51619e906b344ceeaafc535158944aa968b9ee648495f60bf3a469"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v1.1.0/bdinfo-rs-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6b4b2c7e943b58d2041681e7b6d4bdf13ec6babd00b83c441728405a658c31f0"
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
