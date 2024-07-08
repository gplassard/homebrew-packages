# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Jaw < Formula
  desc ""
  homepage ""
  url "https://github.com/gplassard/jaw/releases/download/v0.0.6/jaw-0.0.6.zip"
  sha256 "0a7d9297e957b73f1058642c62c488a73c29c3106c1bd5b2efc63bf79b9d9f16"
  license ""

  def install
    bin.install "bin/jaw"
    (lib).install Dir["lib/*"]
  end

  test do
    system "#{bin}/jaw", "version"
  end
end
