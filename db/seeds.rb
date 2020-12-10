# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'yaml'

seeds = YAML.load_file(Rails.root.join('db', 'seeds.yml'))

seeds['platforms'].each do |platform|
  Platform.find_or_create_by!(platform: platform)
end

seeds['members'].each_pair do |_, info|
  member = Member.find_or_create_by!(info.extract!('name'))

  member.update!(info.extract!('avatar', 'color_main', 'color_sub', 'graduated'))

  seeds['platforms'].each do |platform|
    next unless info[platform]

    info[platform].each do |channel|
      Channel.find_or_create_by!(channel: channel, platform: Platform.find_by_platform(platform), member: member)
    end
  end
end