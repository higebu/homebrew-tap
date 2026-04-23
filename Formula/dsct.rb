class Dsct < Formula
  desc "LLM-friendly packet dissector CLI"
  homepage "https://github.com/higebu/dsct"
  version "0.2.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/higebu/dsct/releases/download/v0.2.10/dsct-aarch64-apple-darwin.tar.xz"
      sha256 "8ca402a33b1cde1fe38afe98f79ed9de065982a2acbcf8cf34d5dc46f2a690a3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/higebu/dsct/releases/download/v0.2.10/dsct-x86_64-apple-darwin.tar.xz"
      sha256 "bcf07d25b54c4408f8793ac21bdce608698a46ff99b2c6161cfb1a5ddc89e26b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/higebu/dsct/releases/download/v0.2.10/dsct-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a4224efa27f6ba519d5b887fb6c5dd87e896d9c316fb04adeb7c56a8dbc50f18"
    end
    if Hardware::CPU.intel?
      url "https://github.com/higebu/dsct/releases/download/v0.2.10/dsct-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "69fef3771fea96eb4b61548aa2e999bb80350cedc69e3d81a015186badebccc0"
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
