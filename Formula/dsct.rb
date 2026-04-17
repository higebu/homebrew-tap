class Dsct < Formula
  desc "LLM-friendly packet dissector CLI"
  homepage "https://github.com/higebu/dsct"
  version "0.2.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/higebu/dsct/releases/download/v0.2.9/dsct-aarch64-apple-darwin.tar.xz"
      sha256 "7cda0e93c76dbc3968a34dfe9d2766d7a8056ae3b001bb7536a42a94af198509"
    end
    if Hardware::CPU.intel?
      url "https://github.com/higebu/dsct/releases/download/v0.2.9/dsct-x86_64-apple-darwin.tar.xz"
      sha256 "a05c85d65ad02cc77035c08a974d832ab83dfd33de4a8ad08fe2316ddbf99e82"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/higebu/dsct/releases/download/v0.2.9/dsct-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1e78495c9a8dd83d8636d2e3368ba9cd6b1e3c5668f6fadccdae2e141e70940d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/higebu/dsct/releases/download/v0.2.9/dsct-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3aff0a22abe411b792f862d4f8f0c7f662ee2d0187cbc2da7b07a67d32aeff84"
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
    bin.install "dsct" if OS.mac? && Hardware::CPU.arm?
    bin.install "dsct" if OS.mac? && Hardware::CPU.intel?
    bin.install "dsct" if OS.linux? && Hardware::CPU.arm?
    bin.install "dsct" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
