# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'numeron/version'

Gem::Specification.new do |gem|
  gem.name          = "numeron"
  gem.version       = Numeron::VERSION
  gem.authors       = ["kengos"]
  gem.email         = ["kengo@kengos.jp"]
  gem.description   = %q{numer0nの解を計算します。すべてのアイテム(ダブル, チェンジ, スラッシュ, シャッフル, ターゲット, ハイアンドロー)に対応。シミュレーター付き, Analyzerは適当)}
  gem.summary       = %q{numer0n solver.}
  gem.homepage      = "https://github.com/kengos/numeron"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rspec'
end
