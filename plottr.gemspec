# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "plottr"
  s.version = File.read("version.txt")
  s.license = "MIT"
  
  s.summary = "Ruby plotting library."
  s.description = "Plot all sorts of graphs with ruby."
  
  s.author = "Jan-Yves Ruzicka"
  s.email = "jan@1klb.com"
  s.homepage = "https://github.com/jyruzicka/plottr"
  
  s.files = File.read("Manifest").split("\n").select{ |l| !l.start_with?("#") && l != ""}
  s.require_paths << "lib"
  s.bindir = "bin"
  s.executables << "plottr"
  s.extra_rdoc_files = ["README.md", "CHANGELOG.md"]

  # Add runtime dependencies here
  #s.add_runtime_dependency "commander", "~> 4.1.2"
end
