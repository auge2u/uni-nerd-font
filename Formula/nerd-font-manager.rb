class NerdFontManager < Formula
  desc "CLI and GUI utility for managing Nerd Fonts on macOS via Homebrew"
  homepage "https://github.com/auge2u/uni-nerd-font"
  url "https://github.com/auge2u/uni-nerd-font/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "91d8bbe3fb77e9e45ec6243daec1d04ade7588a958b1078c6dfc5044193b0995"
  version "1.0.2"
  license "MIT"

  depends_on "fzf" => :recommended
  depends_on :macos

  def install
    bin.install "nerd-font-manager.sh" => "nerd-font-manager"
    zsh_completion.install "completions/_nerd-font-manager"
    bash_completion.install "completions/nerd-font-manager.bash"
    fish_completion.install "completions/nerd-font-manager.fish"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/nerd-font-manager --help")
  end
end
