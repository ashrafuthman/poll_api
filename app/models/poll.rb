class Poll < ApplicationRecord
    has_many :options, dependent: :delete_all
end
