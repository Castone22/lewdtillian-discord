require "google/apis/sheets_v4"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"

module Lewdtillian
  class NameList

    OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
    APPLICATION_NAME = "Lewdtillian".freeze
    CREDENTIALS_PATH = "#{__dir__}/../../tokens/summer-monument-209904-717128bee0de.json".freeze
    SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY
    RANGE = "NameList!A2:D"
    SPREADSHEET_ID = "1hhD1CJEZ6prYWEC9PmnyiDeBPNJNsUAvNfmUqkj_Mrs"

    def auth
      @service = Google::Apis::SheetsV4::SheetsService.new
      @service.client_options.application_name = APPLICATION_NAME
      @service.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: key_io,
        scope: SCOPE
      )
    end

    def key_io
      return File.open(CREDENTIALS_PATH) if File.exist?(CREDENTIALS_PATH)
      StringIO.new(ENV['GOOGLE_AUTH_JSON'])
    end

    def initialize
      auth
    end

    def names
      @names || refresh
    end

    def refresh
      response = @service.get_spreadsheet_values SPREADSHEET_ID, RANGE
      @names = response.values.each_with_object({ first_names: [], last_names: [], titles: [], mods: [] }) do |row, hash|
        hash.keys.each_with_index do |key, index|
          hash[key] << row[index] unless row[index].nil? || row[index].empty?
        end
      end
    end

    def generate_name
      name = Array.new(rand(1..4)) { |index| index }
      name.map! { |index| names[names.keys[index]].sample }
      use_mod = rand(0..20) > 15 
      if name.size == 1
        mod = @names[:mods].sample if use_mod
        "#{name[0]}#{mod}"
      else
        mod = name.delete_at(3)
        mod = nil unless use_mod
        name[0] = "#{name[0]}#{name.delete_at(1)}" if name[0][-1] == '-'
        name.insert(-2, 'the') if name.size >= 3
        name[1] = "#{name[1]}#{mod}"
        name.join(' ')
      end
    end
  end

end

