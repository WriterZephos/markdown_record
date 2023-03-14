# frozen_string_literal: true

require "spec_helper"

RSpec.describe MarkdownRecord do
  it "has a version number" do
    expect(MarkdownRecord::VERSION).not_to be nil
  end
end