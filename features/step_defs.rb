Given(/^I write a comment with body "(.*?)"$/) do |body|
  @comment = Comment.new(body)
  puts @comment.body
end

Then(/^the comment's mentions should include the user "(.*?)"$/) do |name|
  expect(@comment.mentions).to include(name)
end

Then(/^the comment's mentions should include the users "(.*?)" and "(.*?)"$/) do |name1, name2|
  expect(@comment.mentions).to include(name1)
  expect(@comment.mentions).to include(name2)
end
