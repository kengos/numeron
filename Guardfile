guard 'rspec', spec_paths: 'spec/numeron', keep_failed: true, all_on_start: false, all_after_pass: false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)/(.+)\.rb$})     { |m| "spec/numeron/#{m[2]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end