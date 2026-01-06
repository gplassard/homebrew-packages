# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Woof < Formula
  desc ""
  homepage ""

  if Hardware::CPU.arm?
    url "https://github.com/gplassard/woof/releases/download/v0.0.5/woof_Darwin_arm64.tar.gz"
    sha256 "ea57215bcdb76905423d54a002c57f82b1e7ccc4ae89f68698dcc0c9a4332fb3"
  else
    url "https://github.com/gplassard/woof/releases/download/v0.0.5/woof_Darwin_x86_64.tar.gz"
    sha256 "c8da12e5f6079b950c2fa62ea8b5fa8ced5418089ccf3b9bc94351c49a575e27"
  end

  license ""

  def install
    bin.install "woof"
  end

  test do
    system "#{bin}/woof", "--help"
  end
end
