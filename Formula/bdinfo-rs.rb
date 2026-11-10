class BdinfoRs < Formula
  desc "bdinfo-rs — a memory-safe command-line Blu-ray analyzer (no GUI)."
  homepage "https://github.com/agentjp/bdinfo-rs"
  version "5.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v5.0.0/bdinfo-rs-aarch64-apple-darwin.tar.gz"
      sha256 "7e8ca93d56b396e080ec080eb2c18c4e9d0138c358462460d91c0ce24b7871e5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v5.0.0/bdinfo-rs-x86_64-apple-darwin.tar.gz"
      sha256 "121d1dbd85277b9128dc17d7a6ea4cbe43995fda6b531dfac3938aba69402990"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v5.0.0/bdinfo-rs-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9b33d80fdd2fe6b001b1f70f0c1ce32882c349ee922505987df43c48f9b55db1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v5.0.0/bdinfo-rs-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1533c1abdc88fc557b50a6cee6255d1769b7d5998581a64a2417f3f1a8a0c184"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "bdinfo-rs"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "bdinfo-rs"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "bdinfo-rs"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "bdinfo-rs"
    end

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
