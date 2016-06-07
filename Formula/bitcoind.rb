class Bitcoind < Formula
  desc "A decentralized, peer to peer payment network"
  homepage "https://bitcoin.org/"
  url "https://github.com/bitcoin/bitcoin/archive/v0.12.1.tar.gz"
  sha256 "7bdc287575067461c123e1afcb48843f9f78eb5e6cac95b413e2e09f1f7fc7bd"

  head do
    url "https://github.com/bitcoin/bitcoin.git"

    depends_on "libevent"
  end

  conflicts_with "bitcoinclassic", :because => "bitcoinclassic also ships a bitcoind binary"
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
