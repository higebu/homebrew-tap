class Dsct < Formula
  desc "LLM-friendly packet dissector CLI"
  homepage "https://github.com/higebu/dsct"
  version "0.2.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/higebu/dsct/releases/download/v0.2.8/dsct-aarch64-apple-darwin.tar.xz"
      sha256 "6a5abaded24edb046b825876c20cb650c75b97d7ffa01b3af1c28700007bf70a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/higebu/dsct/releases/download/v0.2.8/dsct-x86_64-apple-darwin.tar.xz"
      sha256 "64bab18af2d3fe1119fe799eb72333807cd0f1c2246f475aa6a6cab8895541aa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/higebu/dsct/releases/download/v0.2.8/dsct-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e13e2f1b2c6efdfaa17eea719b22ebb1c33f39cdf9075773b49d2e041d4b91f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/higebu/dsct/releases/download/v0.2.8/dsct-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c65825d46e78ba48af5aa547cfb51ff951fd5b6394ce4876b258c0ed4bc7a4e5"
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
