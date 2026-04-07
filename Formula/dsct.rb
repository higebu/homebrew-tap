class Dsct < Formula
  desc "LLM-friendly packet dissector CLI"
  homepage "https://github.com/higebu/dsct"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/higebu/dsct/releases/download/v0.2.2/dsct-aarch64-apple-darwin.tar.xz"
      sha256 "742bf3980cb64aa0ef94999419c0ac78a4a43a4920d5bee19d31df2da5bc5bf7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/higebu/dsct/releases/download/v0.2.2/dsct-x86_64-apple-darwin.tar.xz"
      sha256 "5239fe5bb32bf11aea4cfd6aa0b80f7abb24a0644e63690aefeca49bbd290218"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/higebu/dsct/releases/download/v0.2.2/dsct-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5e61765acf35e15842b85a6b1803cedf49eb4d3f896b55bbf492349dc75eb532"
    end
    if Hardware::CPU.intel?
      url "https://github.com/higebu/dsct/releases/download/v0.2.2/dsct-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b7f8d9b02f79942a1158cf80977a1c641c4e06b9b7fe29aed101af21caff5e64"
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
