class Dsct < Formula
  desc "LLM-friendly packet dissector CLI"
  homepage "https://github.com/higebu/dsct"
  version "0.2.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/higebu/dsct/releases/download/v0.2.14/dsct-aarch64-apple-darwin.tar.xz"
      sha256 "4c37e3f7229ab28b491c77d13a5d53f5c3734ce9c3bc9d30c24eee743785de39"
    end
    if Hardware::CPU.intel?
      url "https://github.com/higebu/dsct/releases/download/v0.2.14/dsct-x86_64-apple-darwin.tar.xz"
      sha256 "738cd6caf18e7c9f53778dfdc77586d19df6ef4972c7535edad968b6210e2184"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/higebu/dsct/releases/download/v0.2.14/dsct-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0f34f533d7ee03c866ed8ffd6e7127463e91eb51bf99499f811ae38bfb599116"
    end
    if Hardware::CPU.intel?
      url "https://github.com/higebu/dsct/releases/download/v0.2.14/dsct-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "51c7ff65be27b6de30999704e8439df688568eed1f5eb932da184d156e9d3c8e"
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
