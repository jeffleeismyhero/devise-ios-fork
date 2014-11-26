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
