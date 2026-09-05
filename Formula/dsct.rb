class Dsct < Formula
  desc "LLM-friendly packet dissector CLI"
  homepage "https://github.com/higebu/dsct"
  version "0.2.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/higebu/dsct/releases/download/v0.2.12/dsct-aarch64-apple-darwin.tar.xz"
      sha256 "187a02d7628fb926eb671173b0d4132ea640b61b3f959bf78c5e6c44ee0b68e5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/higebu/dsct/releases/download/v0.2.12/dsct-x86_64-apple-darwin.tar.xz"
      sha256 "bf76dd677246f9f40ccfc23be4e11ac9c176a91f8fbd9d058e8f07e645131d00"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/higebu/dsct/releases/download/v0.2.12/dsct-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "22b14c200738e58d0ca504904b9133306ecb6fe76718c5abc66d93b3340bc036"
    end
    if Hardware::CPU.intel?
      url "https://github.com/higebu/dsct/releases/download/v0.2.12/dsct-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "23bed4fe1701a771916f78408af6a80edca1276f5a2adf7e0983511bc6fa337e"
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
