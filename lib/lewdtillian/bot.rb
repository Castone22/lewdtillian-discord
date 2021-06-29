require 'discordrb'
require 'faker'
require 'active_support/inflector'
require_relative 'name_list'
require 'pry'

name_list = Lewdtillian::NameList.new

token = File.read("#{__dir__}/../../tokens/discord.token")
token ||= ENV['DISCORD_TOKEN']

bot = Discordrb::Bot.new token: token

bot.message(with_text: '~!ping') do |event|
  event.respond 'Pong!'
end

bot.message(with_text: /~!refresh/) do |event|
  name_list.refresh
  event.respond 'Refreshed'
end

bot.message(start_with: /~!name \d+/) do |event|
  captures = event.message.content.match(/~!name (\d+)/).captures
  number = captures[0].to_i || 5
  names = number.times.collect do
    name_list.generate_name
  end
  event.respond "\n#{names.join("\n")}"
end

bot.message(start_with: /~!name list/) do |event|
  event.respond 'https://docs.google.com/spreadsheets/d/1hhD1CJEZ6prYWEC9PmnyiDeBPNJNsUAvNfmUqkj_Mrs'
end

bot.message(start_with: /~!average/) do |event|
  captures = event.message.content.match(/~!average (\w+)/).captures
  payload = {program: "output #{captures[0]}"}
  uri = URI('https://anydice.com/createLink.php')
  res = Net::HTTP.post_form(uri, **payload)
  event.respond res.body
end

bot.run