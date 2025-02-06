# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class SsmEnv < Formula
  desc ""
  homepage ""
  url "https://github.com/gplassard/ssm-env/releases/download/v0.2.1/ssm-env-x86_64-apple-darwin"
  sha256 "32e16da0afc6d2d5a4d046fb0a46869870391c9175144e6a42f1b0232bfefa2e"
  license ""

  def install
    bin.install "ssm-env-x86_64-apple-darwin"
    mv bin/"ssm-env-x86_64-apple-darwin", bin/"ssm-env"
  end

  test do
    system "#{bin}/ssm-env", "--version"
  end
end
