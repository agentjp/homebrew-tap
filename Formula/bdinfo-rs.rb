class BdinfoRs < Formula
  desc "Memory-safe command-line Blu-ray disc analyzer (BDInfo drop-in)"
  homepage "https://github.com/agentjp/bdinfo-rs"
  version "1.0.0"
  license "LGPL-2.1-only"

  on_macos do
    on_arm do
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v1.0.0/bdinfo-rs-aarch64-apple-darwin.tar.gz"
      sha256 "c57cd3e037bdebec1cc7fcbc0fc9445b288f4d377f92580b5fc91b77858ae9dc"
    end
    on_intel do
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v1.0.0/bdinfo-rs-x86_64-apple-darwin.tar.gz"
      sha256 "2cc8d4709be7ac291d81f0aee1f136854502425e8c8a05929b4231247a60716b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v1.0.0/bdinfo-rs-aarch64-unknown-linux-musl.tar.gz"
      sha256 "58908f2978b22423cf8bdaf3ae4828ead02a5a080ed3251b91aadf913d6b6302"
    end
    on_intel do
      url "https://github.com/agentjp/bdinfo-rs/releases/download/v1.0.0/bdinfo-rs-x86_64-unknown-linux-musl.tar.gz"
      sha256 "20dc1890e6c7990200f7cccbdaaa30e402a859ea673140c208dbea655c37981d"
    end
  end

  def install
    bin.install "bdinfo-rs"
    man1.install "bdinfo-rs.1"
    bash_completion.install "bdinfo-rs.bash" => "bdinfo-rs"
    zsh_completion.install "_bdinfo-rs"
    fish_completion.install "bdinfo-rs.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bdinfo-rs --version")
  end
end
