require 'capybara'
require 'selenium/webdriver'

starting_url = ARGV[0]
if starting_url.empty?
  $stderr.puts "No folder URL provided"
  exit 1
end

puts "URL: #{starting_url}"
mode = ARGV[1]

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

if mode.nil?
  # default mode, download zipped folder
  sleep 5
  session.find(:xpath, '//span[text()="Download"]').click
  sleep 5

  loop do
    sleep 1
    break unless Dir.entries(download_dir).to_s.include? '.zip.part'
  end

elsif mode == 'root_files'
  sleep 5
  # only download files in the root directory, no recursion
  elements = session.all(:xpath, '//div[contains(@class, "is-file")]//div[@class="ItemTile-name"]')
  elements.each do |el|
    puts el.text
    el.click
    sleep 2
  end
  puts "Downloading #{elements.count} elements"

  loop do
    sleep 1
    listing = Dir.entries(download_dir)
    break unless ( listing.to_s.include? '.kml.part' || listing.count < elements.count+2 )
  end

end
