#
#  Rakefile
#
#  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
#

require "json"
require "net/http"
require "uri"

desc "Check the code review status"
task "review" do
  uri = URI.parse("https://api.netguru.co/review?token=#{ENV["DASHGURU_API_TOKEN"]}")
  response = Net::HTTP.get_response(uri)
  if response.code.to_i == 200
    result = JSON.parse(response.body)
    begin
      rejected_commits = result["commits_by_state"]["rejected"].to_int
    rescue
      report_error "An error occured when checking the review status."
    end
    if rejected_commits > 0
      report_failure "Cannot proceed with build, there are #{rejected_commits} rejected commits"
    else
      report_success "Proceeding with build, there are no rejected commits."
    end
  else
    report_error "An error occured when checking the review status."
  end
end

desc "Install project dependencies"
task "install" do
  sh "pod install --no-integrate"
end

desc "Run the unit tests"
task "test" do
  xcode_run "clean test"
end

desc "Build app and distribute"
task "build-and-distribute" do
  build_and_distribute
end

################################################################################

def xcode_workspace
  ENV["XCODE_WORKSPACE"]
end

def xcode_scheme
  ENV["XCODE_SCHEME"]
end

def xcode_sdk
  ENV["XCODE_SDK"]
end

def branch
  ENV["TRAVIS_BRANCH"]
end

def environment
  'Release'
end

def infoplist_path
  ENV["XCODE_INFOPLIST_PATH"]
end

def bundle_id
  `/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' '#{infoplist_path}'`.strip
end

def project_name
  @project_name ||= `/usr/libexec/PlistBuddy -c 'Print :CFBundleDisplayName' '#{infoplist_path}'`.strip
end

def display_name
  project_name
end

def build_dir
  ENV["TRAVIS_BUILD_DIR"]
end

def workspace_path
  "#{build_dir}/#{ENV['XCODE_WORKSPACE']}"
end

def build_config
  {
    workspace: workspace_path,
    configuration: environment,
  }
end

def build_number
  ENV["TRAVIS_BUILD_NUMBER"]
end

def set_bundle_params
  report_info "Setting 'CFBundleVersion' in '#{infoplist_path}' to '#{build_number}'"
  sh "/usr/libexec/PlistBuddy -c 'Set :CFBundleVersion #{build_number}' '#{infoplist_path}'"

  report_info "Setting 'CFBundleIdentifier' in '#{infoplist_path}' to '#{bundle_id}'"
  sh "/usr/libexec/PlistBuddy -c 'Set :CFBundleIdentifier #{bundle_id}' '#{infoplist_path}'"

  report_info "Setting 'CFBundleDisplayName' in '#{infoplist_path}' to '#{bundle_id}'"
  sh "/usr/libexec/PlistBuddy -c 'Set :CFBundleDisplayName #{display_name}' '#{infoplist_path}'"
end

def testflight_list
    project_name
end

def certs_dir
  ENV["CERTS_DIR"]
end

def profile_filename
  "DeviseDemoDistribution.mobileprovision"
end

def masked_sh(command, masked_strings)
  masked_command = command
  masked_strings.each do |masked_string|
    masked_command = masked_command.sub(masked_string, "[secure]")
  end
  puts masked_command
  system command
end

################################################################################

def build_and_distribute
  keychain_name = "distribution.keychain"
  keychain_password = "distribution"

  report_info "Creating keychain '#{keychain_name}'"
  sh "security create-keychain -p '#{keychain_password}' '#{keychain_name}'"
  sh "security unlock-keychain -p '#{keychain_password}' '#{keychain_name}'"
  sh "security set-keychain-settings '#{keychain_name}'"
  sh "security default-keychain -s '#{keychain_name}'"

  report_info "Importing authority certificates from '#{certs_dir}'"
  sh "security import '#{certs_dir}/'*.cer -k '#{keychain_name}' -A"

  cert_passphrase = ENV["CERT_PASSPHRASE"]

  report_info "Importing distribution certificates from '#{certs_dir}'"
  masked_sh "security import '#{certs_dir}'/*.p12 -P '#{cert_passphrase}' -k '#{keychain_name}' -A", [cert_passphrase]

  profile_dest_dir = File.expand_path("~/Library/MobileDevice/Provisioning Profiles")

  report_info "Copying profiles from '#{certs_dir}' to '#{profile_dest_dir}'"
  FileUtils.mkdir_p profile_dest_dir
  sh "cp '#{certs_dir}'/*.mobileprovision '#{profile_dest_dir}'"

  profile_path = "#{profile_dest_dir}/#{profile_filename}"

  set_bundle_params

  cert_name = ENV["CERT_NAME"]

  ipa_build_dir = File.expand_path("#{build_dir}/Build")
  ipa_build_flags = []
  ipa_build_flags << "--workspace '#{ENV["XCODE_WORKSPACE"]}'"
  ipa_build_flags << "--scheme 'Devise Demo'"
  ipa_build_flags << "--destination '#{ipa_build_dir}'"
  ipa_build_flags << "--embed '#{profile_path}'"
  ipa_build_flags << "--identity '#{cert_name}'"
  ipa_build_flags << "--no-clean"
  ipa_build_flags << "--configuration '#{environment}'"

  report_info "Building the application archive, this may take a while..."
  FileUtils.mkdir_p ipa_build_dir
  sh "ipa build #{ipa_build_flags.join(" ")}"
  report_failure "Failed to build the application archive", $?.exitstatus unless $?.success?

  FileUtils.cd ipa_build_dir do
    testflight_api_token = ENV["TESTFLIGHT_API_TOKEN"]
    testflight_team_token = ENV["TESTFLIGHT_TEAM_TOKEN"]

    testflight_release_number = ENV["TRAVIS_BUILD_NUMBER"]
    testflight_release_date = Time.new.strftime("%Y-%m-%d %H:%M:%S")
    testflight_release_notes = "Build: #{testflight_release_number}\nUploaded: #{testflight_release_date}"

    ipa_distribute_flags = []
    ipa_distribute_flags << "--api_token '#{testflight_api_token}'"
    ipa_distribute_flags << "--team_token '#{testflight_team_token}'"
    ipa_distribute_flags << "--notes '#{testflight_release_notes}'"
    ipa_distribute_flags << "--lists '#{testflight_list}'"

    report_info "Uploading the application archive to TestFlight, this may take a while..."
    masked_sh "ipa distribute:testflight #{ipa_distribute_flags.join(" ")}", [testflight_api_token, testflight_team_token]
    report_failure "Failed to upload the application archive to TestFlight", $?.exitstatus unless $?.success?
  end
end

################################################################################

def xcode_flags
  {
    "workspace" => xcode_workspace,
    "scheme" => xcode_scheme,
    "sdk" => xcode_sdk
  }.map do |key, value|
    "-#{key} #{value}"
  end.join " "
end

def xcode_run action
  flags = xcode_flags
  sh "xcodebuild #{flags} #{action} | xcpretty -c ; exit ${PIPESTATUS[0]}" rescue nil
  report_failure "Scheme '#{xcode_scheme}' failed to '#{action}'.", $?.exitstatus unless $?.success?
end

################################################################################

def report_success(message)
  report_common message, 2
end

def report_info(message)
  report_common message, 3
end

def report_error(message)
  report_common message, 1
end

def report_failure(message, status = 1)
  report_error message
  exit status
end

def report_common(message, color)
  color_formatter = `tput setaf #{color}`
  reset_formatter = `tput sgr 0`
  puts "#{color_formatter}#{message}#{reset_formatter}\n"
end