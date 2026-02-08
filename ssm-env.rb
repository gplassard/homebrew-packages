# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class SsmEnv < Formula
  desc ""
  homepage ""
  url "https://github.com/gplassard/ssm-env/releases/download/v0.4.1/ssm-env-x86_64-apple-darwin"
  sha256 "9e6b374f45e03733a6322367d05468b367c816c483b79ac9dbc20e74d6e49ecb"
  license ""

  def install
    bin.install "ssm-env-x86_64-apple-darwin"
    mv bin/"ssm-env-x86_64-apple-darwin", bin/"ssm-env"
  end

  test do
    system "#{bin}/ssm-env", "--version"
  end
end
