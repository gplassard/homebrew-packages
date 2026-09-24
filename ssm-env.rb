# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class SsmEnv < Formula
  desc ""
  homepage ""
  url "https://github.com/gplassard/ssm-env/releases/download/v0.5.2/ssm-env-x86_64-apple-darwin"
  sha256 "7a096c6170e044a9e8f9924517ba9aa77635396dc183914b13f804fba5fa1eaf"
  license ""

  on_arm do
    url "https://github.com/gplassard/ssm-env/releases/download/v0.5.2/ssm-env-aarch64-apple-darwin"
    sha256 "ab6487adefad28f58ef64bd69c737465d6e45ab2ffc9f17ed11ea314c72d5a0f"
  end

  def install
    if Hardware::CPU.arm?
      bin.install "ssm-env-aarch64-apple-darwin" => "ssm-env"
    else
      bin.install "ssm-env-x86_64-apple-darwin" => "ssm-env"
    end
  end

  test do
    system "#{bin}/ssm-env", "--version"
  end
end
