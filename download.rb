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
download_dir = ENV['DOWNLOAD_DIR'] || '/download'

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
  sleep 10
  session.find(:xpath, '//span[text()="Download"]').click
  sleep 5

  loop do
    sleep 1
    break unless Dir.entries(download_dir).to_s.include? '.zip.part'
  end

elsif mode == 'root_files'
  sleep 10
  # only download files in the root directory, no recursion
  elements = session.all(:xpath, '//div[contains(@class, "is-file")]//span[@class="ItemCheck"]')
  elements.each do |el|
    # puts el.find(:xpath, '//div[@class="ItemTile-name"]').text
    puts " > Hover+Click on a file..."
    el.hover
    sleep 2
    el.click
    sleep 2
  end
  puts "Downloading #{elements.count} elements to #{download_dir}"
  session.find(:xpath, '//span[text()="Download"]').click
  puts " > 'Download' link clicked"
  sleep 10

  loop do
    puts " > in progress"
    sleep 1
    # listing = Dir.entries(download_dir)
    # break unless ( listing.to_s.include? '.kml.part' || listing.count < elements.count+2 )
    break unless Dir.entries(download_dir).to_s.include? '.zip.part'
  end
  puts " > done"

end
