class Reame < Formula
  desc "CPU inference server that gets faster the longer it runs"
  homepage "https://github.com/swellweb/reame"
  url "https://github.com/swellweb/reame.git",
      tag:      "v0.1.4",
      revision: "ceb4fea4ffc9b4ab44db34ec91687ec3141d07c8"
  license "MIT"
  head "https://github.com/swellweb/reame.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "nlohmann-json" => :build
  depends_on "zstd"

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DCMAKE_BUILD_TYPE=Release",
           "-DREAME_BUILD_TESTS=OFF",
           *std_cmake_args
    system "cmake", "--build", "build", "--parallel"
    bin.install "build/src/reame"
    pkgshare.install "config/reame.conf" => "reame.conf.example"
  end

  def caveats
    <<~EOS
      Zero-config start (downloads a small model on first use):
        reame run qwen2.5-1.5b

      Or with a config file for full control:
        cp #{pkgshare}/reame.conf.example ~/reame.conf
        # edit model.path, then:
        reame --config ~/reame.conf --serve
    EOS
  end

  test do
    assert_match "reame", shell_output("#{bin}/reame --version")
  end
end
