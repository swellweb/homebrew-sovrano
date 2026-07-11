class Sovranx < Formula
  desc "CPU inference server that gets faster the longer it runs"
  homepage "https://github.com/swellweb/sovranx"
  url "https://github.com/swellweb/sovranx.git",
      tag:      "v0.1.1",
      revision: "4e00721ce7403af64ee34ed684b05fef214bba15"
  license "MIT"
  head "https://github.com/swellweb/sovranx.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "nlohmann-json" => :build
  depends_on "zstd"

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DCMAKE_BUILD_TYPE=Release",
           "-DSOVRANX_BUILD_TESTS=OFF",
           *std_cmake_args
    system "cmake", "--build", "build", "--parallel"
    bin.install "build/src/sovranx"
    pkgshare.install "config/sovranx.conf" => "sovranx.conf.example"
  end

  def caveats
    <<~EOS
      Zero-config start (downloads a small model on first use):
        sovranx run qwen2.5-1.5b

      Or with a config file for full control:
        cp #{pkgshare}/sovranx.conf.example ~/sovranx.conf
        # edit model.path, then:
        sovranx --config ~/sovranx.conf --serve
    EOS
  end

  test do
    assert_match "sovranx", shell_output("#{bin}/sovranx --version")
  end
end
