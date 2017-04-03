require 'capybara'
require 'selenium/webdriver'

starting_url = ARGV[0]
if starting_url.empty?
  $stderr.puts "No folder URL provided"
  exit 1
end

puts "URL: #{starting_url}"

# set as container volume, change for local test without container
download_dir = '/download'

Capybara.register_driver :firefox_auto_download do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile['browser.download.dir'] = download_dir
  profile['browser.download.folderList'] = 2
  profile['browser.download.manager.showWhenStarting'] = true
  profile['browser.helperApps.neverAsk.saveToDisk'] = "application/zip, application/octet-stream"
  Capybara::Selenium::Driver.new(app, browser: :firefox, profile: profile)
end

session = Capybara::Session.new(:firefox_auto_download)
session.visit(starting_url)
sleep 5
session.find(:xpath, '//span[text()="Download"]').click
sleep 5

loop do
  sleep 1
  break unless Dir.entries(download_dir).to_s.include? '.zip.part'
end
