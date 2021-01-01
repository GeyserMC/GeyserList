hash = `git rev-parse HEAD`.strip
branch = `git rev-parse --abbrev-ref HEAD`.strip
Rails.cache.write("version/name", "git-#{branch}-#{hash[0..6]}")
Rails.cache.write("version/url", "https://github.com/Chew/GeyserList/compare/#{hash}...#{branch}")