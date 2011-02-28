class Customer < ActiveRecord::Base
  find_by_autocomplete :name
  
  # Restricciones
  validates :name, :identification, :presence => true
  validates :identification, :uniqueness => true, :allow_nil => true,
    :allow_blank => true
  validates :name, :uniqueness => {:scope => :lastname}, :allow_nil => true,
    :allow_blank => true
  validates :name, :lastname, :identification, :length => {:maximum => 255},
    :allow_nil => true, :allow_blank => true
  validates :free_monthly_bonus, :allow_nil => true, :allow_blank => true,
    :numericality => {:greater_than_or_equal_to => 0}

  # Relaciones
  has_many :prints, :inverse_of => :customer, :dependent => :nullify
  has_many :bonuses, :inverse_of => :customer, :dependent => :destroy,
    :class_name => 'Bonus', :order => 'valid_until ASC'

  def to_s
    [self.name, self.lastname].compact.join(' ')
  end

  def free_credit
    self.bonuses.valids.sum('remaining')
  end

  def use_credit(amount)
    to_pay = BigDecimal.new(amount.to_s)
    available_bonuses = self.bonuses.valids.order('valid_until DESC').to_a

    Bonus.transaction do
      while to_pay > 0 && available_bonuses.size > 0
        bonus = available_bonuses.shift
        remaining = bonus.remaining

        if remaining >= to_pay
          bonus.remaining = remaining - to_pay
          to_pay = 0
        else
          bonus.remaining = 0
          to_pay -= remaining
        end

        bonus.save!
      end
    end

    to_pay
  end
end