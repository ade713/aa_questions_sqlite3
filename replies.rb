require 'byebug'
require_relative "questions_db"
class Replies

  attr_accessor :question_id, :parent_reply_id, :author_id, :body

  def self.all
    data = RepliesDBConnection.instance.execute("SELECT * FROM replies")
    data.map { |datum| Replies.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @parent_reply_id = options['parent_reply_id']
    @author_id = options['author_id']
    @body = options['body']
  end


  def self.find_by_user_id(author_id)
    reply_data = QuestionsDBConnection.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.author_id = ?
    SQL
    Replies.new(reply_data.first)
  end

  def self.find_by_question_id(question_id)
    reply_data = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.question_id = ?
    SQL
    Replies.new(reply_data.first)
  end


end
