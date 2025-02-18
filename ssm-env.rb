# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class SsmEnv < Formula
  desc ""
  homepage ""
  url "https://github.com/gplassard/ssm-env/releases/download/v0.2.2/ssm-env-x86_64-apple-darwin"
  sha256 "35cf768928e13cf04474f4db5991499ae80e6c44f1943b338c53c14fd24b9ac6"
  license ""

  def install
    bin.install "ssm-env-x86_64-apple-darwin"
    mv bin/"ssm-env-x86_64-apple-darwin", bin/"ssm-env"
  end

  test do
    system "#{bin}/ssm-env", "--version"
  end
end
