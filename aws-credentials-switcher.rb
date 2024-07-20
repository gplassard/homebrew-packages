# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class AwsCredentialsSwitcher < Formula
  desc ""
  homepage ""
  url "https://github.com/gplassard/aws-credentials-switcher/releases/download/v1.9.12/aws-credentials-switcher-x86_64-apple-darwin"
  sha256 "ea78917e518201b1c1aee9d8be3456ff03e92e569a1f40c8f055180232e8742a"
  license ""

  def install
    bin.install "aws-credentials-switcher-x86_64-apple-darwin"
    mv bin/"aws-credentials-switcher-x86_64-apple-darwin", bin/"aws-credentials-switcher"
  end

  test do
    system "#{bin}/aws-credentials-switcher", "--version"
  end
end
