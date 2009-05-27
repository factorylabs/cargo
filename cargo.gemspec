# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cargo}
  s.version = "0.0.2.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Factory Design Labs"]
  s.date = %q{2009-05-27}
  s.description = %q{http://www.factorylabs.com/images/cargo.png  Cargo is a set of tools to help streamline using git and Pivotal Tracker for agile development. Starting a story creates  a new branch and finishing a story merges the branch back into master.  This can be done either with browser integration or a set of command line tools.  More features will be added.  This is still alpha software}
  s.email = ["interactive@factorylabs.com"]
  s.executables = ["cargo", "hack", "pack", "ship", "yank"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "bin/cargo", "bin/hack", "bin/pack", "bin/ship", "bin/yank", "files/cargo.user.js", "files/cargo.png", "lib/cargo.rb", "lib/cargo/cargo_server.rb", "lib/cargo/commands/base.rb", "lib/cargo/commands/hack.rb", "lib/cargo/commands/pack.rb", "lib/cargo/commands/ship.rb", "lib/cargo/commands/yank.rb", "lib/cargo/config.rb", "test/base_test.rb", "test/config_test.rb", "test/hack_test.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://www.factorylabs.com/images/cargo.png}
  s.post_install_message = %q{}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{cargo}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{http://www.factorylabs.com/images/cargo.png  Cargo is a set of tools to help streamline using git and Pivotal Tracker for agile development}
  s.test_files = ["test/base_test.rb", "test/config_test.rb", "test/hack_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 0.9.1"])
      s.add_runtime_dependency(%q<tpope-pickler>, [">= 0.0.8"])
      s.add_development_dependency(%q<newgem>, [">= 1.3.0"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<rack>, [">= 0.9.1"])
      s.add_dependency(%q<tpope-pickler>, [">= 0.0.8"])
      s.add_dependency(%q<newgem>, [">= 1.3.0"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 0.9.1"])
    s.add_dependency(%q<tpope-pickler>, [">= 0.0.8"])
    s.add_dependency(%q<newgem>, [">= 1.3.0"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
