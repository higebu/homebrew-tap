class Dsct < Formula
  desc "LLM-friendly packet dissector CLI"
  homepage "https://github.com/higebu/dsct"
  version "0.2.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/higebu/dsct/releases/download/v0.2.13/dsct-aarch64-apple-darwin.tar.xz"
      sha256 "311e2c013b2d3649edd0f07fa791bd3554f0600be00986aa4ac48aecb82e2528"
    end
    if Hardware::CPU.intel?
      url "https://github.com/higebu/dsct/releases/download/v0.2.13/dsct-x86_64-apple-darwin.tar.xz"
      sha256 "b923384a915804d932b53c3c7cf3671b45eefa5367005c7dada1be27e2f6eb68"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/higebu/dsct/releases/download/v0.2.13/dsct-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "82db441c21e1ed2e9890a38e0ca834a25abd32e7098ca98f2e38c766c1e6f0a7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/higebu/dsct/releases/download/v0.2.13/dsct-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9b71df23718b32160a42d5a7b8f73971572efbbd97332270ac17553757948590"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
      bin.install "dsct"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "dsct"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "dsct"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "dsct"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
