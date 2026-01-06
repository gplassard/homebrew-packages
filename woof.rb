# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Woof < Formula
  desc ""
  homepage ""

  if Hardware::CPU.arm?
    url "https://github.com/gplassard/woof/releases/download/v0.0.3/woof_Darwin_arm64.tar.gz"
    sha256 "06830ce199792a313a4fbcb139d524fd609cad4a549e64e20a51d0bcdd333510"
  else
    url "https://github.com/gplassard/woof/releases/download/v0.0.3/woof_Darwin_x86_64.tar.gz"
    sha256 "b63ea0a4c8d3f96fa0e4125fe1254a614efd8425e2f4e25cac7fa4f92a57fc2a"
  end

  license ""

  def install
    bin.install "woof"
  end

  test do
    system "#{bin}/woof", "--help"
  end
end
