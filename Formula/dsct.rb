class Dsct < Formula
  desc "LLM-friendly packet dissector CLI"
  homepage "https://github.com/higebu/dsct"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/higebu/dsct/releases/download/v0.2.3/dsct-aarch64-apple-darwin.tar.xz"
      sha256 "2f5d5fb2eab05c69afef39b7df8ce8895b81818ad7b92f4c87c79a608c17e761"
    end
    if Hardware::CPU.intel?
      url "https://github.com/higebu/dsct/releases/download/v0.2.3/dsct-x86_64-apple-darwin.tar.xz"
      sha256 "be2cb950c2607baa42261487854c252ae418bb8b7b51b3d38144e253aef2afc9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/higebu/dsct/releases/download/v0.2.3/dsct-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d53b33b080dda2a7f678f88b47c5a2e1f70172a91cd4c81975859443db718576"
    end
    if Hardware::CPU.intel?
      url "https://github.com/higebu/dsct/releases/download/v0.2.3/dsct-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "216c4348be0008f822ec04564595dc60dc0fea3636e140b48e955120a8758a12"
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
