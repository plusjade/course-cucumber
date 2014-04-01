Given(/^I write a comment with body "(.*?)"$/) do |body|
  @comment = Comment.new(body)
  puts @comment.body
end

Then(/^the comment's mentions should include the (?:user|users) "(.*?)"$/) do |names|
  names = names.split(',').map{ |a| a.strip }

  names.each do |name|
    expect(@comment.mentions).to include(name)
  end
end
