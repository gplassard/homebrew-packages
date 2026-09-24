# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class PrettyLogs < Formula
  desc ""
  homepage ""
  url "https://github.com/gplassard/pretty-logs/releases/download/v1.2.0/pretty-logs-x86_64-apple-darwin"
  sha256 "34c3fd46438aa531307c35bb9d6cb6c41395a8160321c78b1030b379ef457b46"
  license ""

  def install
    bin.install "pretty-logs-x86_64-apple-darwin"
    mv bin/"pretty-logs-x86_64-apple-darwin", bin/"pretty-logs"
  end

  test do
    system "#{bin}/pretty-logs", "--version"
  end
end
