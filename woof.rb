# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Woof < Formula
  desc ""
  homepage ""

  if Hardware::CPU.arm?
    url "https://github.com/gplassard/woof/releases/download/v0.0.6/woof_Darwin_arm64.tar.gz"
    sha256 "bf9055d1407dcd0d7724936f5bdc4fee741bbbb6c3787dcbf602c826da0f002c"
  else
    url "https://github.com/gplassard/woof/releases/download/v0.0.6/woof_Darwin_x86_64.tar.gz"
    sha256 "3202023a2b5fa37e18e5cbaee3027cac53cdb97867e3d29928777c60d968855d"
  end

  license ""

  def install
    bin.install "woof"
  end

  test do
    system "#{bin}/woof", "--help"
  end
end
