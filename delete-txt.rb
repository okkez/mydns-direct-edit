#!/usr/bin/env ruby
require "net/http"
require "uri"
require "yaml"

MYDNS_URL = "https://www.mydns.jp/directedit.html"

CERTBOT_ENV_NAMES = %w[
  CERTBOT_DOMAIN
  CERTBOT_VALIDATION
  CERTBOT_TOKEN
  CERTBOT_CERT_PATH
  CERTBOT_KEY_PATH
  CERTBOT_SNI_DOMAIN
  CERTBOT_AUTH_OUTPUT
]

domain = ENV["CERTBOT_DOMAIN"]

configs = YAML.load_file(File.join(__dir__, "config.yml"))
account = configs[domain]

params = {}
CERTBOT_ENV_NAMES.each do |key|
  params[key] = ENV[key]
end

params["EDIT_CMD"] = "DELETE"

uri = URI.parse(MYDNS_URL)

Net::HTTP.start(uri.host, port: uri.port) do |http|
  request = Net::HTTP::Post.new(uri.path)
  request.basic_auth(account["master_id"], account["master_password"])
  request.set_form_data(params)
  response = http.request(request)
  p response
  pp response.body
end
