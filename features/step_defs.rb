Given(/^I write a comment with body "(.*?)"$/) do |body|
  comment = Comment.new(body)
  puts comment.body
end

Then(/^the comment's mentions should include the user "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end