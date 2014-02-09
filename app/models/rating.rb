class Rating < ActiveRecord::Base
    belongs_to :driver
    validates :rating, format: { with: /[12345]/, 
                                 message: "Must be integer 1-5" }
    COMMENT_FORMAT = /[a-zA-Z. !?\d$"()]*/
    validates :comments, length: { maximum: 250 ,
                                   message: "must be 250 characters or fewer." } 
    validates :comments, format: { with: Regexp.new('\A' + COMMENT_FORMAT.source + '\z'), 
                                   message: "Contains invalid characters" }
end
