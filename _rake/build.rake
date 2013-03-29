
desc "Build posts & styles"
task :build => [:genposts, :lessc, :favicons] do
  # ...
end