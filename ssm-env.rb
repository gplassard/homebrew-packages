# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class SsmEnv < Formula
  desc ""
  homepage ""
  url "https://github.com/gplassard/ssm-env/releases/download/v0.5.1/ssm-env-x86_64-apple-darwin"
  sha256 "d236b12991bc8b716a32a014d1e60a9437a63094fd78e2b4002d8e91f80c034d"
  license ""

  on_arm do
    url "https://github.com/gplassard/ssm-env/archive/refs/tags/v0.4.1.tar.gz"
    sha256 "e22fce588f20deda52184a4a61f276ab2f2880ca9c48064e8919c7abcd5651e2"
    depends_on "rust" => :build
  end

  def install
    if Hardware::CPU.arm?
      system "cargo", "install", *std_cargo_args(path: ".")
    else
      bin.install "ssm-env-x86_64-apple-darwin"
      mv bin/"ssm-env-x86_64-apple-darwin", bin/"ssm-env"
    end
  end

  test do
    system "#{bin}/ssm-env", "--version"
  end
end
