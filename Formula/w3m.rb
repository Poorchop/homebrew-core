class W3m < Formula
  desc "Pager/text based browser"
  homepage "https://w3m.sourceforge.io/"
  revision 7
  head "https://github.com/tats/w3m.git"

  stable do
    url "https://deb.debian.org/debian/pool/main/w/w3m/w3m_0.5.3.orig.tar.gz"
    sha256 "e994d263f2fd2c22febfbe45103526e00145a7674a0fda79c822b97c2770a9e3"

    # Upstream is effectively Debian https://github.com/tats/w3m at this point.
    # The patches fix a pile of CVEs
    patch do
      url "https://deb.debian.org/debian/pool/main/w/w3m/w3m_0.5.3-38.debian.tar.xz"
      sha256 "227dd8d27946f21186d74ac6b7bcf148c37d97066c7ccded16495d9e22520792"
      apply "patches/010_upstream.patch",
            "patches/020_debian.patch"
    end
  end

  livecheck do
    url "https://deb.debian.org/debian/pool/main/w/w3m/"
    regex(/href=.*?w3m[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "ca603325cc6d0904d5d709f6e9407b26fd22e3eeb3984d38e11c21d8f45e7b3a"
    sha256 big_sur:       "9865fb7a43e8732bb7d309502c3de3410d05aeb093ba8916462b5aab36563a5a"
    sha256 catalina:      "5b752461983a608c684bae9efa13a0a5e37a456def0b368c8b0706b35fd480a3"
    sha256 mojave:        "a77f9a7ceee4dbb2a7288ecfad9c903c489ce4a60ff10056cd735433986df901"
  end

  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "openssl@1.1"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gettext"
    depends_on "libbsd"
  end

  def install
    # Work around configure issues with Xcode 12
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    system "./configure", "--prefix=#{prefix}",
                          "--enable-image",
                          "--enable-gopher",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match "DuckDuckGo", shell_output("#{bin}/w3m -dump https://duckduckgo.com")
  end
end
