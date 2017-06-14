
require_relative 'questions_db'

class Questions

  attr_accessor :title, :body, :author_id

  def self.all
    data = QuestionsDBConnection.instance.execute("SELECT * FROM questions")
    data.map { |datum| Questions.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def self.find_by_author_id(author_id)
    questions_data = QuestionsDBConnection.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.author_id = ?
    SQL
    # questions_data.map { |question_data| Questions.new(question_data) }
    Questions.new(questions_data.first)
  end



  def author
  end

  def replies
    #using replies.find_by_question_id
  end
end




#
#
# class Question < ModelBase
#   def self.find(id)
#     question_data = QuestionsDatabase.get_first_row(<<-SQL, id: id)
#       SELECT
#         questions.*
#       FROM
#         questions
#       WHERE
#         questions.id = :id
#     SQL
#
#     Question.new(question_data)
#   end
