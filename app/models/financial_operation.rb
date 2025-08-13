class FinancialOperation < ApplicationRecord
  # === ASSOCIATIONS ===
  belongs_to :company
  belongs_to :property, optional: true
  belongs_to :associate, optional: true
  belongs_to :tenant, optional: true

  # === ENUMS ===
  enum :category, {
    income: "recette",
    expense: "dépense",
    contribution: "apport",
    refund: "remboursement"
  }, prefix: true

  enum :operation_type, {
    rent: "loyer",
    charges: "charges",
    insurance: "assurance",
    tax: "taxe",
    maintenance: "travaux",
    initial_contribution: "apport initial",
    current_account_contribution: "apport en compte courant",
    current_account_refund: "remboursement compte courant",
    other: "autre"
  }, prefix: true

  # === VALIDATIONS ===
  validates :label, presence: true, length: { minimum: 3, maximum: 255 }
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :operation_date, presence: true
  validates :category, presence: true, inclusion: { in: categories.keys }

  # Ensure operation_type is compatible with category
  validate :operation_type_allowed_for_category

  # Validations conditionnelles
  validates :associate, presence: true, if: -> { category_contribution? || category_refund? }
  validates :tenant, presence: true, if: -> { operation_type_rent? }
  validates :property, presence: true, if: -> { property_related_operation? }

  # === SCOPES ===
  scope :incomes, -> { where(category: "income") }
  scope :expenses, -> { where(category: "expense") }
  scope :contributions, -> { where(category: "contribution") }
  scope :refunds, -> { where(category: "refund") }

  scope :by_year, ->(year) { where(operation_date: Date.new(year).beginning_of_year..Date.new(year).end_of_year) }
  scope :by_month, ->(month, year) { where(operation_date: Date.new(year, month).beginning_of_month..Date.new(year, month).end_of_month) }
  scope :by_property, ->(property) { where(property: property) }
  scope :by_associate, ->(associate) { where(associate: associate) }

  scope :ordered_by_date, -> { order(operation_date: :desc) }
  scope :recent, -> { order(created_at: :desc) }

  # === CALLBACKS ===
  before_save :set_operation_type_if_blank
  after_create :update_associate_current_account_balance
  after_destroy :revert_associate_current_account_balance

  # === INSTANCE METHODS ===

  # Retourne le montant avec le bon signe selon la catégorie
  def signed_amount
    case category
    when "income", "contribution"
      amount
    when "expense", "refund"
      -amount
    end
  end

  # Vérifie si l'opération affecte le résultat de la SCI
  def affects_result?
    category_income? || category_expense?
  end

  # Vérifie si l'opération affecte les comptes courants associés
  def affects_associate_current_account?
    category_contribution? || category_refund?
  end

  # Retourne la description complète
  def full_description
    description = label
    description += " - #{property.address}" if property.present?
    description += " (#{associate.full_name})" if associate.present?
    description += " [#{tenant.full_name}]" if tenant.present?
    description
  end

  # Retourne le type d'icône pour l'affichage
  def icon_class
    case category
    when "income" then "fas fa-arrow-up text-success"
    when "expense" then "fas fa-arrow-down text-danger"
    when "contribution" then "fas fa-plus-circle text-info"
    when "refund" then "fas fa-minus-circle text-warning"
    end
  end

  # Retourne la classe CSS pour la couleur du montant
  def amount_css_class
    case category
    when "income", "contribution" then "text-success"
    when "expense", "refund" then "text-danger"
    end
  end

  # === CLASS METHODS ===

  # Calcul du total par catégorie pour une période
  def self.total_by_category(start_date: nil, end_date: nil)
    scope = all
    scope = scope.where(operation_date: start_date..end_date) if start_date && end_date

    scope.group(:category).sum(:amount)
  end

  # Calcul du solde net (recettes - dépenses)
  def self.net_balance(start_date: nil, end_date: nil)
    totals = total_by_category(start_date: start_date, end_date: end_date)
    (totals["income"] || 0) - (totals["expense"] || 0)
  end

  # Calcul du total des recettes
  def self.total_income(start_date: nil, end_date: nil)
    scope = incomes
    scope = scope.where(operation_date: start_date..end_date) if start_date && end_date
    scope.sum(:amount)
  end

  # Calcul du total des dépenses
  def self.total_expenses(start_date: nil, end_date: nil)
    scope = expenses
    scope = scope.where(operation_date: start_date..end_date) if start_date && end_date
    scope.sum(:amount)
  end

  # Données pour graphiques (par mois)
  def self.monthly_data(year = Date.current.year)
    (1..12).map do |month|
      start_date = Date.new(year, month).beginning_of_month

      monthly_incomes = incomes.by_month(month, year).sum(:amount)
      monthly_expenses = expenses.by_month(month, year).sum(:amount)

      {
        month: I18n.l(start_date, format: "%b %Y"),
        incomes: monthly_incomes,
        expenses: monthly_expenses,
        balance: monthly_incomes - monthly_expenses
      }
    end
  end

  # Top propriétés par revenus
  def self.top_properties_by_income(limit: 5)
    joins(:property)
      .where(category: "income")
      .group(:property)
      .order("SUM(amount) DESC")
      .limit(limit)
      .sum(:amount)
  end

  private

  # Allowed operation types per category (keys of enums)
  ALLOWED_TYPES_BY_CATEGORY = {
    "income" => %w[rent charges other],
    "expense" => %w[charges insurance tax maintenance other],
    "contribution" => %w[initial_contribution current_account_contribution],
    "refund" => %w[current_account_refund]
  }.freeze

  def operation_type_allowed_for_category
    return if category.blank? || operation_type.blank?

    allowed = ALLOWED_TYPES_BY_CATEGORY[category]
    return if allowed.nil? # unknown category handled by inclusion validation above

    unless allowed.include?(operation_type)
      errors.add(
        :operation_type,
        :invalid,
        message: I18n.t(
          "errors.messages.operation_type_incompatible_with_category",
          default: "%{operation_type} n'est pas compatible avec la catégorie %{category}",
          operation_type: self.class.human_enum_name(:operation_type, operation_type),
          category: self.class.human_enum_name(:category, category)
        )
      )
    end
  end

  def property_related_operation?
    operation_type_rent? || operation_type_charges? ||
    operation_type_insurance? || operation_type_maintenance?
  end

  def set_operation_type_if_blank
    return if operation_type.present?

    # Auto-détection du type basé sur le libellé
    case label.downcase
    when /loyer|rent/
      self.operation_type = "rent"
    when /charge/
      self.operation_type = "charges"
    when /assurance|insurance/
      self.operation_type = "insurance"
    when /tax|taxe/
      self.operation_type = "tax"
    when /travaux|maintenance|réparation/
      self.operation_type = "maintenance"
    when /apport.*compte.*courant/
      self.operation_type = "current_account_contribution"
    when /remboursement.*compte.*courant/
      self.operation_type = "current_account_refund"
    else
      self.operation_type = "other"
    end
  end

  def update_associate_current_account_balance
    return unless affects_associate_current_account? && associate.present?

    case category
    when "contribution"
      associate.increment!(:current_account_balance, amount)
    when "refund"
      associate.decrement!(:current_account_balance, amount)
    end
  end

  def revert_associate_current_account_balance
    return unless affects_associate_current_account? && associate.present?

    case category
    when "contribution"
      associate.decrement!(:current_account_balance, amount)
    when "refund"
      associate.increment!(:current_account_balance, amount)
    end
  end
end
