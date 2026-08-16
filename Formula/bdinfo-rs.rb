class BdinfoRs < Formula
  desc "bdinfo-rs — a memory-safe command-line Blu-ray analyzer (no GUI)."
  homepage "https://github.com/agentjp/bdinfo-rs"
  version "4.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v4.0.0/bdinfo-rs-aarch64-apple-darwin.tar.gz"
      sha256 "1effdb7cf2581c5cd9f30de2ded7085c86bb8a839226017b68b319d9cd96cff0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v4.0.0/bdinfo-rs-x86_64-apple-darwin.tar.gz"
      sha256 "18b53936602a5b85d33c38081530d03b145fd5aa24b03ae3bafb9373449f8a60"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v4.0.0/bdinfo-rs-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c1de7400f06525be2dce9193ec873bdb3dec0cee0f888b754bc6b79dd42bc342"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v4.0.0/bdinfo-rs-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f1806556e0b65454ebf97dcc3a34d76b91d9894e9e4de30775fee8bf26e3fc82"
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
