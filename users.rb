require_relative 'questions_db'
require_relative 'questions'

class User
  attr_accessor :first_name, :last_name

  def self.all
    data = QuestionsDBConnection.instance.execute("SELECT * FROM questions")
    data.map { |datum| Questions.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @first_name = options['first_name']
    @last_name = options['last_name']
  end

  def self.find_by_name(first_name, last_name)
    user_data = QuestionsDBConnection.instance.execute(<<-SQL, first_name, last_name)
      SELECT
        *
      FROM
        users
      WHERE
        users.first_name = ? AND users.last_name = ?
    SQL
    User.new(user_data.first)
  end

  def authored_questions
    Questions.find_by_author_id(@id)
  end

  def authored_replies
    Replies.find_by_user_id(@id)
  end

  def self.find_by_user_id(id)
    user_data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    User.new(user_data.first)
  end



end
