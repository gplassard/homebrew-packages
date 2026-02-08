# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class SsmEnv < Formula
  desc ""
  homepage ""
  url "https://github.com/gplassard/ssm-env/releases/download/v0.4.0/ssm-env-x86_64-apple-darwin"
  sha256 "f31ad339e481a17e428f05de1756ce0caf461ea6b22f5afba754e31991dd2e63"
  license ""

  def install
    bin.install "ssm-env-x86_64-apple-darwin"
    mv bin/"ssm-env-x86_64-apple-darwin", bin/"ssm-env"
  end

  test do
    system "#{bin}/ssm-env", "--version"
  end
end
