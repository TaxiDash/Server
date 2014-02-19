class Driver < ActiveRecord::Base
    has_many :ratings

    #Regex expressions defining valid input
    LETTERS_ONLY = /[a-zA-Z]*/

    #Possible type options to be stored in the database
    #Add more types by modifying the following statement to
    # TYPE_OPTIONS = /(type1|type2|type3|type4)/
    # where type1, type2... are replaced with the acceptable
    # names of the different types. The number of types is 
    # flexible and can be any number of options
    TYPE_OPTIONS = /(taxi|wrecker)/
    SEX_OPTIONS = /(male|female)/

    # Uncomment the following when status options are known
    # STATUS_OPTIONS = /(status1|status2)/

    # Length validations
    validates :license, length: { is: 9, message: 'must be 9 digits long.' }
    validates :phone_number, length: { is: 10, message: 'must be 10 digits long.' }
    validates :zipcode, length: { is: 5, message: 'must be 5 digits long.'  }
    # validates :permit_number, length: { is: 5, message: 'Permit must be 5 digits long.'  }

    # LETTERS_ONLY validations
    validates :city, format: { with: Regexp.new('\A' + LETTERS_ONLY.source + '\z'), 
                                 message: 'can only contain letters.' }
    validates :race, format: { with: Regexp.new('\A' + LETTERS_ONLY.source + '\z'), 
                                 message: 'can only contain letters.' }
    validates :company_name, format: { with: Regexp.new('\A' + LETTERS_ONLY.source + '\z'), 
                                 message: 'can only contain letters.' }

    # For now, the owner will be letters only. Later this may be adjusted to be more specific
    validates :owner, format: { with: Regexp.new('\A' + LETTERS_ONLY.source + '\z'), 
                                 message: 'can only contain letters.' }

    # Specific input validations
    #validates :typeid, format: { with: Regexp.new('\A' + TYPE_OPTIONS.source + '\z'), 
                                 #message: 'must be a valid type.' }
    validates :sex, format: { with: Regexp.new('\A' + SEX_OPTIONS.source + '\z'), 
                                 message: 'must be a valid type.' }
    #validates :status, format: { with: Regexp.new('\A' + STATUS_OPTIONS.source + '\z'), 
    #                             message: 'Status must be a valid type.' }
end
