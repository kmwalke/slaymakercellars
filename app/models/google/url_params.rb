## This uses Google's URL Params Library.
# https://developers.google.com/maps/documentation/urls/get-started

module Google
  class UrlParams
    PIPE_CHAR             = '%7C'.freeze
    LEFT_CURL_BRACE_CHAR  = '%7B'.freeze
    RIGHT_CURL_BRACE_CHAR = '%7D'.freeze

    private_class_method def self.sanitize(string)
      string.gsub(' ', '+').gsub('|', PIPE_CHAR).gsub('{', LEFT_CURL_BRACE_CHAR).gsub('}', RIGHT_CURL_BRACE_CHAR)
    end
  end
end
