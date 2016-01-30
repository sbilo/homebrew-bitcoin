class Bitcoinclassic < Formula
  desc "A decentralized, peer to peer payment network"
  homepage "https://bitcoinclassic.com/"
  url "https://github.com/bitcoinclassic/bitcoinclassic/archive/v0.11.2.zip"
  version "0.11.2"
  sha256 "2894cbe8d2a0ea61d4c0974f7525a973e1ce1883d32c8b5af57dba1bcbae1f9f"

  head do
    url "https://github.com/bitcoinclassic/bitcoinclassic.git"

    depends_on "libevent"
  end

  conflicts_with "bitcoind", :because => "bitcoind also ships a bitcoind binary"
  conflicts_with "bitcoinxt", :because => "bitcoinxt also ships a bitcoind binary"

  option "with-gui", "Build the GUI client (requires Qt5)"

  depends_on :macos => :lion
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on :xcode => :build
  depends_on "berkeley-db4"
  depends_on "boost"
  depends_on "openssl"
  depends_on "miniupnpc" => :recommended

  if build.with? "gui"
    depends_on "qt5"
    depends_on "protobuf"
    depends_on "qrencode"
    depends_on "gettext" => :recommended
  end

  def install
    args = ["--prefix=#{libexec}", "--disable-dependency-tracking"]

    if build.with? "gui"
      args << "--with-qrencode"
    end

    args << "--without-miniupnpc" if build.without? "miniupnpc"

    system "./autogen.sh"
    system "./configure", *args

    system "make"
    system "make", "install"
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end
