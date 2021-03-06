# frozen_string_literal: true

# Parses Json information as needed

# Converts keys of json or hash into symbols
class JsonRequestBody
    def self.parse_symbolize(json_str)
      parsed = JSON.parse(json_str)
      Hash[parsed.map { |k, v| [k.to_sym, v] }]
    end
  
    def self.symbolize(hash)
      Hash[hash.map { |k, v| [k.to_sym, v] }]
    end
  end
  