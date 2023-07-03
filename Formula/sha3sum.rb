class Sha3sum < Formula
  desc "Keccak, SHA-3, SHAKE, and RawSHAKE checksum utilities"
  homepage "https://codeberg.org/maandree/sha3sum"
  url "https://codeberg.org/maandree/sha3sum/archive/1.2.3.tar.gz"
  sha256 "507140ec7d558db70861057d7099819201a866b4c5824f80963e62c10a0081b4"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e42f36eecf74bfee4472e8221c95fe2196bbbe85eb96e8d6ed0ed22431f0255e"
    sha256 cellar: :any,                 arm64_monterey: "a71bf2beb54a0ec5ef6defe1651d404239b16aa724cfc11e56c7a479dd5afd45"
    sha256 cellar: :any,                 arm64_big_sur:  "6a982032346aa17ceb4d050e6dd1334a4428039883036758e514f14d6c9b2c6c"
    sha256 cellar: :any,                 ventura:        "c4c02d6d52aa7dc740918c370d456a4984dcea6afb4ef1fc48cd905dfc10f8fb"
    sha256 cellar: :any,                 monterey:       "3db74567332ebcf2abe80d544df93b937bdff3ff4a593491265c647c23926aae"
    sha256 cellar: :any,                 big_sur:        "96f9780c5cb6ee06dbcca4b28eabbc7e92a4ae705db98a3f3ab66366280f1200"
    sha256 cellar: :any,                 catalina:       "23d79754d2579e0ea0bd2757dbf6f8f47ae2f093dfa54f4869e437f7ee0ab73a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9eff34d53d4a0f794bcd8303ad66ff23056a1a3f89b56bf737dae3689e5cb6f4"
  end

  depends_on "libkeccak"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  def install
    # Makefile requires GNU sed as of version 1.2.3
    # See https://codeberg.org/maandree/sha3sum/issues/1
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin" if OS.mac?

    # GNU make builtin rules specify link flags in the wrong order
    # See https://codeberg.org/maandree/sha3sum/issues/2
    system "make", "--no-builtin-rules", "install", "PREFIX=#{prefix}"
    inreplace "test", "./", "#{bin}/"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test", testpath
    system "./test"
  end
end
