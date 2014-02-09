# -*- encoding: utf-8 -*-
# stub: safe_attributes 1.0.10 ruby lib

Gem::Specification.new do |s|
  s.name = "safe_attributes"
  s.version = "1.0.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.8.10") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Brian Jones"]
  s.date = "2013-03-07"
  s.description = "Better support for legacy database schemas for ActiveRecord, such as columns named class, or any other name that conflicts with an instance method of ActiveRecord."
  s.email = "cbjones1@gmail.com"
  s.homepage = "http://github.com/bjones/safe_attributes"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.0"
  s.summary = "Useful for legacy database support, adds support for reserved word column names with ActiveRecord"

  s.installed_by_version = "2.2.0" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 3.0.0"])
      s.add_development_dependency(%q<rake>, [">= 0.8.7"])
      s.add_development_dependency(%q<rdoc>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 2.3.0"])
    else
      s.add_dependency(%q<activerecord>, [">= 3.0.0"])
      s.add_dependency(%q<rake>, [">= 0.8.7"])
      s.add_dependency(%q<rdoc>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 2.3.0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 3.0.0"])
    s.add_dependency(%q<rake>, [">= 0.8.7"])
    s.add_dependency(%q<rdoc>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 2.3.0"])
  end
end
