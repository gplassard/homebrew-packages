# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class PrettyLogs < Formula
  desc ""
  homepage ""
  url "https://github.com/gplassard/pretty-logs/releases/download/v1.1.3/pretty-logs-x86_64-apple-darwin"
  sha256 "64d56305a78b74f05f21a4e36c00aa60f6f8cc6335ca7a43b200d38060671f94"
  license ""

  def install
    bin.install "pretty-logs-x86_64-apple-darwin"
    mv bin/"pretty-logs-x86_64-apple-darwin", bin/"pretty-logs"
  end

  test do
    system "#{bin}/pretty-logs", "--version"
  end
end
