class Comment
  attr_reader :body

  def initialize(body)
    @body = body
  end

  def mentions
    @body
      .split(/\s+/)
      .keep_if{ |word| word[0] == "@" }
      .map{ |word| word[1, word.length] }
  end
end
