class Sovrano < Formula
  desc "CPU inference server that gets faster the longer it runs"
  homepage "https://github.com/swellweb/sovrano"
  url "https://github.com/swellweb/sovrano.git",
      tag:      "v0.1.0",
      revision: :any
  license "MIT"
  head "https://github.com/swellweb/sovrano.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "nlohmann-json" => :build
  depends_on "zstd"

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DCMAKE_BUILD_TYPE=Release",
           "-DSOVRANO_BUILD_TESTS=OFF",
           *std_cmake_args
    system "cmake", "--build", "build", "--parallel"
    bin.install "build/src/sovrano"
    pkgshare.install "config/sovrano.conf" => "sovrano.conf.example"
  end

  def caveats
    <<~EOS
      Sovrano needs a GGUF model and a config file to run:
        cp #{pkgshare}/sovrano.conf.example ~/sovrano.conf
        # edit model.path, then:
        sovrano --config ~/sovrano.conf --serve
    EOS
  end

  test do
    assert_match "sovrano", shell_output("#{bin}/sovrano --version")
  end
end
