class NerdFontManager < Formula
  desc "CLI and GUI utility for managing Nerd Fonts on macOS via Homebrew"
  homepage "https://github.com/auge2u/uni-nerd-font"
  url "https://github.com/auge2u/uni-nerd-font/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "aea99bb72da8878231f310ebc35f01f17482923747c62222cab7fb9b4135a6bc"
  version "1.0.0"
  license "MIT"

  depends_on "fzf" => :recommended
  depends_on :macos

  def install
    bin.install "nerd-font-manager.sh" => "nerd-font-manager"
    zsh_completion.install "completions/_nerd-font-manager"
    bash_completion.install "completions/nerd-font-manager.bash"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/nerd-font-manager --help")
  end
end
