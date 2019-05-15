# frozen_string_literal: true

require './require_app'
require_app

run CGroup2::App.freeze.app
