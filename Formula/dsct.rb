class Dsct < Formula
  desc "LLM-friendly packet dissector CLI"
  homepage "https://github.com/higebu/dsct"
  version "0.2.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/higebu/dsct/releases/download/v0.2.11/dsct-aarch64-apple-darwin.tar.xz"
      sha256 "bc5c42d879c20dfe43bc38f51f79211fa16a6e750453d7aa7d9af4ddabb96102"
    end
    if Hardware::CPU.intel?
      url "https://github.com/higebu/dsct/releases/download/v0.2.11/dsct-x86_64-apple-darwin.tar.xz"
      sha256 "ab4138464fe0e5cda575134ca4f5f350a7212e7633d73f5d473010a9abf9b492"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/higebu/dsct/releases/download/v0.2.11/dsct-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e4a0d3bb61a9f17ab2b19a9a1861810b845fe49017415e145b7d951f92f6f14f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/higebu/dsct/releases/download/v0.2.11/dsct-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d2871e10edfd375f5950062f3063102fe4afc489eb23cb011b95e6a2538f3ef7"
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
